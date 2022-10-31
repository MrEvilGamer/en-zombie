QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function ()
    TriggerServerEvent('en-zombie:server:syncweather')
end)

CreateThread(function()
    local hash = GetHashKey("cs_drfriedlander")
    QBCore.Functions.LoadModel(hash)
    local hostage = CreatePed("PED_TYPE_CIVFEMALE", "cs_drfriedlander", Config.Location, false, false)
    SetBlockingOfNonTemporaryEvents(hostage, true)
    SetPedDiesWhenInjured(hostage, false)
    SetPedCanPlayAmbientAnims(hostage, true)
    SetPedCanRagdollFromPlayerImpact(hostage, false)
    SetEntityInvincible(hostage, true)
    FreezeEntityPosition(hostage, true)
    loadAnimDict('amb@world_human_aa_smoke@male@idle_a')
    TaskPlayAnim(hostage, 'amb@world_human_aa_smoke@male@idle_a', 'idle_c', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
end)

CreateThread(function ()
    exports['qb-target']:AddTargetModel('cs_drfriedlander', {
        options = {
            { 
                event = "en-zombie:givecandy",
                icon = "fas fa-money",
                label = 'Trick or Treat!',
            },
        },
        distance = 1.0 
    })
end)

RegisterNetEvent('en-zombie:client:syncweather', function ()
    SetWeatherTypeNow('HALLOWEEN')
end)

RegisterNetEvent('en-zombie:givecandy', function ()
    TriggerServerEvent('en-zombie:server:givecandy')
end)

RegisterNetEvent('en-zombie:swaptozombie', function ()
    local armorAmount = GetPedArmour(PlayerPedId())
    if IsPedMale then
        local model = Config.ChangeMaleModel
        if IsModelInCdimage(model) and IsModelValid(model) then
            RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        end
        TriggerServerEvent('en-zombie:removebottle')
        SetPedArmour(PlayerPedId(), armorAmount)
        AlienEffect()
    else
        local model = Config.FemaleModel
        if IsModelInCdimage(model) and IsModelValid(model) then
            RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        end
        TriggerServerEvent('en-zombie:removebottle')
        SetPedArmour(PlayerPedId(), armorAmount)
        AlienEffect()
    end
end)

RegisterNetEvent('en-zombie:progressbar', function ()
    -- For Exploit Checks
    QBCore.Functions.TriggerCallback('en-zombie:server:havedrink', function(result)
        if result then
            TriggerEvent('animations:client:EmoteCommandStart', {"drink"})
            QBCore.Functions.Progressbar('transfer_zombie', 'Drinking....', 5000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Play When Done
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                DoScreenFadeOut(3000)
                TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 7.0, "zombie", 1)
                Wait(3000)
                DoScreenFadeIn(3000)
                TriggerEvent('en-zombie:swaptozombie')
            end, function() -- Play When Cancel
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify('Canclled!', 'error', 7500)
            end)
        else
           TriggerServerEvent('en-zombie:DropPlayer')
        end
    end)
end)

function IsPedMale()
    local gender = QBCore.Functions.GetPlayerData().charinfo.gender
    return gender == 0
end

function reloadSkin()
    local model
    local health = GetEntityHealth(PlayerPedId())
    local armorAmount = GetPedArmour(PlayerPedId())
    local gender = QBCore.Functions.GetPlayerData().charinfo.gender
    local maxhealth = GetEntityMaxHealth(PlayerPedId())

    if gender == 1 then -- Gender is ONE for FEMALE
        model = GetHashKey("mp_f_freemode_01") -- Female Model
    else
        model = GetHashKey("mp_m_freemode_01") -- Male Model
    end

    RequestModel(model)

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    Citizen.Wait(1000) -- Safety Delay

    TriggerServerEvent("qb-clothes:loadPlayerSkin") -- LOADING PLAYER'S CLOTHES
    TriggerServerEvent("qb-clothing:loadPlayerSkin") -- LOADING PLAYER'S CLOTHES - Event 2

    SetPedMaxHealth(PlayerId(), maxhealth)
    Citizen.Wait(1000) -- Safety Delay
    SetEntityHealth(PlayerPedId(), health)
    SetPedArmour(PlayerPedId(), armorAmount)
end

function AlienEffect()
    local playerPed = PlayerPedId()
  
        RequestAnimSet("move_m@drunk@moderatedrunk") 
    while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
      Citizen.Wait(0)
    end    

    Citizen.Wait(3000)
    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@drunk@moderatedrunk", true)
    SetPedIsDrug(playerPed, true)

    --Efects
    local player = PlayerId()
    SetRunSprintMultiplierForPlayer(player, 1.2)
    SetSwimMultiplierForPlayer(player, 1.3)

    Wait(520000)

    SetRunSprintMultiplierForPlayer(player, 1.0)
    SetSwimMultiplierForPlayer(player, 1.0)
end


function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(0)
    end
end