-- File: server/Food/chicken_nugget.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaNugget(nuggetObj)
    local nuggetPart = nuggetObj:IsA("Model")
        and (nuggetObj.PrimaryPart or nuggetObj:FindFirstChildWhichIsA("BasePart"))
        or nuggetObj

    if nuggetObj:IsA("Model") then
        for _, child in ipairs(nuggetObj:GetDescendants()) do
            if child:IsA("BasePart") and child ~= nuggetPart then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = nuggetPart
                weld.Part1 = child
                weld.Parent = nuggetPart
                child.Anchored = false
            end
        end
    end

    if nuggetPart then
        nuggetPart.Anchored = false
    end

    local nugget = FoodBase.new(nuggetObj, 150, 300)
    nugget:setupPickup(nuggetPart, "chicken_nugget")

    function nugget:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            local lightSmoke = Instance.new("ParticleEmitter")
            lightSmoke.Name = "StaleSmoke"
            lightSmoke.Color = ColorSequence.new(Color3.fromRGB(200, 255, 180))
            lightSmoke.Size = NumberSequence.new(0.2, 0.5)
            lightSmoke.Rate = 4
            lightSmoke.Speed = NumberRange.new(0.5, 1)
            lightSmoke.Lifetime = NumberRange.new(1, 2)
            lightSmoke.Parent = nuggetPart
            self.prompt.ActionText = "Collect Old Nugget"
        elseif self.currentState == FoodBase.FoodState.SPOILED then
            local oldSmoke = nuggetPart:FindFirstChild("StaleSmoke")
            if oldSmoke then oldSmoke:Destroy() end
            local toxicSmoke = Instance.new("ParticleEmitter")
            toxicSmoke.Name = "ToxicSmoke"
            toxicSmoke.Color = ColorSequence.new(Color3.fromRGB(30, 130, 30))
            toxicSmoke.Size = NumberSequence.new(0.5, 1.1)
            toxicSmoke.Rate = 15
            toxicSmoke.Speed = NumberRange.new(1.5, 2.5)
            toxicSmoke.Lifetime = NumberRange.new(1.5, 3)
            toxicSmoke.Parent = nuggetPart
            self.prompt.ActionText = "Collect Spoiled Nugget"
        end
    end

    nugget:startAging()
    print("🍗 Nuovo chicken nugget pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "chicken_nugget" then
        inizializzaNugget(child)
    end
end)
for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "chicken_nugget" then
        inizializzaNugget(obj)
    end
end