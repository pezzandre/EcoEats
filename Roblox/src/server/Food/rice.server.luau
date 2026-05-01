-- File: server/Food/rice.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaRiso(riceObj)
    local ricePart = riceObj:IsA("Model")
        and (riceObj.PrimaryPart or riceObj:FindFirstChildWhichIsA("BasePart"))
        or riceObj

    if ricePart then
        ricePart.Anchored = false
    end

    local rice = FoodBase.new(riceObj, 9999, 9999)
    rice:setupPickup(ricePart, "Rice")

    function rice:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            local lightSmoke = Instance.new("ParticleEmitter")
            lightSmoke.Name = "StaleSmoke"
            lightSmoke.Color = ColorSequence.new(Color3.fromRGB(180, 255, 180))
            lightSmoke.Size = NumberSequence.new(0.3, 0.6)
            lightSmoke.Rate = 4
            lightSmoke.Speed = NumberRange.new(0.5, 1)
            lightSmoke.Lifetime = NumberRange.new(1, 2)
            lightSmoke.Parent = ricePart
            self.prompt.ActionText = "Collect Old Rice"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            local oldSmoke = ricePart:FindFirstChild("StaleSmoke")
            if oldSmoke then oldSmoke:Destroy() end

            local toxicSmoke = Instance.new("ParticleEmitter")
            toxicSmoke.Name = "ToxicSmoke"
            toxicSmoke.Color = ColorSequence.new(Color3.fromRGB(30, 130, 30))
            toxicSmoke.Size = NumberSequence.new(0.6, 1.2)
            toxicSmoke.Rate = 15
            toxicSmoke.Speed = NumberRange.new(1.5, 2.5)
            toxicSmoke.Lifetime = NumberRange.new(1.5, 3)
            toxicSmoke.Parent = ricePart
            self.prompt.ActionText = "Collect Spoiled Rice"
        end
    end

    rice:startAging()
    print("🍚 Nuovo riso pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Rice" then
        inizializzaRiso(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Rice" then
        inizializzaRiso(obj)
    end
end
