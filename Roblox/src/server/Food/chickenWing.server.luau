-- File: server/Food/chickenWing.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaChickenWing(wingObj)
    local wingPart = wingObj:IsA("Model")
        and (wingObj.PrimaryPart or wingObj:FindFirstChildWhichIsA("BasePart"))
        or wingObj

    if wingObj:IsA("Model") then
        for _, child in ipairs(wingObj:GetDescendants()) do
            if child:IsA("BasePart") and child ~= wingPart then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = wingPart
                weld.Part1 = child
                weld.Parent = wingPart
                child.Anchored = false
            end
        end
    end

    if wingPart then
        wingPart.Anchored = false
    end

    local wing = FoodBase.new(wingObj, 150, 300)
    wing:setupPickup(wingPart, "ChickenWing")

    function wing:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            local lightSmoke = Instance.new("ParticleEmitter")
            lightSmoke.Name = "StaleSmoke"
            lightSmoke.Color = ColorSequence.new(Color3.fromRGB(200, 255, 180))
            lightSmoke.Size = NumberSequence.new(0.2, 0.5)
            lightSmoke.Rate = 4
            lightSmoke.Speed = NumberRange.new(0.5, 1)
            lightSmoke.Lifetime = NumberRange.new(1, 2)
            lightSmoke.Parent = wingPart
            self.prompt.ActionText = "Collect Old Wing"
        elseif self.currentState == FoodBase.FoodState.SPOILED then
            local oldSmoke = wingPart:FindFirstChild("StaleSmoke")
            if oldSmoke then oldSmoke:Destroy() end
            local toxicSmoke = Instance.new("ParticleEmitter")
            toxicSmoke.Name = "ToxicSmoke"
            toxicSmoke.Color = ColorSequence.new(Color3.fromRGB(30, 130, 30))
            toxicSmoke.Size = NumberSequence.new(0.5, 1.1)
            toxicSmoke.Rate = 15
            toxicSmoke.Speed = NumberRange.new(1.5, 2.5)
            toxicSmoke.Lifetime = NumberRange.new(1.5, 3)
            toxicSmoke.Parent = wingPart
            self.prompt.ActionText = "Collect Spoiled Wing"
        end
    end

    wing:startAging()
    print("🍖 Nuovo chicken wing pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "ChickenWing" then
        inizializzaChickenWing(child)
    end
end)
for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "ChickenWing" then
        inizializzaChickenWing(obj)
    end
end