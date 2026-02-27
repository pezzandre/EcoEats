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