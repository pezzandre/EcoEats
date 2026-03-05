--Saluto giocatore
local function playerAdded(player)
    print("Un nuovo giocatore è arrivato! Benvenuto ", player)
end
game.Players.PlayerAdded:Connect(playerAdded)

--Prova individua parti toccate
local touchPart = game.Workspace.TouchPart
local partIsTouched = false
touchPart.Touched:Connect(function(otherPart)
    if partIsTouched == false then
        partIsTouched = true
        print(otherPart.Name)

        task.wait(2)
        partIsTouched = false
    end
end)

--Prova liquido letale 1 volta su 3
local liquido = game.Workspace.Pot.Liquido
liquido.Touched:Connect(function(otherPart)

    local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.BodyWidthScale.Value = 2
        humanoid.BodyDepthScale.Value = 2 
        humanoid.BodyHeightScale.Value = 2 
        humanoid.HeadScale.Value = 2 
        humanoid.JumpPower = 50
        humanoid.WalkSpeed = 20
        task.wait(5)
    end
end)