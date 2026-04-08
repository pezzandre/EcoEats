-- File: server/Food/FoodBase.luau
local FoodBase = {}
FoodBase.__index = FoodBase

local FoodState = {
    FRESH = 1,
    RECOVERABLE = 2,
    SPOILED = 3
}
FoodBase.FoodState = FoodState

function FoodBase.new(model, recoverableTime, spoiledTime)
    local self = setmetatable({}, FoodBase)
    
    self.model = model
    self.recoverableTime = recoverableTime
    self.spoiledTime = spoiledTime
    
    self.currentState = FoodState.FRESH
    self.age = 0
    
    return self
end

function FoodBase:startAging()
    task.spawn(function()
        while self.currentState ~= FoodState.SPOILED do
            task.wait(1)
            self.age += 1
            self:checkExpiration()
        end
    end)
end

function FoodBase:checkExpiration()
    local previousState = self.currentState
    
    if self.age >= self.spoiledTime then
        self.currentState = FoodState.SPOILED
    elseif self.age >= self.recoverableTime then
        self.currentState = FoodState.RECOVERABLE
    end
    
    if self.currentState ~= previousState then
        self:onStateChanged()
    end
end

function FoodBase:onStateChanged()
    -- Questa funzione viene sovrascritta (Override) dal file del cibo specifico
end

-- ==========================================
-- NUOVO: SISTEMA DI RACCOLTA UNIVERSALE
-- ==========================================

-- Chiama questa funzione dallo script del cibo per attivare la raccolta
function FoodBase:setupPickup(mainPart, baseName)
    self.mainPart = mainPart
    self.baseName = baseName or self.model.Name
    
    -- Creiamo il pulsante "E"
    self.prompt = Instance.new("ProximityPrompt")
    self.prompt.ActionText = "Collect " .. self.baseName
    self.prompt.ObjectText = self.baseName
    self.prompt.HoldDuration = 0.5
    self.prompt.MaxActivationDistance = 8
    self.prompt.Parent = self.mainPart
    
    -- Quando premi "E", avvia la funzione pickup qui sotto
    self.prompt.Triggered:Connect(function(player)
        self:pickup(player)
    end)
end

-- La logica per raccogliere, dare monete e creare il Tool
function FoodBase:pickup(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    local coins = leaderstats and leaderstats:FindFirstChild("Coins")
    
    local reward = 0
    local toolName = self.baseName

    -- Controlliamo lo stato per assegnare monete e nome
    if self.currentState == FoodState.FRESH then
        reward = 3
        toolName = self.baseName .. " Fresh"
    elseif self.currentState == FoodState.RECOVERABLE then
        reward = 2
        toolName = self.baseName .. " Bruised"
    elseif self.currentState == FoodState.SPOILED then
        reward = 1
        toolName = self.baseName .. " Spoiled"
    end
    
    if coins then 
        coins.Value += reward 
        print("Collected " .. toolName .. "! +" .. reward .. " Coins.")
    end
    
    -- Creiamo il Tool
    local tool = Instance.new("Tool")
    tool.Name = toolName
    tool.RequiresHandle = true
    tool.CanBeDropped = true
    
    -- Salviamo lo stato del cibo come attributo invisibile
    tool:SetAttribute("FoodState", self.currentState)
    
    -- Salviamo il vero nome dell'ingrediente
    tool:SetAttribute("FoodName", self.baseName)

    -- 1. Creiamo l'Handle (il pezzo principale che si tiene in mano)
    local handle = self.mainPart:Clone()
    handle.Name = "Handle"
    handle:ClearAllChildren() -- Rimuove vecchi pulsanti o saldature
    handle.Anchored = false
    handle.Parent = tool
    
    -- 2. Troviamo TUTTI gli altri pezzi del cibo e li saldiamo all'Handle in automatico!
    for _, part in ipairs(self.model:GetDescendants()) do
        if part:IsA("BasePart") and part ~= self.mainPart then
            local partClone = part:Clone()
            partClone:ClearAllChildren()
            partClone.Anchored = false
            
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = handle
            weld.Part1 = partClone
            weld.Parent = handle
            
            partClone.Parent = tool
        end
    end
    
    -- Mettiamo il Tool nello zaino del giocatore
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        tool.Parent = backpack
    end
    
    -- Distruggiamo il modello per terra
    self.model:Destroy()
end

return FoodBase