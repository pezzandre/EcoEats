-- File: server/Food/carrot.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

-- 1. FUNZIONE DI INIZIALIZZAZIONE (Il tuo vecchio codice)
local function inizializzaCarota(carrotModel)
    -- Troviamo i 3 pezzi (usiamo FindFirstChild per sicurezza nei cloni)
    local mainCarrot = carrotModel:WaitForChild("Carrot")
    local headPart = carrotModel:WaitForChild("Head")
    local herbPart = carrotModel:WaitForChild("Herb")

    -- SALDATURA
    local weldHead = Instance.new("WeldConstraint")
    weldHead.Part0 = mainCarrot
    weldHead.Part1 = headPart
    weldHead.Parent = mainCarrot

    local weldHerb = Instance.new("WeldConstraint")
    weldHerb.Part0 = mainCarrot
    weldHerb.Part1 = herbPart
    weldHerb.Parent = mainCarrot

    -- Sblocchiamo fisica
    mainCarrot.Anchored = false
    headPart.Anchored = false
    herbPart.Anchored = false

    -- COLORI
    local COLOR_FRESH_CARROT = Color3.fromRGB(255, 140, 0)
    local COLOR_FRESH_HERB = Color3.fromRGB(50, 205, 50)
    local COLOR_REC_CARROT = Color3.fromRGB(200, 100, 30)
    local COLOR_REC_HERB = Color3.fromRGB(107, 142, 35)
    local COLOR_SPOIL_CARROT = Color3.fromRGB(75, 50, 25)
    local COLOR_SPOIL_HERB = Color3.fromRGB(47, 79, 79)

    -- Stato iniziale
    mainCarrot.Color = COLOR_FRESH_CARROT
    headPart.Color = COLOR_FRESH_HERB
    herbPart.Color = COLOR_FRESH_HERB

    -- CREAZIONE OGGETTO
    local carrot = FoodBase.new(carrotModel, 20, 40)
    carrot:setupPickup(mainCarrot, "Carrot")

    -- CAMBIO STATO
    function carrot:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            mainCarrot.Color = COLOR_REC_CARROT
            headPart.Color = COLOR_REC_HERB
            herbPart.Color = COLOR_REC_HERB
            self.prompt.ActionText = "Raccogli (Avvizzita)"
            
        elseif self.currentState == FoodBase.FoodState.SPOILED then
            mainCarrot.Color = COLOR_SPOIL_CARROT
            headPart.Color = COLOR_SPOIL_HERB
            herbPart.Color = COLOR_SPOIL_HERB
            mainCarrot.Material = Enum.Material.Mud
            headPart.Material = Enum.Material.Grass
            herbPart.Material = Enum.Material.Grass
            self.prompt.ActionText = "Raccogli (Marcia)"
        end
    end

    carrot:startAging()
    print("🥕 Nuova carota pronta!")
end

-- 2. GESTIONE CLONI (Quando il frigo spawna)
foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Carrot" then
        inizializzaCarota(child)
    end
end)

-- 3. GESTIONE ESISTENTI (Per quelle già presenti all'avvio)
for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Carrot" then
        inizializzaCarota(obj)
    end
end