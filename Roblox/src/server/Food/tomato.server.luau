-- File: server/Food/tomato.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaPomodoro(tomatoObj)
    local mainPart = tomatoObj.PrimaryPart or tomatoObj:FindFirstChildWhichIsA("BasePart", true)
    if not tomatoObj.PrimaryPart then
        tomatoObj.PrimaryPart = mainPart
    end

    mainPart.CanCollide = true

    local partsToColor = {}

    for _, child in ipairs(tomatoObj:GetDescendants()) do
        if child:IsA("BasePart") then
            table.insert(partsToColor, child)
            if child ~= mainPart then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = mainPart
                weld.Part1 = child
                weld.Parent = mainPart
                child.CanCollide = false
                child.Massless = true
            end
            child.Anchored = false
        end
    end

    local COLORS = {
        FRESH       = Color3.fromRGB(220, 30, 30),
        RECOVERABLE = Color3.fromRGB(160, 50, 40),
        SPOILED     = Color3.fromRGB(80, 100, 60),
    }

    local tomato = FoodBase.new(tomatoObj, 40, 80)
    tomato:setupPickup(mainPart, "Tomato")

    if tomato.prompt then
        tomato.prompt.RequiresLineOfSight = false
    end

    function tomato:onStateChanged()
        if self.currentState == FoodBase.FoodState.FRESH then
            for _, part in ipairs(partsToColor) do part.Color = COLORS.FRESH end

        elseif self.currentState == FoodBase.FoodState.RECOVERABLE then
            for _, part in ipairs(partsToColor) do part.Color = COLORS.RECOVERABLE end
            self.prompt.ActionText = "Collect Squishy Tomato"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            for _, part in ipairs(partsToColor) do part.Color = COLORS.SPOILED end
            local particles = Instance.new("ParticleEmitter")
            particles.Name = "RottenStink"
            particles.Color = ColorSequence.new(Color3.fromRGB(80, 100, 50))
            particles.Size = NumberSequence.new(0.2, 0.4)
            particles.Rate = 8
            particles.Parent = mainPart
            self.prompt.ActionText = "Collect Rotten Tomato"
        end
    end

    tomato:startAging()
    print("🍅 Nuovo pomodoro pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Tomato" then
        inizializzaPomodoro(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Tomato" then
        inizializzaPomodoro(obj)
    end
end
