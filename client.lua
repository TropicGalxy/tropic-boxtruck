local QBCore = exports['qb-core']:GetCoreObject()

local spawnedTrucks = {}
local usedSpots = {}
local isNearTruck = false
local showingText = false
local cooldown = false

function CreateBoltCutter(prop, ped)
    local cutteritem = CreateObject(GetHashKey(prop), GetEntityCoords(ped), true, true, true)
    SetEntityCollision(cutteritem, false, true)
    return cutteritem
end

CreateThread(function()
    local spotIndexes = {}
    for i = 1, #Config.TruckSpots do
        table.insert(spotIndexes, i)
    end

    while #spawnedTrucks < Config.MaxTrucks and #spotIndexes > 0 do
        -- Select a random index from the available spotIndexes
        local randomIndex = math.random(#spotIndexes)
        local spotIndex = table.remove(spotIndexes, randomIndex)
        local spot = Config.TruckSpots[spotIndex]

        local model = GetHashKey(Config.TruckModels[math.random(#Config.TruckModels)])
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local truck = CreateVehicle(model, spot.x, spot.y, spot.z, spot.heading, true, false)
        SetVehicleOnGroundProperly(truck)
        SetModelAsNoLongerNeeded(model)
        table.insert(spawnedTrucks, truck)
        usedSpots[spotIndex] = true

        Wait(Config.SpawnInterval)
    end
end)

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local nearTruck = false

        for _, truck in ipairs(spawnedTrucks) do
            local backOfTruck = GetOffsetFromEntityInWorldCoords(truck, 0.0, -2.5, 1.0)
            local distance = #(pedCoords - backOfTruck)

            if distance <= 2.5 then
                nearTruck = true
                if not isNearTruck then
                    isNearTruck = true
                    showingText = true
                    lib.showTextUI('[E] Break into truck', { 
                        position = "right-center", 
                        icon = 'truck', 
                        style = { backgroundColor = '#1C1C1C', color = '#FFFFFF' } 
                    })
                end

                if IsControlJustReleased(0, 38) and not cooldown then
                    cooldown = true

                    local success = lib.skillCheck(Config.Minigame.difficulty, {'e'})

                    if success then
                        local complete = lib.progressCircle({
                            duration = 6000,
                            position = 'bottom',
                            useWhileDead = false,
                            label = "Breaking into truck..",
                            canCancel = false,
                            anim = {
                                dict = 'anim@scripted@heist@ig4_bolt_cutters@male@',
                                clip = 'action_male'
                            },
                            prop = {
                                model = 'h4_prop_h4_bolt_cutter_01a',
                                bone = 28422,
                                pos = vec3(-0.03, 0.0, 0.0),
                                rot = vec3(0.0, -90.0, 0.0)
                            }
                        })

                        if complete then
                            TriggerEvent('tropic-boxtruck:interactTruck', truck)
                            exports['ps-dispatch']:VehicleTheft(truck)
                        end
                    else
                        QBCore.Functions.Notify("You failed the minigame.", "error")
                    end

                    SetTimeout(Config.Cooldown, function()
                        cooldown = false
                    end)
                end
            end
        end

        if not nearTruck and isNearTruck then
            isNearTruck = false
            if showingText then
                lib.hideTextUI()
                showingText = false
            end
        end

        Wait(0)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    -- Delete all spawned trucks when the resource stops
    for _, truck in ipairs(spawnedTrucks) do
        if DoesEntityExist(truck) then
            DeleteVehicle(truck)
        end
    end
end)
