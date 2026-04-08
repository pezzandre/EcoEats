-- File: server/Food/honey.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaMiele(jarModel)
    local handlePart = jarModel:WaitForChild("Handle")
    local honeyPart  = handlePart:WaitForChild("Honey")

    jarModel.PrimaryPart = handlePart
    handlePart.Anchored  = false

    local COLORS = {
        FRESH       = Color3.fromRGB(255, 170, 0),
        RECOVERABLE = Color3.fromRGB(150, 75, 0),
        SPOILED     = Color3.fromRGB(50, 80, 50),
    }

    local honey = FoodBase.new(jarModel, 30, 60)
    honey:setupPickup(handlePart, "Honey Jar")

    function honey:onStateChanged()
        if self.currentState == FoodBase.FoodState.FRESH then
            honeyPart.Color = COLORS.FRESH

        elseif self.currentState == FoodBase.FoodState.RECOVERABLE then
            honeyPart.Color = COLORS.RECOVERABLE
            self.prompt.ActionText = "Collect Dark Honey"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            honeyPart.Color = COLORS.SPOILED
            local particles = Instance.new("ParticleEmitter")
            particles.Color = ColorSequence.new(Color3.fromRGB(100, 150, 100))
            particles.Size = NumberSequence.new(0.2, 0.8)
            particles.Rate = 5
            particles.Lifetime = NumberRange.new(1, 2)
            particles.Parent = honeyPart
            self.prompt.ActionText = "Collect Spoiled Honey"
        end
    end

    honey:startAging()
    print("🍯 Nuovo miele pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "HoneyJar" then
        inizializzaMiele(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "HoneyJar" then
        inizializzaMiele(obj)
    end
end
