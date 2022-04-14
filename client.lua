local QBCore = exports['qb-core']:GetCoreObject()

local enabled = false

RegisterNetEvent('RayCastCoords:client:toggle')
AddEventHandler('RayCastCoords:client:toggle', function()
    if not enabled then
        enabled = true
        QBCore.Functions.Notify("RayCast Coords activated", "success")
    else
        enabled = false
        QBCore.Functions.Notify("RayCast Coords deactivated", "error")
    end
end)

function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end

function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function CopyToClipboard(x, y, z)
    local x = math.round(x, 2)
    local y = math.round(y, 2)
    local z = math.round(z, 2)
    SendNUIMessage({
        string = string.format('vector3(%s, %s, %s)', x, y, z)
    })
    QBCore.Functions.Notify("Coordinates copied to clipboard!", "success")
end

function math.round(input, decimalPlaces)
    return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", input))
end

Citizen.CreateThread(function()
	while true do
        local Wait = 5
        if enabled then
            local color = {r = 255, g = 255, b = 255, a = 200}
            local position = GetEntityCoords(PlayerPedId())
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            Draw2DText('Raycast Coords: ' .. coords.x .. ' ' ..  coords.y .. ' ' .. coords.z, 4, {255, 255, 255}, 0.4, 0.55, 0.888)
            Draw2DText('Press ~g~E ~w~to copy to clipboard', 4, {255, 255, 255}, 0.4, 0.55, 0.888 + 0.025)
            DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
            DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
            if IsControlJustReleased(0, 38) then
                CopyToClipboard(coords.x, coords.y, coords.z)
            end
        else
            local Wait = 500
        end
        Citizen.Wait(Wait)
	end
end)