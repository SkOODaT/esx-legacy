local SkOODaTDebug = true

local HasAlreadyEnteredMarker = false
local CurrentAction, CurrentActionMsg, LastZone
local CurrentActionData = {}
ESX	= nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

--local inMarker = false
--[[CreateMarker = function(coords, rgba, height, scale)
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
			CreateMarker(markerlocation, {red = 0, green = 128, blue = 255, alpha = 200}, 0.3, 0.75)

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
end]]--

function OpenAmmoMenu()
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'general_menu', {
		title = _U('shop_menu_title'),
		align = "top-left",
		elements = Config.Items
	}, function(data, menu)
		-- Calculate Player Ammos
		print(ESX.PlayerData.ped)
		print(data.current.hash)
		local pammoCount = GetPedAmmoByType(ESX.PlayerData.ped, GetHashKey(data.current.hash))
		local ammoBool, ammoMax = GetMaxAmmoByType(ESX.PlayerData.ped, GetHashKey(data.current.hash))
		print(pammoCount)
		print(ammoMax)
		if SkOODaTDebug then
			print("---------------------")
			print("Player ammo count: ", pammoCount)
		end
		if pammoCount < ammoMax then
			local PlayerOpenSlots = ammoMax - pammoCount
			if SkOODaTDebug then
				print("Open ammo slots: ", PlayerOpenSlots)
			end
			if data.current.amount > PlayerOpenSlots then
				data.current.amount = PlayerOpenSlots
				if SkOODaTDebug then
					print("Added ammo count: ", data.current.amount)
				end
			end
		else
			if SkOODaTDebug then
				print('Max Ammo')
			end
			data.current.amount = 'FULL'
		end
		-- Purchase Sounds
		if data.current.amount == 'FULL' then
			PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
		else
			PlaySoundFrontend(-1, 'WEAPON_AMMO_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)
		end
		if SkOODaTDebug then
			print("TriggerServerEvent AMMO: ", data.current.amount)
		end
		-- Event Trigger
		TriggerServerEvent("esx_purchaseammo:Buy", data.current.hash, data.current.price, data.current.amount)
	end,
	function(data, menu)
		menu.close()
	end)
end

-- Entered Marker
AddEventHandler('esx_ammoshop:hasEnteredMarker', function(zone)
	if zone == 'GunShop' or zone == 'BlackShop' then
		CurrentAction = 'shop_menu'
		CurrentActionMsg = _U('shop_menu_prompt')
		CurrentActionData = {zone = zone}
	end
end)

-- Exited Marker
AddEventHandler('esx_ammoshop:hasExitedMarker', function(zone)
	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

-- Display Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		for k,v in pairs(Config.Zones) do
			for i = 1, #v.Locations, 1 do
				if (Config.MarkerInfo.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Locations[i], true) < Config.DrawDistance) then
					DrawMarker(Config.MarkerInfo.Type, v.Locations[i], 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.MarkerInfo.x, Config.MarkerInfo.y, Config.MarkerInfo.z, Config.MarkerInfo.r, Config.MarkerInfo.g, Config.MarkerInfo.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local isInMarker, currentZone = false, nil
		for k,v in pairs(Config.Zones) do
			for i=1, #v.Locations, 1 do
				if GetDistanceBetweenCoords(coords, v.Locations[i], true) < Config.MarkerInfo.x then
					isInMarker, currentZone, LastZone = true, k, k
				end
			end
		end
		if isInMarker and not HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = true
			TriggerEvent('esx_ammoshop:hasEnteredMarker', currentZone)
		end
		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_ammoshop:hasExitedMarker', LastZone)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	-- Wait for the user to load
	while not NetworkIsSessionStarted() do
		Wait(500)
	end
	while true do
		Citizen.Wait(0)
		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			if IsControlJustReleased(0, 51) then
				if CurrentAction == 'shop_menu' then
					OpenAmmoMenu()
				end
				CurrentAction = nil
			end
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	if Config.UseBlips then
		for k,v in pairs(Config.Zones) do
			if v.Legal then
				for i = 1, #v.Locations, 1 do
					local blip = AddBlipForCoord(v.Locations[i])
					SetBlipSprite (blip, 556)
					SetBlipDisplay(blip, 4)
					SetBlipScale  (blip, 0.4)
					SetBlipColour (blip, 60)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentSubstringPlayerName(_U('map_blip'))
					EndTextCommandSetBlipName(blip)
				end
			end
		end
	end
end)