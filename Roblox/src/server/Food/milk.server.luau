-- File: server/Food/milk.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaLatte(milkPart)
    milkPart.Anchored = false

    local milk = FoodBase.new(milkPart, 50, 100)
    milk:setupPickup(milkPart, "Milk")

    function milk:onStateChanged()
        if self.currentState == FoodBase.FoodState.SPOILED then
            milkPart.Color = Color3.fromRGB(150, 200, 150)

            local stinkEffect = Instance.new("ParticleEmitter")
            stinkEffect.Name = "StinkParticles"
            stinkEffect.Color = ColorSequence.new(Color3.fromRGB(50, 200, 50))
            stinkEffect.Size = NumberSequence.new(0.5, 1.5)
            stinkEffect.Rate = 12
            stinkEffect.Speed = NumberRange.new(1, 2)
            stinkEffect.Lifetime = NumberRange.new(1.5, 2.5)
            stinkEffect.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.5),
                NumberSequenceKeypoint.new(1, 1),
            })
            stinkEffect.Parent = milkPart

            self.prompt.ActionText = "Collect (Spoiled)"
        end
    end

    milk:startAging()
    print("🥛 Nuovo latte pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Milk" then
        inizializzaLatte(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Milk" then
        inizializzaLatte(obj)
    end
end
