local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local quizFolder = Instance.new("Folder")
quizFolder.Name = "QuizEvents"
quizFolder.Parent = ReplicatedStorage

local rewardEvent = Instance.new("RemoteEvent")
rewardEvent.Name = "QuizReward"
rewardEvent.Parent = quizFolder

rewardEvent.OnServerEvent:Connect(function(player, correct)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end
	local coins = leaderstats:FindFirstChild("Coins")
	if not coins then return end

	if correct then
		coins.Value = coins.Value + 100
		print("[QUIZ] " .. player.Name .. " ha risposto correttamente! +100 monete")
	else
		coins.Value = math.max(0, coins.Value - 25)
		print("[QUIZ] " .. player.Name .. " ha sbagliato! -25 monete")
	end
end)