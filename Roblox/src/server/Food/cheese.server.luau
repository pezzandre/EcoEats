-- File: server/Food/cheese.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaFormaggio(cheeseObj)
    local cheesePart = cheeseObj:IsA("Model")
        and (cheeseObj.PrimaryPart or cheeseObj:FindFirstChildWhichIsA("BasePart"))
        or cheeseObj

    if cheesePart then
        cheesePart.Anchored = false
    end

    local COLORS = {
        FRESH       = cheesePart.Color,
        RECOVERABLE = Color3.fromRGB(220, 220, 160),
        SPOILED     = Color3.fromRGB(100, 150, 100),
    }

    local cheese = FoodBase.new(cheeseObj, 45, 90)
    cheese:setupPickup(cheesePart, "Cheese")

    function cheese:onStateChanged()
        if self.currentState == FoodBase.FoodState.FRESH then
            cheesePart.Color = COLORS.FRESH

        elseif self.currentState == FoodBase.FoodState.RECOVERABLE then
            cheesePart.Color = COLORS.RECOVERABLE
            self.prompt.ActionText = "Collect (Stale)"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            cheesePart.Color = COLORS.SPOILED
            local particles = Instance.new("ParticleEmitter")
            particles.Name = "MoldStink"
            particles.Color = ColorSequence.new(Color3.fromRGB(130, 180, 130))
            particles.Size = NumberSequence.new(0.3, 0.7)
            particles.Rate = 8
            particles.Lifetime = NumberRange.new(1.5, 2.5)
            particles.Speed = NumberRange.new(1, 2)
            particles.Parent = cheesePart
            self.prompt.ActionText = "Collect (Moldy)"
        end
    end

    cheese:startAging()
    print("🧀 Nuovo formaggio pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Cheese" then
        inizializzaFormaggio(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Cheese" then
        inizializzaFormaggio(obj)
    end
end
