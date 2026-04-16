-- File: src/client/FoodTimerHUD.client.luau
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

-- 1. CREIAMO LA GUI (In basso al centro, sopra l'inventario)
local timerGui = Instance.new("ScreenGui")
timerGui.Name = "FoodTimerHUD"
timerGui.ResetOnSpawn = false
timerGui.Parent = pGui

local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.fromOffset(250, 40)
timerLabel.Position = UDim2.new(0.5, -125, 1, -120) -- Centrato in basso
timerLabel.BackgroundTransparency = 0.4
timerLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.FredokaOne
timerLabel.Visible = false -- Invisibile finché non prendi in mano il cibo
timerLabel.Parent = timerGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = timerLabel

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Parent = timerLabel

-- 2. LOGICA DEL TIMER
local currentTool = nil
local updateConnection = nil

local function updateTimerDisplay()
    if not currentTool then
        timerLabel.Visible = false
        return
    end

    local spoiledTime = currentTool:GetAttribute("SpoiledTime")
    local currentAge = currentTool:GetAttribute("CurrentAge")

    if spoiledTime and currentAge then
        -- Calcoliamo quanto manca alla scadenza (math.max evita numeri negativi)
        local remaining = math.max(0, math.floor(spoiledTime - currentAge))
        
        timerLabel.Visible = true
        
        -- Cambiamo colore e testo in base al tempo!
        if remaining <= 0 then
            timerLabel.Text = "☠️ SPOILED!"
            timerLabel.TextColor3 = Color3.fromRGB(255, 50, 50) -- Rosso
        elseif remaining <= 15 then
            timerLabel.Text = "⏳ Spoil in: " .. remaining .. "s"
            timerLabel.TextColor3 = Color3.fromRGB(255, 150, 0) -- Arancione (Sta scadendo)
        else
            timerLabel.Text = "⏳ Expire in: " .. remaining .. "s"
            timerLabel.TextColor3 = Color3.fromRGB(50, 255, 50) -- Verde (Fresco)
        end
    else
        timerLabel.Visible = false
    end
end

-- 3. ASCOLTIAMO QUANDO IL GIOCATORE EQUIPAGGIA UN CIBO
local function onCharacterAdded(character)
    -- Quando prendi in mano un oggetto, diventa "figlio" del tuo personaggio
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and child:GetAttribute("SpoiledTime") then
            currentTool = child
            updateTimerDisplay()
            
            -- Ascoltiamo i cambiamenti di età
            if updateConnection then updateConnection:Disconnect() end
            updateConnection = currentTool:GetAttributeChangedSignal("CurrentAge"):Connect(updateTimerDisplay)
        end
    end)

    -- Quando metti via l'oggetto (torna nello zaino)
    character.ChildRemoved:Connect(function(child)
        if child == currentTool then
            currentTool = nil
            if updateConnection then updateConnection:Disconnect() end
            updateTimerDisplay()
        end
    end)
end

-- Avvio dello script
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end