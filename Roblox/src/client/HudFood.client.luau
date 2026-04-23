local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local updateUIEvent = ReplicatedStorage:WaitForChild("CookingUpdateUI")
local removeIngredientEvent = ReplicatedStorage:WaitForChild("RemoveIngredientEvent")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CookingScreen"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Name = "CookingFrame"
frame.Size = UDim2.new(0, 260, 0, 50)
frame.Position = UDim2.new(0.5, -130, 0.65, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Visible = false  -- ✅ nascosto di default
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local currentModel = nil

updateUIEvent.OnClientEvent:Connect(function(model, ingredients)
	currentModel = model

	for _, child in ipairs(frame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	if #ingredients == 0 then
		frame.Visible = false
		return
	end

	frame.Visible = true

	local btnH = 50
	local padding = 8
	local totalH = #ingredients * (btnH + padding) + padding
	frame.Size = UDim2.new(0, 260, 0, totalH)

	for i, foodName in ipairs(ingredients) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 240, 0, btnH)
		btn.Position = UDim2.new(0, 10, 0, (i - 1) * (btnH + padding) + padding)
		btn.Text = "❌  " .. foodName
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 16
		btn.BackgroundColor3 = Color3.fromRGB(40, 90, 200)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.BorderSizePixel = 0
		btn.Parent = frame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = btn

		local capturedIndex = i
		btn.MouseButton1Click:Connect(function()
			if currentModel then
				print("🖱️ Client: Rimuovi ingrediente #" .. capturedIndex)
				removeIngredientEvent:FireServer(currentModel, capturedIndex)
			end
		end)
	end
end)