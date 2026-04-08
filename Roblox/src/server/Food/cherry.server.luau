-- File: server/Food/cherry.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaCiliegia(cherryObj)
    local mainPart = cherryObj.PrimaryPart or cherryObj:FindFirstChildWhichIsA("BasePart", true)
    if not cherryObj.PrimaryPart then
        cherryObj.PrimaryPart = mainPart
    end

    local partsToColor = {}

    for _, child in ipairs(cherryObj:GetDescendants()) do
        if child:IsA("BasePart") then
            table.insert(partsToColor, child)
            if child ~= mainPart then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = mainPart
                weld.Part1 = child
                weld.Parent = mainPart
            end
            child.Anchored = false
        end
    end

    local COLORS = {
        FRESH       = Color3.fromRGB(200, 0, 20),
        RECOVERABLE = Color3.fromRGB(110, 20, 30),
        SPOILED     = Color3.fromRGB(60, 80, 50),
    }

    local cherry = FoodBase.new(cherryObj, 35, 70)
    cherry:setupPickup(mainPart, "Cherry")

    function cherry:onStateChanged()
        if self.currentState == FoodBase.FoodState.FRESH then
            for _, part in ipairs(partsToColor) do part.Color = COLORS.FRESH end

        elseif self.currentState == FoodBase.FoodState.RECOVERABLE then
            for _, part in ipairs(partsToColor) do part.Color = COLORS.RECOVERABLE end
            self.prompt.ActionText = "Collect Old Cherry"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            for _, part in ipairs(partsToColor) do part.Color = COLORS.SPOILED end
            local particles = Instance.new("ParticleEmitter")
            particles.Name = "RottenStink"
            particles.Color = ColorSequence.new(Color3.fromRGB(80, 100, 50))
            particles.Size = NumberSequence.new(0.1, 0.4)
            particles.Rate = 6
            particles.Parent = mainPart
            self.prompt.ActionText = "Collect Rotten Cherry"
        end
    end

    cherry:startAging()
    print("🍒 Nuova ciliegia pronta!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Cherry" then
        inizializzaCiliegia(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Cherry" then
        inizializzaCiliegia(obj)
    end
end
