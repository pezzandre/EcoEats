-- File: server/Food/pasta.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))
local foodFolder = workspace:WaitForChild("Food")

local function inizializzaPasta(pastaPart)
    pastaPart.Anchored = false

    -- La pasta non scade
    local pasta = FoodBase.new(pastaPart, 9999, 9999)
    pasta:setupPickup(pastaPart, "Pasta")

    print("🍝 Nuova pasta pronta!")
end

foodFolder.ChildAdded:Connect(function(child)
    if child.Name == "Pasta" then
        inizializzaPasta(child)
    end
end)

for _, obj in ipairs(foodFolder:GetChildren()) do
    if obj.Name == "Pasta" then
        inizializzaPasta(obj)
    end
end
