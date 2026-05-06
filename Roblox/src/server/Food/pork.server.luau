-- File: server/Food/pork.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaPork(porkObj)
    local porkPart = porkObj:IsA("Model")
        and (porkObj.PrimaryPart or porkObj:FindFirstChildWhichIsA("BasePart"))
        or porkObj

    if porkObj:IsA("Model") then
        for _, child in ipairs(porkObj:GetDescendants()) do
            if child:IsA("BasePart") and child ~= porkPart then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = porkPart
                weld.Part1 = child
                weld.Parent = porkPart
                child.Anchored = false
            end
        end
    end

    if porkPart then
        porkPart.Anchored = false
    end

    local pork = FoodBase.new(porkObj, 120, 240)
    pork:setupPickup(porkPart, "Pork")

    function pork:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            local lightSmoke = Instance.new("ParticleEmitter")
            lightSmoke.Name = "StaleSmoke"
            lightSmoke.Color = ColorSequence.new(Color3.fromRGB(180, 255, 180))
            lightSmoke.Size = NumberSequence.new(0.3, 0.6)
            lightSmoke.Rate = 4
            lightSmoke.Speed = NumberRange.new(0.5, 1)
            lightSmoke.Lifetime = NumberRange.new(1, 2)
            lightSmoke.Parent = porkPart
            self.prompt.ActionText = "Collect Old Pork"
        elseif self.currentState == FoodBase.FoodState.SPOILED then
            local oldSmoke = porkPart:FindFirstChild("StaleSmoke")
            if oldSmoke then oldSmoke:Destroy() end
            local toxicSmoke = Instance.new("ParticleEmitter")
            toxicSmoke.Name = "ToxicSmoke"
            toxicSmoke.Color = ColorSequence.new(Color3.fromRGB(30, 130, 30))
            toxicSmoke.Size = NumberSequence.new(0.6, 1.2)
            toxicSmoke.Rate = 15
            toxicSmoke.Speed = NumberRange.new(1.5, 2.5)
            toxicSmoke.Lifetime = NumberRange.new(1.5, 3)
            toxicSmoke.Parent = porkPart
            self.prompt.ActionText = "Collect Spoiled Pork"
        end
    end

    pork:startAging()
    print("🥩 Nuovo maiale pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Pork" then
        inizializzaPork(child)
    end
end)
for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Pork" then
        inizializzaPork(obj)
    end
end