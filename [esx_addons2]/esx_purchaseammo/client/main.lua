ESX	= nil
local inMarker = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

CreateMarker = function(coords, rgba, height, scale) --Creates the marker
    coords = coords - vector3(0.0, 0.0, 1.0)
    local checkPoint = CreateCheckpoint(45, coords, coords, scale, rgba.red, rgba.green, rgba.blue, rgba.alpha, 0)
    SetCheckpointCylinderHeight(checkPoint, height, height, scale)
    return checkPoint
end

Citizen.CreateThread(function() --Checks to see if player is near the coords and if so, displays the text.
	while not NetworkIsSessionStarted() do -- Wait for the user to load
		Wait(500)
	end

	while true do
		Citizen.Wait(500)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Locations) do
		local markerlocation = vector3(v.x, v.y, v.z)
		CreateMarker(markerlocation, {red = 255, green = 240, blue = 0, alpha = 200}, 0.3, 0.75)
		
		while #(GetEntityCoords(PlayerPedId()) - markerlocation) <= 1.0 do
			Citizen.Wait(0)
			Draw3DText(markerlocation, "Press ~y~[E]~s~ to purchase ammo", 0.4)
			if IsControlJustReleased(0, 51) then
				OpenMenu()

				while ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "general_menu") do
					Wait(50)
				end
			end
		end
	end
end

	if inMarker then
		if IsControlJustReleased(0, 51) then
			OpenMenu()

			while ESX.UI.Menu.IsOpen("default", GetCurrentResourceName(), "general_menu") do
				Wait(50)
			end
		end
	end
end)

function OpenMenu() --Open the sell menu	
	ESX.UI.Menu.CloseAll()
	
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = "Buy Ammo",
		align = "top-left",
		elements = Config.Items
	}, function(data, menu)		
		TriggerServerEvent("esx_purchaseammo:Buy", data.current.item)
	end,
	function(data, menu)
		menu.close()
	end)
end

function Draw3DText(coords, text, scale) --Function to draw 3D text
	local x, y, z = table.unpack(coords)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 215)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 700
	DrawRect(_x, _y + 0.0150, 0.06 + factor, 0.03, 41, 11, 41, 100)
end