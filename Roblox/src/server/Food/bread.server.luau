-- File: server/Food/bread.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local COLOR_FRESH = Color3.fromRGB(245, 222, 179)
local COLOR_REC   = Color3.fromRGB(180, 140, 100)
local COLOR_SPOIL = Color3.fromRGB(80, 140, 80)

local function inizializzaPane(breadPart)
    breadPart.Anchored = false
    breadPart.Color    = COLOR_FRESH
    breadPart.Material = Enum.Material.Sand

    local bread = FoodBase.new(breadPart, 25, 50)
    bread:setupPickup(breadPart, "Bread")

    function bread:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            breadPart.Color    = COLOR_REC
            breadPart.Material = Enum.Material.Wood
            self.prompt.ActionText = "Collect (Stale)"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            breadPart.Color    = COLOR_SPOIL
            breadPart.Material = Enum.Material.Grass
            self.prompt.ActionText = "Collect (Moldy)"
        end
    end

    bread:startAging()
    print("🍞 Nuovo pane pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Bread" then
        inizializzaPane(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Bread" then
        inizializzaPane(obj)
    end
end
