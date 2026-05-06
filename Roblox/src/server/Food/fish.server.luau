-- File: server/Food/fish.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaFish(fishObj)
    local fishPart = fishObj:IsA("Model")
        and (fishObj.PrimaryPart or fishObj:FindFirstChildWhichIsA("BasePart"))
        or fishObj

    if fishObj:IsA("Model") then
        for _, child in ipairs(fishObj:GetDescendants()) do
            if child:IsA("BasePart") and child ~= fishPart then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = fishPart
                weld.Part1 = child
                weld.Parent = fishPart
                child.Anchored = false
            end
        end
    end

    if fishPart then
        fishPart.Anchored = false
    end

    -- Fish spoils faster than other meats
    local fish = FoodBase.new(fishObj, 90, 180)
    fish:setupPickup(fishPart, "Fish")

    function fish:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            local lightSmoke = Instance.new("ParticleEmitter")
            lightSmoke.Name = "StaleSmoke"
            lightSmoke.Color = ColorSequence.new(Color3.fromRGB(180, 255, 200))
            lightSmoke.Size = NumberSequence.new(0.3, 0.5)
            lightSmoke.Rate = 5
            lightSmoke.Speed = NumberRange.new(0.5, 1)
            lightSmoke.Lifetime = NumberRange.new(1, 2)
            lightSmoke.Parent = fishPart
            self.prompt.ActionText = "Collect Old Fish"
        elseif self.currentState == FoodBase.FoodState.SPOILED then
            local oldSmoke = fishPart:FindFirstChild("StaleSmoke")
            if oldSmoke then oldSmoke:Destroy() end
            local toxicSmoke = Instance.new("ParticleEmitter")
            toxicSmoke.Name = "ToxicSmoke"
            toxicSmoke.Color = ColorSequence.new(Color3.fromRGB(20, 140, 60))
            toxicSmoke.Size = NumberSequence.new(0.7, 1.4)
            toxicSmoke.Rate = 20  -- Fish stinks the most!
            toxicSmoke.Speed = NumberRange.new(2, 3)
            toxicSmoke.Lifetime = NumberRange.new(1.5, 3)
            toxicSmoke.Parent = fishPart
            self.prompt.ActionText = "Collect Spoiled Fish"
        end
    end

    fish:startAging()
    print("🐟 Nuovo pesce pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Fish" then
        inizializzaFish(child)
    end
end)
for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Fish" then
        inizializzaFish(obj)
    end
end