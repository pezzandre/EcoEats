local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local petDataStore = DataStoreService:GetDataStore("PetData")

local foodTemplates = ServerStorage:WaitForChild("Pets")

local petFolder = Instance.new("Folder")
petFolder.Name = "PetEvents"
petFolder.Parent = ReplicatedStorage

local buyPetEvent = Instance.new("RemoteEvent")
buyPetEvent.Name = "BuyPet"
buyPetEvent.Parent = petFolder

local sellPetEvent = Instance.new("RemoteEvent")
sellPetEvent.Name = "SellPet"
sellPetEvent.Parent = petFolder

local equipPetEvent = Instance.new("RemoteEvent")
equipPetEvent.Name = "EquipPet"
equipPetEvent.Parent = petFolder

local getPetListEvent = Instance.new("RemoteFunction")
getPetListEvent.Name = "GetPetList"
getPetListEvent.Parent = petFolder

local getOwnedPetsEvent = Instance.new("RemoteFunction")
getOwnedPetsEvent.Name = "GetOwnedPets"
getOwnedPetsEvent.Parent = petFolder

local PET_COST = 100
local MAX_PETS = 3
local PET_SCALE = 0.01

local petRotations = {
	["butterfly"] = math.rad(-90),
	["ladybug"] = math.rad(-90),
	["squirrel"] = math.rad(-90),
	["dolphin"] = math.rad(-90),
	["fish"] = math.rad(-90),
	["shark"] = math.rad(-90),
	["seal"] = math.rad(-90),
	["elephant"] = math.rad(-90),
	["bee"] = math.rad(-90),
	["snake"] = math.rad(180),
	["flamingo"] = math.rad(180),
	["bull"] = math.rad(180),
	["rabbit"] = math.rad(180),
	["fox"] = math.rad(180),
	["crocodile"] = math.rad(180),
	["SUPER FOX"] = math.rad(180),
	["rat"] = math.rad(180),
	["snow ram"] = math.rad(180),
	["buffalo"] = math.rad(180),
	["cat"] = math.rad(180),
	["desert snake"] = math.rad(180),
	["racoon"] = math.rad(180),
	["dog"] = math.rad(180),
	["eagle"] = math.rad(180),
	["bat"] = math.rad(180),
	["panda"] = math.rad(180),
	["wight bear"] = math.rad(180),
	["bear"] = math.rad(180),
	["worm"] = math.rad(90),
}

local petOffsets = {
	CFrame.new(-5, 0, 5),
	CFrame.new(0, 0, 6),
	CFrame.new(5, 0, 5),
}

local playerData = {}

getPetListEvent.OnServerInvoke = function(player)
	local list = {}
	for _, template in ipairs(foodTemplates:GetChildren()) do
		table.insert(list, template.Name)
	end
	return list
end

getOwnedPetsEvent.OnServerInvoke = function(player)
	if not playerData[player] then return {owned = {}, equipped = {}} end
	return playerData[player]
end

local function updatePets(player)
	local data = playerData[player]
	if not data then return end

	local character = player.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local existingFolder = character:FindFirstChild("Pets")
	if existingFolder then existingFolder:Destroy() end

	local petsFolder = Instance.new("Folder")
	petsFolder.Name = "Pets"
	petsFolder.Parent = character

	for i, petName in ipairs(data.equipped) do
		local template = foodTemplates:FindFirstChild(petName)
		if template then
			local petModel = template:Clone()

			if petModel:IsA("Model") then
				petModel:ScaleTo(PET_SCALE)
			end

			if petModel:IsA("Model") then
				for _, desc in ipairs(petModel:GetDescendants()) do
					if desc:IsA("BasePart") then
						desc.CanCollide = false
						desc.CastShadow = false
						desc.Massless = true
						desc.Anchored = false
					end
				end
			elseif petModel:IsA("BasePart") then
				petModel.CanCollide = false
				petModel.CastShadow = false
				petModel.Massless = true
				petModel.Anchored = false
			end

			petModel.Name = petName
			petModel.Parent = petsFolder

			local parts = {}
			if petModel:IsA("Model") then
				for _, desc in ipairs(petModel:GetDescendants()) do
					if desc:IsA("BasePart") then
						table.insert(parts, desc)
					end
				end
			elseif petModel:IsA("BasePart") then
				table.insert(parts, petModel)
			end

			if #parts == 0 then
				print("[PET] Nessuna parte trovata per: " .. petName)
				continue
			end

			local primaryPart = petModel:IsA("Model") and (petModel.PrimaryPart or parts[1]) or petModel

			local rotation = petRotations[petName] or math.rad(0)
			local offset = petOffsets[i] or CFrame.new(0, 0, 3 + i)
			local targetCFrame = rootPart.CFrame * offset * CFrame.new(0, 1, 0) * CFrame.Angles(0, rotation, 0)

			if petModel:IsA("Model") and petModel.PrimaryPart then
				petModel:PivotTo(targetCFrame)
			else
				local modelCFrame = primaryPart.CFrame
				for _, part in ipairs(parts) do
					part.CFrame = targetCFrame * (modelCFrame:Inverse() * part.CFrame)
				end
			end

			local mainPart = petModel.PrimaryPart
				or petModel:FindFirstChild("Handle")
				or petModel:FindFirstChild("Cube")
				or parts[1]

			if mainPart then
				for _, part in ipairs(parts) do
					if part ~= mainPart then
						local internalWeld = Instance.new("WeldConstraint")
						internalWeld.Part0 = mainPart
						internalWeld.Part1 = part
						internalWeld.Parent = part
					end
				end

				local weld = Instance.new("WeldConstraint")
				weld.Part0 = rootPart
				weld.Part1 = mainPart
				weld.Parent = mainPart
			end

			print("[PET] Spawnato: " .. petName .. " in posizione " .. i)
		else
			print("[PET] Template non trovato: " .. petName)
		end
	end
end

-- Compra pet
buyPetEvent.OnServerEvent:Connect(function(player, petName)
	local data = playerData[player]
	if not data then return end

	if not foodTemplates:FindFirstChild(petName) then return end

	for _, owned in ipairs(data.owned) do
		if owned == petName then
			print("[PET] " .. player.Name .. " ha già " .. petName)
			return
		end
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end
	local coins = leaderstats:FindFirstChild("Coins")
	if not coins or coins.Value < PET_COST then
		print("[PET] " .. player.Name .. " non ha abbastanza monete")
		return
	end

	coins.Value = coins.Value - PET_COST
	table.insert(data.owned, petName)
	print("[PET] " .. player.Name .. " ha comprato: " .. petName)

	if #data.equipped < MAX_PETS then
		table.insert(data.equipped, petName)
		updatePets(player)
	end
end)

-- Vendi pet
sellPetEvent.OnServerEvent:Connect(function(player, petName)
	local data = playerData[player]
	if not data then return end

	-- Rimuovi dai posseduti
	for i, owned in ipairs(data.owned) do
		if owned == petName then
			table.remove(data.owned, i)
			break
		end
	end

	-- Rimuovi dagli equipaggiati
	for i, e in ipairs(data.equipped) do
		if e == petName then
			table.remove(data.equipped, i)
			break
		end
	end

	-- Rimborso metà prezzo
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			coins.Value = coins.Value + (PET_COST / 2)
		end
	end

	updatePets(player)
	print("[PET] " .. player.Name .. " ha venduto: " .. petName)
end)

-- Equipaggia/rimuovi pet
equipPetEvent.OnServerEvent:Connect(function(player, petName, equip)
	local data = playerData[player]
	if not data then return end

	if equip then
		if #data.equipped >= MAX_PETS then
			print("[PET] " .. player.Name .. " ha già 3 pet equipaggiati")
			return
		end
		for _, e in ipairs(data.equipped) do
			if e == petName then return end
		end
		table.insert(data.equipped, petName)
	else
		for i, e in ipairs(data.equipped) do
			if e == petName then
				table.remove(data.equipped, i)
				break
			end
		end
	end

	updatePets(player)
end)

-- Salva quando esce
Players.PlayerRemoving:Connect(function(player)
	if playerData[player] then
		pcall(function()
			petDataStore:SetAsync("pets_" .. player.UserId, playerData[player])
		end)
		print("[PET] Dati salvati per " .. player.Name)
	end
	playerData[player] = nil
end)

-- Salva quando il server si chiude
game:BindToClose(function()
	for player, data in pairs(playerData) do
		pcall(function()
			petDataStore:SetAsync("pets_" .. player.UserId, data)
		end)
	end
end)

-- Unico PlayerAdded corretto
Players.PlayerAdded:Connect(function(player)
	local success, savedData = pcall(function()
		return petDataStore:GetAsync("pets_" .. player.UserId)
	end)

	if success and savedData then
		playerData[player] = savedData
		print("[PET] Dati caricati per " .. player.Name)
	else
		playerData[player] = {
			owned = {},
			equipped = {}
		}
	end

	player.CharacterAdded:Connect(function()
		task.wait(1)
		updatePets(player)
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	playerData[player] = playerData[player] or {owned = {}, equipped = {}}
	player.CharacterAdded:Connect(function()
		task.wait(1)
		updatePets(player)
	end)
end