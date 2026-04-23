local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local ADMINS = {
	"MaxMM2004",
	"Gioi1520",
	"pezzandre24","EcoEatsTest","EcoEatsTest1","EcoEatsTest2","EcoEatsDev","EcoEatsProf",
}

local function isAdmin(player)
	for _, name in ipairs(ADMINS) do
		if player.Name == name then return true end
	end
	return false
end

local adminFolder = Instance.new("Folder")
adminFolder.Name = "AdminEvents"
adminFolder.Parent = ReplicatedStorage

local spawnFoodEvent = Instance.new("RemoteEvent")
spawnFoodEvent.Name = "SpawnFood"
spawnFoodEvent.Parent = adminFolder

local setCoinsEvent = Instance.new("RemoteEvent")
setCoinsEvent.Name = "SetCoins"
setCoinsEvent.Parent = adminFolder

local getFoodListEvent = Instance.new("RemoteFunction")
getFoodListEvent.Name = "GetFoodList"
getFoodListEvent.Parent = adminFolder

local getPlayersEvent = Instance.new("RemoteFunction")
getPlayersEvent.Name = "GetPlayersList"
getPlayersEvent.Parent = adminFolder

local foodFolder = Workspace:FindFirstChild("Food") or Instance.new("Folder", Workspace)
foodFolder.Name = "Food"
local foodTemplates = ServerStorage:FindFirstChild("FoodTemplates") or ReplicatedStorage:FindFirstChild("FoodTemplates")

-- Lista cibi
getFoodListEvent.OnServerInvoke = function(player)
	if not isAdmin(player) then return {} end
	local names = {}
	for _, item in ipairs(foodTemplates:GetChildren()) do
		table.insert(names, item.Name)
	end
	return names
end

-- Lista players
getPlayersEvent.OnServerInvoke = function(player)
	if not isAdmin(player) then return {} end
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		table.insert(list, p.Name)
	end
	return list
end

-- Spawna cibo davanti a un player
spawnFoodEvent.OnServerEvent:Connect(function(player, foodName, targetName)
	if not isAdmin(player) then return end
	local template = foodTemplates:FindFirstChild(foodName)
	if not template then return end

	local target = targetName == "Me" and player or Players:FindFirstChild(targetName)
	if not target then return end

	local character = target.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local newFood = template:Clone()
	local spawnCFrame = rootPart.CFrame * CFrame.new(0, 0, -5)
	if newFood:IsA("Model") then
		newFood:PivotTo(spawnCFrame)
	else
		newFood.CFrame = spawnCFrame
	end
	newFood.Parent = foodFolder
	print("[ADMIN] Spawnato " .. foodName .. " davanti a " .. target.Name)
end)

-- Setta monete a un player
setCoinsEvent.OnServerEvent:Connect(function(player, targetName, amount)
	if not isAdmin(player) then return end

	local target = targetName == "Me" and player or Players:FindFirstChild(targetName)
	if not target then return end

	local leaderstats = target:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins then
			coins.Value = amount
			print("[ADMIN] Settate " .. amount .. " monete a " .. target.Name)
		end
	end
end)