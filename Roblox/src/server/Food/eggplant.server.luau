-- File: server/Food/eggplant.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaMelanzana(eggplantModel)
    local stemPart = eggplantModel:WaitForChild("MeshPart")
    local mainPart = eggplantModel:WaitForChild("EggTemplate")

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = mainPart
    weld.Part1 = stemPart
    weld.Parent = mainPart

    mainPart.Anchored = false
    stemPart.Anchored = false

    local COLOR_FRESH_BODY  = Color3.fromRGB(75, 0, 130)
    local COLOR_FRESH_STEM  = Color3.fromRGB(34, 139, 34)
    local COLOR_REC_BODY    = Color3.fromRGB(105, 75, 120)
    local COLOR_REC_STEM    = Color3.fromRGB(107, 142, 35)
    local COLOR_SPOIL_BODY  = Color3.fromRGB(40, 30, 40)
    local COLOR_SPOIL_STEM  = Color3.fromRGB(101, 67, 33)

    mainPart.Color = COLOR_FRESH_BODY
    stemPart.Color = COLOR_FRESH_STEM

    local eggplant = FoodBase.new(eggplantModel, 22, 45)
    eggplant:setupPickup(mainPart, "Eggplant")

    function eggplant:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            mainPart.Color = COLOR_REC_BODY
            stemPart.Color = COLOR_REC_STEM
            mainPart.Material = Enum.Material.Plastic
            self.prompt.ActionText = "Raccogli (Avvizzita)"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            mainPart.Color = COLOR_SPOIL_BODY
            stemPart.Color = COLOR_SPOIL_STEM
            mainPart.Material = Enum.Material.Mud
            stemPart.Material = Enum.Material.Wood
            self.prompt.ActionText = "Raccogli (Marcia)"
        end
    end

    eggplant:startAging()
    print("🍆 Nuova melanzana pronta!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Eggplant" then
        inizializzaMelanzana(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Eggplant" then
        inizializzaMelanzana(obj)
    end
end
