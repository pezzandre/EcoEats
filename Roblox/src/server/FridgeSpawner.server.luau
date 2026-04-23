local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local foodFolder = Workspace:FindFirstChild("Food") or Instance.new("Folder", Workspace)
foodFolder.Name = "Food"

local foodTemplates = ServerStorage:FindFirstChild("FoodTemplates") or ReplicatedStorage:FindFirstChild("FoodTemplates")
local spawnZone = Workspace:WaitForChild("FridgeSpawnZone")

local MAX_FOOD_IN_FRIDGE = 80
local SPAWN_INTERVAL = 1
local RESET_WAIT_TIME = 3 -- Il tempo di attesa dopo che il frigo è pieno

print("🚀 Spawner pronto. Flusso: Spawn graduale -> Wait 20s -> Reset.")

local function spawnFood()
	local templates = foodTemplates:GetChildren()
	if #templates == 0 then return end

	local template = templates[math.random(1, #templates)]
	local newFood = template:Clone()

	if newFood then
		local randomX = (math.random() - 0.5) * spawnZone.Size.X
		local randomZ = (math.random() - 0.5) * spawnZone.Size.Z

		local targetCFrame = spawnZone.CFrame * CFrame.new(randomX, (spawnZone.Size.Y / 2) + 3, randomZ)

		if newFood:IsA("Model") then
			newFood:PivotTo(targetCFrame)
		else
			newFood.CFrame = targetCFrame
		end

		newFood.Parent = foodFolder
		print("✅ Generato: " .. newFood.Name .. " (" .. #foodFolder:GetChildren() .. "/" .. MAX_FOOD_IN_FRIDGE .. ")")
	end
end

-- Ciclo Infinito
while true do
	local currentFoodCount = #foodFolder:GetChildren()

	if currentFoodCount < MAX_FOOD_IN_FRIDGE then
		-- Se mancano cibi, ne spawna uno e aspetta l'intervallo standard
		spawnFood()
		task.wait(SPAWN_INTERVAL)
	else
		-- SE IL FRIGO È PIENO (30/30):
		print("⚠️ Limite raggiunto! Aspetto " .. RESET_WAIT_TIME .. " secondi prima del reset...")

		-- Aspetta i 20 secondi
		task.wait(RESET_WAIT_TIME)

		-- Cancella tutto il contenuto della cartella Food
		print("🧹 Pulizia in corso... Ricomincio lo spawn.")
		foodFolder:ClearAllChildren()

		-- Aspetta un piccolo istante prima di ripartire con lo spawn
		task.wait(1) 
	end
end