-- File: server/Food/banana.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaBanana(bananaModel)
    local mainPeel = bananaModel:WaitForChild("Meshes/bananaPeel_Cube")
    local tipsPeel = bananaModel:WaitForChild("Meshes/bananaPeel_Cube.001")

    local baseWeld = Instance.new("WeldConstraint")
    baseWeld.Part0 = mainPeel
    baseWeld.Part1 = tipsPeel
    baseWeld.Parent = mainPeel

    mainPeel.Anchored = false
    tipsPeel.Anchored = false

    local COLOR_FRESH      = Color3.fromRGB(255, 225, 53)
    local COLOR_RECOVERABLE = Color3.fromRGB(139, 69, 19)
    local COLOR_SPOILED    = Color3.fromRGB(30, 30, 30)

    mainPeel.Color = COLOR_FRESH

    local banana = FoodBase.new(bananaModel, 15, 30)
    banana:setupPickup(mainPeel, "Banana")

    function banana:onStateChanged()
        if self.currentState == FoodBase.FoodState.RECOVERABLE then
            mainPeel.Color = COLOR_RECOVERABLE
            self.prompt.ActionText = "Raccogli (Macchiata)"

        elseif self.currentState == FoodBase.FoodState.SPOILED then
            mainPeel.Color = COLOR_SPOILED
            mainPeel.Material = Enum.Material.Grass
            tipsPeel.Material = Enum.Material.Grass
            self.prompt.ActionText = "Raccogli (Avariata)"
        end
    end

    banana:startAging()
    print("🍌 Nuova banana pronta!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Banana" then
        inizializzaBanana(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Banana" then
        inizializzaBanana(obj)
    end
end
