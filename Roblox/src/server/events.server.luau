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
        humanoid.Health = math.random(0, 5) -- 0 = kill
        print(humanoid.Health)
        task.wait(5)
    end
end)