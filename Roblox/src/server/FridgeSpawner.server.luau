local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local foodFolder = Workspace:FindFirstChild("Food") or Instance.new("Folder", Workspace)
foodFolder.Name = "Food"

local foodTemplates = ServerStorage:FindFirstChild("FoodTemplates") or ReplicatedStorage:FindFirstChild("FoodTemplates")
local spawnZone = Workspace:WaitForChild("FridgeSpawnZone")

local MAX_FOOD_IN_FRIDGE = 30
local SPAWN_INTERVAL = 3

print("🚀 Spawner pronto. Controllo cartella 'Food'...")

local function spawnFood()
    local children = foodFolder:GetChildren()
    
    -- Se hai spostato i cibi in FoodTest, qui leggerai 0 e lo spawn partirà!
    if #children >= MAX_FOOD_IN_FRIDGE then 
        return 
    end
    
    local templates = foodTemplates:GetChildren()
    if #templates == 0 then return end
    
    local template = templates[math.random(1, #templates)]
    local newFood = template:Clone()
    
    if newFood then
        -- Calcolo random sulla superficie della Part
        local randomX = (math.random() - 0.5) * spawnZone.Size.X
        local randomZ = (math.random() - 0.5) * spawnZone.Size.Z
        
        -- CFrame calcolato: 3 stud sopra la superficie del mega-ripiano
        local targetCFrame = spawnZone.CFrame * CFrame.new(randomX, (spawnZone.Size.Y / 2) + 3, randomZ)
        
        if newFood:IsA("Model") then
            newFood:PivotTo(targetCFrame)
        else
            newFood.CFrame = targetCFrame
        end
        
        newFood.Parent = foodFolder
        print("✅ Generato nel frigo: " .. newFood.Name)
    end
end

while true do
    task.wait(SPAWN_INTERVAL)
    spawnFood()
end