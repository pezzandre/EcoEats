-- File: server/Food/chocolate.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaCioccolato(chocolateObj)
    local mainPart = chocolateObj.PrimaryPart or chocolateObj:FindFirstChildWhichIsA("BasePart", true)
    if not chocolateObj.PrimaryPart then
        chocolateObj.PrimaryPart = mainPart
    end

    mainPart.CanCollide = true

    -- Pulizia vecchi weld prima di risaldare
    for _, child in ipairs(chocolateObj:GetDescendants()) do
        if child:IsA("JointInstance") then
            child:Destroy()
        end
    end

    for _, child in ipairs(chocolateObj:GetDescendants()) do
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

    -- Il cioccolato non scade
    local chocolate = FoodBase.new(chocolateObj, 600, 1000)
    chocolate:setupPickup(mainPart, "Chocolate")

    if chocolate.prompt then
        chocolate.prompt.RequiresLineOfSight = false
    end

    print("🍫 Nuovo cioccolato pronto!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Chocolate" then
        inizializzaCioccolato(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Chocolate" then
        inizializzaCioccolato(obj)
    end
end
