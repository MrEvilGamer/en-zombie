QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('en-zombie:server:havedrink', function (source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName(Config.ZombieBottle) then
        cb(true)
    else
        cb(false)
    end
end)

RegisterNetEvent('en-zombie:removebottle', function ()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem(Config.ZombieBottle)
end)

RegisterNetEvent('en-zombie:server:syncweather', function (method)
    TriggerClientEvent('en-zombie:client:syncweather', -1, method)
end)

RegisterNetEvent('en-zombie:server:givecandy', function ()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem(Config.ZombieBottle, 1)
end)

RegisterNetEvent('en-zombie:DropPlayer', function ()
    DropPlayer(source, 'Don\'t Cheat Bro.')
end)

QBCore.Functions.CreateUseableItem(Config.ZombieBottle , function(source)
    TriggerClientEvent('en-zombie:progressbar', source)
end)