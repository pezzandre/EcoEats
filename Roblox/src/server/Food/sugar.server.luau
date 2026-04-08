-- File: server/Food/sugar.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaZucchero(sugarObj)
    local mainPart = sugarObj.PrimaryPart or sugarObj:FindFirstChildWhichIsA("BasePart", true)
    if not sugarObj.PrimaryPart then
        sugarObj.PrimaryPart = mainPart
    end

    mainPart.CanCollide = true

    for _, child in ipairs(sugarObj:GetDescendants()) do
        if child:IsA("BasePart") then
            local originalColor    = child.Color
            local originalMaterial = child.Material

            -- "Guardia del corpo": impedisce cambi di colore/materiale involontari
            child:GetPropertyChangedSignal("Color"):Connect(function()
                if child.Color ~= originalColor then
                    child.Color = originalColor
                end
            end)
            child:GetPropertyChangedSignal("Material"):Connect(function()
                if child.Material ~= originalMaterial then
                    child.Material = originalMaterial
                end
            end)

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

    -- Lo zucchero non scade
    local sugar = FoodBase.new(sugarObj, 9999, 9999)
    sugar:setupPickup(mainPart, "Sugar")

    if sugar.prompt then
        sugar.prompt.RequiresLineOfSight = false
    end

    print("🍬 Nuovo zucchero pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Sugar" then
        inizializzaZucchero(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Sugar" then
        inizializzaZucchero(obj)
    end
end
