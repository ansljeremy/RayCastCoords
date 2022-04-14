local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("raycastcoords", "Enable raycast coords (God Only)", {}, false, function(source, args)
    TriggerClientEvent('RayCastCoords:client:toggle', source)
end, "god")