-- File: server/Food/potato.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaPatata(potatoObj)
    local potatoPart = potatoObj:IsA("Model")
        and (potatoObj.PrimaryPart or potatoObj:FindFirstChildWhichIsA("BasePart"))
        or potatoObj

    if potatoPart then
        potatoPart.Anchored = false
    end

    local COLORS = {
        FRESH       = potatoPart.Color,
        RECOVERABLE = Color3.fromRGB(130, 100, 60),
        SPOILED     = Color3.fromRGB(50, 60, 40),
    }

    local potato = FoodBase.new(potatoObj, 50, 100)
    potato:setupPickup(potatoPart, "Potato")

    function potato:onStateChanged()
        if self.currentState == FoodBase.FoodState.FRESH then
            potatoPart.Color = COLORS.FRESH

        elseif self.currentState == FoodBase.FoodState.RECOVERABLE then
            potatoPart.Color = COLORS.RECOVERABLE
            self.prompt.ActionText = "Collect Old Potato"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            potatoPart.Color = COLORS.SPOILED
            local particles = Instance.new("ParticleEmitter")
            particles.Name = "RottenStink"
            particles.Color = ColorSequence.new(Color3.fromRGB(80, 100, 50))
            particles.Size = NumberSequence.new(0.2, 0.5)
            particles.Rate = 10
            particles.Lifetime = NumberRange.new(1, 2)
            particles.Speed = NumberRange.new(0.5, 1.5)
            particles.Parent = potatoPart
            self.prompt.ActionText = "Collect Rotten Potato"
        end
    end

    potato:startAging()
    print("🥔 Nuova patata pronta!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Potato" then
        inizializzaPatata(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Potato" then
        inizializzaPatata(obj)
    end
end
