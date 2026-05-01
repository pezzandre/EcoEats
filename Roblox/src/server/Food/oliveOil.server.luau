-- File: server/Food/oliveOil.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaOlioOliva(oilObj)
    local mainPart = oilObj.PrimaryPart or oilObj:FindFirstChildWhichIsA("BasePart", true)
    if not oilObj.PrimaryPart then
        oilObj.PrimaryPart = mainPart
    end

    mainPart.CanCollide = true

    for _, child in ipairs(oilObj:GetDescendants()) do
        if child:IsA("BasePart") then
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

    -- L'olio non scade
    local oliveOil = FoodBase.new(oilObj, 500, 900)
    oliveOil:setupPickup(mainPart, "OliveOil")

    if oliveOil.prompt then
        oliveOil.prompt.RequiresLineOfSight = false
    end

    print("🫒 Nuovo olio d'oliva pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "OliveOil" then
        inizializzaOlioOliva(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "OliveOil" then
        inizializzaOlioOliva(obj)
    end
end
