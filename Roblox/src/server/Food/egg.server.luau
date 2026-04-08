-- File: server/Food/egg.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local COLOR_FRESH = Color3.fromRGB(255, 250, 240)
local COLOR_REC   = Color3.fromRGB(200, 180, 100)
local COLOR_SPOIL = Color3.fromRGB(50, 70, 50)

local function inizializzaUovo(eggPart)
    eggPart.Anchored = false
    eggPart.Color    = COLOR_FRESH
    eggPart.Material = Enum.Material.SmoothPlastic

    local egg = FoodBase.new(eggPart, 30, 60)
    egg:setupPickup(eggPart, "Egg")

    function egg:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            eggPart.Color    = COLOR_REC
            eggPart.Material = Enum.Material.Plastic
            self.prompt.ActionText = "Collect (Expires Soon - Cook Well!)"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            eggPart.Color    = COLOR_SPOIL
            eggPart.Material = Enum.Material.CorrodedMetal
            self.prompt.ActionText = "Collect (Bad - Floats!)"
        end
    end

    egg:startAging()
    print("🥚 Nuovo uovo pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Egg" then
        inizializzaUovo(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Egg" then
        inizializzaUovo(obj)
    end
end
