-- File: server/Food/water.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaAcqua(waterObj)
    local bottlePart = waterObj:WaitForChild("Bottle")
    local capPart    = waterObj:WaitForChild("Cap")

    waterObj.PrimaryPart = bottlePart

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = capPart
    weld.Part1 = bottlePart
    weld.Parent = capPart

    bottlePart.Anchored = false
    capPart.Anchored    = false

    -- L'acqua non scade
    local water = FoodBase.new(waterObj, 9999, 9999)
    water:setupPickup(bottlePart, "Water")

    print("💧 Nuova acqua pronta!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Water" then
        inizializzaAcqua(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Water" then
        inizializzaAcqua(obj)
    end
end
