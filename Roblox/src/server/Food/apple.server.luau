-- File: server/Food/apple.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaMela(appleModel)
    local fruitPart = appleModel:WaitForChild("Fruit")
    local leafPart = appleModel:WaitForChild("Leaf")
    local sternPart = appleModel:WaitForChild("Stem")

    local weldLeaf = Instance.new("WeldConstraint")
    weldLeaf.Part0 = fruitPart
    weldLeaf.Part1 = leafPart
    weldLeaf.Parent = fruitPart

    local weldStern = Instance.new("WeldConstraint")
    weldStern.Part0 = fruitPart
    weldStern.Part1 = sternPart
    weldStern.Parent = fruitPart

    fruitPart.Anchored = false
    leafPart.Anchored = false
    sternPart.Anchored = false

    local COLOR_FRESH_FRUIT  = Color3.fromRGB(220, 20, 60)
    local COLOR_FRESH_LEAF   = Color3.fromRGB(50, 205, 50)
    local COLOR_FRESH_STERN  = Color3.fromRGB(139, 69, 19)
    local COLOR_REC_FRUIT    = Color3.fromRGB(160, 82, 45)
    local COLOR_REC_LEAF     = Color3.fromRGB(154, 205, 50)
    local COLOR_REC_STERN    = Color3.fromRGB(101, 67, 33)
    local COLOR_SPOIL_FRUIT  = Color3.fromRGB(80, 50, 30)
    local COLOR_SPOIL_LEAF   = Color3.fromRGB(139, 137, 137)
    local COLOR_SPOIL_STERN  = Color3.fromRGB(60, 40, 20)

    fruitPart.Color = COLOR_FRESH_FRUIT
    leafPart.Color  = COLOR_FRESH_LEAF
    sternPart.Color = COLOR_FRESH_STERN
    fruitPart.Material = Enum.Material.SmoothPlastic

    local apple = FoodBase.new(appleModel, 18, 36)
    apple:setupPickup(fruitPart, "Apple")

    function apple:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            fruitPart.Color  = COLOR_REC_FRUIT
            leafPart.Color   = COLOR_REC_LEAF
            sternPart.Color  = COLOR_REC_STERN
            fruitPart.Material = Enum.Material.Plastic
            self.prompt.ActionText = "Collect (Bruised)"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            fruitPart.Color  = COLOR_SPOIL_FRUIT
            leafPart.Color   = COLOR_SPOIL_LEAF
            sternPart.Color  = COLOR_SPOIL_STERN
            fruitPart.Material = Enum.Material.Mud
            leafPart.Material  = Enum.Material.Fabric
            self.prompt.ActionText = "Collect (Rotten)"
        end
    end

    apple:startAging()
    print("🍎 Nuova mela pronta!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Apple" then
        inizializzaMela(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Apple" then
        inizializzaMela(obj)
    end
end
