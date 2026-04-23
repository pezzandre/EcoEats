local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StartDialogueEvent = ReplicatedStorage:WaitForChild("StartDialogueEvent")

local function setupProximityPrompts()
	for _, descendant in pairs(workspace:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") then
			local npcModel = descendant.Parent
			-- Risali finché non trovi il Model con Humanoid
			while npcModel and not (npcModel:IsA("Model") and npcModel:FindFirstChild("Humanoid")) do
				npcModel = npcModel.Parent
			end
			if npcModel then
				descendant.Triggered:Connect(function(player)
					StartDialogueEvent:FireClient(player, npcModel.Name)
				end)
			end
		end
	end
end

setupProximityPrompts()

workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("ProximityPrompt") then
		local npcModel = descendant.Parent
		while npcModel and not (npcModel:IsA("Model") and npcModel:FindFirstChild("Humanoid")) do
			npcModel = npcModel.Parent
		end
		if npcModel then
			descendant.Triggered:Connect(function(player)
				StartDialogueEvent:FireClient(player, npcModel.Name)
			end)
		end
	end
end)