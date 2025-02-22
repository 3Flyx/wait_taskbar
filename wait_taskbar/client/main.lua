mythic_action = {
    name = "",
    duration = 0,
    label = "",
    useWhileDead = false,
    canCancel = true,
    controlDisables = {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = false,
    },
    animation = {
        animDict = nil,
        anim = nil,
        flags = 0,
        task = nil,
    },
    prop = {
        model = nil,
        bone = nil,
        coords = { x = 0.0, y = 0.0, z = 0.0 },
        rotation = { x = 0.0, y = 0.0, z = 0.0 },
    },
    propTwo = {
        model = nil,
        bone = nil,
        coords = { x = 0.0, y = 0.0, z = 0.0 },
        rotation = { x = 0.0, y = 0.0, z = 0.0 },
    },
}

local isDoingAction = false
local disableMouse = false
local wasCancelled = false
local isAnim = false
local isProp = false
local isPropTwo = false
local prop_net = nil
local propTwo_net = nil
local runProgThread = false
--[[ DEBUG
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 38) then
            TriggerEvent("wait_taskbar:progress", {
                name = "test_notif",
                duration = 5000,
                label = "Testowy pasek postępu",
                useWhileDead = true,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                },s
                prop = {
                },
                propTwo = {
                },
            })
        end
    end
end)]]

function Progress(action, finish)
    ActionStart()
    mythic_action = action

    if not IsEntityDead(PlayerPedId()) or mythic_action.useWhileDead then
        if not isDoingAction then
            isDoingAction = true
            wasCancelled = false
            isAnim = false
            isProp = false

            SendNUIMessage({
                action = "mythic_progress",
                duration = mythic_action.duration,
                label = mythic_action.label
            })

            Citizen.CreateThread(function ()
                while isDoingAction do
                    Citizen.Wait(0)
                    if IsControlJustPressed(0, 73) and mythic_action.canCancel then
                        TriggerEvent("wait_taskbar:cancel")
                    end

                    if IsEntityDead(PlayerPedId()) and not mythic_action.useWhileDead then
                        TriggerEvent("wait_taskbar:cancel")
                    end
                end
                if finish ~= nil then
                    finish(wasCancelled)
                end
            end)
        end
    end
end

function ProgressWithStartEvent(action, start, finish)
    ActionStart()
    mythic_action = action

    if not IsEntityDead(PlayerPedId()) or mythic_action.useWhileDead then
        if not isDoingAction then
            isDoingAction = true
            wasCancelled = false
            isAnim = false
            isProp = false

            SendNUIMessage({
                action = "mythic_progress",
                duration = mythic_action.duration,
                label = mythic_action.label
            })

            Citizen.CreateThread(function ()
                if start ~= nil then
                    start()
                end
                while isDoingAction do
                    if IsControlJustPressed(0, 178) and mythic_action.canCancel then
                        TriggerEvent("wait_taskbar:cancel")
                    end

                    if IsEntityDead(PlayerPedId()) and not mythic_action.useWhileDead then
                        TriggerEvent("wait_taskbar:cancel")
                    end

                    Citizen.Wait(0)
                end
                if finish ~= nil then
                    finish(wasCancelled)
                end
            end)
        end
    end
end

function ProgressWithTickEvent(action, tick, finish)
    ActionStart()
    mythic_action = action

    if not IsEntityDead(PlayerPedId()) or mythic_action.useWhileDead then
        if not isDoingAction then
            isDoingAction = true
            wasCancelled = false
            isAnim = false
            isProp = false

            SendNUIMessage({
                action = "mythic_progress",
                duration = mythic_action.duration,
                label = mythic_action.label
            })

            Citizen.CreateThread(function ()
                while isDoingAction do
                    if tick ~= nil then
                        tick()
                    end
                    if IsControlJustPressed(0, 178) and mythic_action.canCancel then
                        TriggerEvent("wait_taskbar:cancel")
                    end

                    if IsEntityDead(PlayerPedId()) and not mythic_action.useWhileDead then
                        TriggerEvent("wait_taskbar:cancel")
                    end

                    Citizen.Wait(0)
                end
                if finish ~= nil then
                    finish(wasCancelled)
                end
            end)
        end
    end
end

function ProgressWithStartAndTick(action, start, tick, finish)
    ActionStart()
    mythic_action = action

    if not IsEntityDead(PlayerPedId()) or mythic_action.useWhileDead then
        if not isDoingAction then
            isDoingAction = true
            wasCancelled = false
            isAnim = false
            isProp = false

            SendNUIMessage({
                action = "mythic_progress",
                duration = mythic_action.duration,
                label = mythic_action.label
            })

            Citizen.CreateThread(function ()
                if start ~= nil then
                    start()
                end
                while isDoingAction do
                    if tick ~= nil then
                        tick()
                    end
                    if IsControlJustPressed(0, 178) and mythic_action.canCancel then
                        TriggerEvent("wait_taskbar:cancel")
                    end

                    if IsEntityDead(PlayerPedId()) and not mythic_action.useWhileDead then
                        TriggerEvent("wait_taskbar:cancel")
                    end

                    Citizen.Wait(0)
                end
                if isAnim then
                    ClearPedSecondaryTask(PlayerPedId())
                end
                if finish ~= nil then
                    finish(wasCancelled)
                end
            end)
        end
    end
end

RegisterNetEvent("wait_taskbar:progress")
AddEventHandler("wait_taskbar:progress", Progress)

RegisterNetEvent("wait_taskbar:ProgressWithStartEvent")
AddEventHandler("wait_taskbar:ProgressWithStartEvent", function(action, start, finish)
    ProgressWithStartEvent(action, start, finish)
end)

RegisterNetEvent("wait_taskbar:ProgressWithTickEvent")
AddEventHandler("wait_taskbar:ProgressWithTickEvent", function(action, tick, finish)
    ProgressWithTickEvent(action, tick, finish)
end)

RegisterNetEvent("wait_taskbar:ProgressWithStartAndTick")
AddEventHandler("wait_taskbar:ProgressWithStartAndTick", function(action, start, tick, finish)
    ProgressWithStartAndTick(action, start, tick, finish)
end)

RegisterNetEvent("wait_taskbar:cancel")
AddEventHandler("wait_taskbar:cancel", function()
    isDoingAction = false
    wasCancelled = true

    TriggerEvent("wait_taskbar:actionCleanup")

    SendNUIMessage({
        action = "mythic_progress_cancel"
    })
end)

RegisterNetEvent("wait_taskbar:actionCleanup")
AddEventHandler("wait_taskbar:actionCleanup", function()
    local ped = PlayerPedId()
    --ClearPedTasks(ped)

   --[[ if mythic_action.animation.anim then
        if mythic_action.animation.task ~= nil or (mythic_action.animation.animDict ~= nil and mythic_action.animation.anim ~= nil) then
            ClearPedSecondaryTask(ped)
            StopAnimTask(ped, mythic_action.animDict, mythic_action.anim, 1.0)
        else
            ClearPedTasks(ped)
        end
    end]]

    DetachEntity(NetToObj(prop_net), 1, 1)
    DeleteEntity(NetToObj(prop_net))
    DetachEntity(NetToObj(propTwo_net), 1, 1)
    DeleteEntity(NetToObj(propTwo_net))
    prop_net = nil
    propTwo_net = nil
    runProgThread = false
end)

-- Disable controls while GUI open
function ActionStart()
    runProgThread = true
    Citizen.CreateThread(function()
        while runProgThread do
            if isDoingAction then
                if not isAnim then
                    if mythic_action.animation ~= nil then
                        if mythic_action.animation.task ~= nil then
                            TaskStartScenarioInPlace(PlayerPedId(), mythic_action.animation.task, 0, true)
                        elseif mythic_action.animation.animDict ~= nil and mythic_action.animation.anim ~= nil then
                            if mythic_action.animation.flags == nil then
                                mythic_action.animation.flags = 1
                            end

                            local player = PlayerPedId()
                            if ( DoesEntityExist( player ) and not IsEntityDead( player )) then
                                loadAnimDict( mythic_action.animation.animDict )
                                TaskPlayAnim( player, mythic_action.animation.animDict, mythic_action.animation.anim, 3.0, 1.0, -1, mythic_action.animation.flags, 0, 0, 0, 0 )     
                            end
                        else
                            --TaskStartScenarioInPlace(PlayerPedId(), 'PROP_HUMAN_BUM_BIN', 0, true)
                        end
                    elseif mythic_action.scenario ~= nil then
                        TaskStartScenarioInPlace(PlayerPedId(), mythic_action.scenario, 0, true)
                    end

                    isAnim = true
                end
                if not isProp and mythic_action.prop ~= nil and mythic_action.prop.model ~= nil then
                    RequestModel(mythic_action.prop.model)

                    while not HasModelLoaded(joaat(mythic_action.prop.model)) do
                        Citizen.Wait(0)
                    end

                    local pCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
                    local modelSpawn = CreateObject(joaat(mythic_action.prop.model), pCoords.x, pCoords.y, pCoords.z, true, true, true)

                    local netid = ObjToNet(modelSpawn)
                    SetNetworkIdExistsOnAllMachines(netid, true)
                    NetworkSetNetworkIdDynamic(netid, true)
                    SetNetworkIdCanMigrate(netid, false)
                    if mythic_action.prop.bone == nil then
                        mythic_action.prop.bone = 60309
                    end

                    if mythic_action.prop.coords == nil then
                        mythic_action.prop.coords = { x = 0.0, y = 0.0, z = 0.0 }
                    end

                    if mythic_action.prop.rotation == nil then
                        mythic_action.prop.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                    end

                    AttachEntityToEntity(modelSpawn, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), mythic_action.prop.bone), mythic_action.prop.coords.x, mythic_action.prop.coords.y, mythic_action.prop.coords.z, mythic_action.prop.rotation.x, mythic_action.prop.rotation.y, mythic_action.prop.rotation.z, 1, 1, 0, 1, 0, 1)
                    prop_net = netid

                    isProp = true
                    
                    if not isPropTwo and mythic_action.propTwo ~= nil and mythic_action.propTwo.model ~= nil then
                        RequestModel(mythic_action.propTwo.model)

                        while not HasModelLoaded(joaat(mythic_action.propTwo.model)) do
                            Citizen.Wait(0)
                        end

                        local pCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
                        local modelSpawn = CreateObject(joaat(mythic_action.propTwo.model), pCoords.x, pCoords.y, pCoords.z, true, true, true)

                        local netid = ObjToNet(modelSpawn)
                        SetNetworkIdExistsOnAllMachines(netid, true)
                        NetworkSetNetworkIdDynamic(netid, true)
                        SetNetworkIdCanMigrate(netid, false)
                        if mythic_action.propTwo.bone == nil then
                            mythic_action.propTwo.bone = 60309
                        end

                        if mythic_action.propTwo.coords == nil then
                            mythic_action.propTwo.coords = { x = 0.0, y = 0.0, z = 0.0 }
                        end

                        if mythic_action.propTwo.rotation == nil then
                            mythic_action.propTwo.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                        end

                        AttachEntityToEntity(modelSpawn, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), mythic_action.propTwo.bone), mythic_action.propTwo.coords.x, mythic_action.propTwo.coords.y, mythic_action.propTwo.coords.z, mythic_action.propTwo.rotation.x, mythic_action.propTwo.rotation.y, mythic_action.propTwo.rotation.z, 1, 1, 0, 1, 0, 1)
                        propTwo_net = netid

                        isPropTwo = true
                    end
                end

                DisableActions(PlayerPedId())
            end
            Citizen.Wait(0)
        end
    end)
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

function DisableActions(ped)
    if mythic_action.controlDisables.disableMouse then
        DisableControlAction(0, 1, true) -- LookLeftRight
        DisableControlAction(0, 2, true) -- LookUpDown
        DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    end

    if mythic_action.controlDisables.disableMovement then
        DisableControlAction(0, 30, true) -- disable left/right
        DisableControlAction(0, 31, true) -- disable forward/back
        DisableControlAction(0, 36, true) -- INPUT_DUCK
        DisableControlAction(0, 21, true) -- disable sprint
        DisableControlAction(0, 40, true) -- disable sprint
    end

    if mythic_action.controlDisables.disableCarMovement then
        DisableControlAction(0, 63, true) -- veh turn left
        DisableControlAction(0, 64, true) -- veh turn right
        DisableControlAction(0, 71, true) -- veh forward
        DisableControlAction(0, 72, true) -- veh backwards
        DisableControlAction(0, 75, true) -- disable exit vehicle
    end

    if mythic_action.controlDisables.disableCombat then
        DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
        DisableControlAction(0, 24, true) -- disable attack
        DisableControlAction(0, 25, true) -- disable aim
        DisableControlAction(1, 37, true) -- disable weapon select
        DisableControlAction(0, 47, true) -- disable weapon
        DisableControlAction(0, 58, true) -- disable weapon
        DisableControlAction(0, 140, true) -- disable melee
        DisableControlAction(0, 141, true) -- disable melee
        DisableControlAction(0, 142, true) -- disable melee
        DisableControlAction(0, 143, true) -- disable melee
        DisableControlAction(0, 263, true) -- disable melee
        DisableControlAction(0, 264, true) -- disable melee
        DisableControlAction(0, 257, true) -- disable melee
        DisableControlAction(0, 289, true) -- f2
    end
end

RegisterNUICallback('actionFinish', function(data, cb)
    -- Do something here
    isDoingAction = false
    TriggerEvent("wait_taskbar:actionCleanup")
    cb('ok')
end)

RegisterNUICallback('actionCancel', function(data, cb)
    -- Do something here
    cb('ok')
end)