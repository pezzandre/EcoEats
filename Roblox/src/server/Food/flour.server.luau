-- File: server/Food/flour.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaFarina(flourObj)
    local mainPart = flourObj.PrimaryPart or flourObj:FindFirstChildWhichIsA("BasePart")
    if not flourObj.PrimaryPart then
        flourObj.PrimaryPart = mainPart
    end

    for _, child in ipairs(flourObj:GetDescendants()) do
        if child:IsA("BasePart") and child ~= mainPart then
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = mainPart
            weld.Part1 = child
            weld.Parent = mainPart
            child.Anchored = false
        end
    end

    if mainPart then
        mainPart.Anchored = false
    end

    -- La farina non scade
    local flour = FoodBase.new(flourObj, 350, 720)
    flour:setupPickup(mainPart, "Flour")

    print("🌾 Nuova farina pronta!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Flour" then
        inizializzaFarina(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Flour" then
        inizializzaFarina(obj)
    end
end
