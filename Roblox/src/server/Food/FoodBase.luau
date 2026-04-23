-- File: server/Food/FoodBase.luau
local ServerStorage = game:GetService("ServerStorage")

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
    self.isAliveInWorkspace = true -- Flag per sapere se è ancora per terra
    
    return self
end

function FoodBase:startAging()
    task.spawn(function()
        -- Il loop si ferma se diventa marcio O se viene raccolto
        while self.currentState ~= FoodState.SPOILED and self.isAliveInWorkspace do
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
-- SISTEMA DI RACCOLTA UNIVERSALE
-- ==========================================

function FoodBase:setupPickup(mainPart, baseName)
    self.mainPart = mainPart
    self.baseName = baseName or self.model.Name
    
    self.prompt = Instance.new("ProximityPrompt")
    self.prompt.ActionText = "Collect " .. self.baseName
    self.prompt.ObjectText = self.baseName
    self.prompt.HoldDuration = 0.5
    self.prompt.MaxActivationDistance = 8
    self.prompt.Parent = self.mainPart
    
    self.prompt.Triggered:Connect(function(player)
        self:pickup(player)
    end)
end

function FoodBase:pickup(player)
    -- Spegniamo il timer di terra
    self.isAliveInWorkspace = false

    local leaderstats = player:FindFirstChild("leaderstats")
    local coins = leaderstats and leaderstats:FindFirstChild("Coins")

    local reward = 0
    local toolName = self.baseName

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

    if coins and reward ~= 0 then
        coins.Value += reward
        print("🥬 " .. toolName .. " raccolto! Transazione: " .. reward)
    end

    if self.prompt then
        -- Se è un oggetto vero, lo distruggiamo visivamente
        if typeof(self.prompt) == "Instance" then
            self.prompt:Destroy()
        end

        self.prompt = {}
    end

    -- ==========================================
    -- 1. CREA IL TOOL VUOTO
    -- ==========================================
    local tool = Instance.new("Tool")
    tool.Name = toolName
    tool.RequiresHandle = true
    tool.CanBeDropped = true
	tool:SetAttribute("FoodState", self.currentState)
	tool:SetAttribute("FoodName", self.baseName)
	tool:SetAttribute("SpoiledTime", self.spoiledTime)
	tool:SetAttribute("RecoverableTime", self.recoverableTime) -- ✅ aggiungi questa
	tool:SetAttribute("CurrentAge", self.age)

    -- ==========================================
    -- 2. PREPARA LE PARTI PRIMA DI MUOVERLE
    -- ==========================================
    local partsToKeep = {}
    for _, child in ipairs(self.model:GetDescendants()) do
        if child:IsA("BasePart") and child ~= self.mainPart then
            table.insert(partsToKeep, child)
        end
    end

    for _, child in ipairs(self.model:GetDescendants()) do
        if child:IsA("WeldConstraint") or child:IsA("Weld") or child:IsA("Motor6D") then
            child:Destroy()
        end
    end

    -- ==========================================
    -- 3. SPOSTA HANDLE PER PRIMO
    -- ==========================================
    self.mainPart.Name = "Handle"
    self.mainPart.Anchored = false
    self.mainPart.Parent = tool 

    -- ==========================================
    -- 4. SPOSTA LE PARTI SECONDARIE E SALDA
    -- ==========================================
    for _, part in ipairs(partsToKeep) do
        part.Anchored = false
        part.CanCollide = false
        part.Massless = true
        part.Parent = tool

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = self.mainPart 
        weld.Part1 = part
        weld.Parent = self.mainPart
    end

    if self.model ~= self.mainPart then
        self.model:Destroy()
    end

    -- ==========================================
    -- 5. PARENTALO SOLO ALLA FINE, TUTTO PRONTO
    -- ==========================================
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        tool.Parent = backpack
    end

    -- ==========================================
    -- TIMER DELLO ZAINO (Con aggiornamento GUI)
    -- ==========================================
    local toolAge = self.age

    task.spawn(function()
        while self.currentState ~= FoodState.SPOILED and tool.Parent do
            task.wait(1)

            toolAge += 0.4
            
            tool:SetAttribute("CurrentAge", toolAge)

            local previousState = self.currentState
            if toolAge >= self.spoiledTime then
                self.currentState = FoodState.SPOILED
            elseif toolAge >= self.recoverableTime then
                self.currentState = FoodState.RECOVERABLE
            end

            if self.currentState ~= previousState then
                tool:SetAttribute("FoodState", self.currentState)
                if self.currentState == FoodState.RECOVERABLE then
                    tool.Name = self.baseName .. " Bruised"
                elseif self.currentState == FoodState.SPOILED then
                    tool.Name = self.baseName .. " Spoiled"
                end

                self:onStateChanged()
            end
        end
    end)
end

return FoodBase