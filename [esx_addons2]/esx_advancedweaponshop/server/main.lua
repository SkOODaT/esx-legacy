local shopMelee, shopHandgun, shopSMG, shopShotgun, shopAssault, shopLMG, shopSniper, shopHeavy = {}, {}, {}, {}, {}, {}, {}, {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()
	-- Get/Send Melee Weapons
	MySQL.Async.fetchAll('SELECT * FROM weaponshops WHERE category = @category', {
		['@category'] = 'melee'
	}, function(shopMeleeResult)
		for i=1, #shopMeleeResult, 1 do
			if shopMelee[shopMeleeResult[i].zone] == nil then
				shopMelee[shopMeleeResult[i].zone] = {}
			end
			
			table.insert(shopMelee[shopMeleeResult[i].zone], {
				item = shopMeleeResult[i].item,
				ammo = shopMeleeResult[i].ammo,
				price = shopMeleeResult[i].price,
				label = ESX.GetWeaponLabel(shopMeleeResult[i].item)
			})
		end

		TriggerClientEvent('esx_advancedweaponshop:sendMelee', -1, shopMelee)
	end)

	-- Get/Send Handguns
	MySQL.Async.fetchAll('SELECT * FROM weaponshops WHERE category = @category', {
		['@category'] = 'handgun'
	}, function(shopHandgunResult)
		for i=1, #shopHandgunResult, 1 do
			if shopHandgun[shopHandgunResult[i].zone] == nil then
				shopHandgun[shopHandgunResult[i].zone] = {}
			end
			
			table.insert(shopHandgun[shopHandgunResult[i].zone], {
				item = shopHandgunResult[i].item,
				ammo = shopHandgunResult[i].ammo,
				price = shopHandgunResult[i].price,
				label = ESX.GetWeaponLabel(shopHandgunResult[i].item)
			})
		end

		TriggerClientEvent('esx_advancedweaponshop:sendHandgun', -1, shopHandgun)
	end)

	-- Get/Send SMGs
	MySQL.Async.fetchAll('SELECT * FROM weaponshops WHERE category = @category', {
		['@category'] = 'smg'
	}, function(shopSMGResult)
		for i=1, #shopSMGResult, 1 do
			if shopSMG[shopSMGResult[i].zone] == nil then
				shopSMG[shopSMGResult[i].zone] = {}
			end
			
			table.insert(shopSMG[shopSMGResult[i].zone], {
				item = shopSMGResult[i].item,
				ammo = shopSMGResult[i].ammo,
				price = shopSMGResult[i].price,
				label = ESX.GetWeaponLabel(shopSMGResult[i].item)
			})
		end

		TriggerClientEvent('esx_advancedweaponshop:sendSMG', -1, shopSMG)
	end)

	-- Get/Send Shotguns
	MySQL.Async.fetchAll('SELECT * FROM weaponshops WHERE category = @category', {
		['@category'] = 'shotgun'
	}, function(shopShotgunResult)
		for i=1, #shopShotgunResult, 1 do
			if shopShotgun[shopShotgunResult[i].zone] == nil then
				shopShotgun[shopShotgunResult[i].zone] = {}
			end
			
			table.insert(shopShotgun[shopShotgunResult[i].zone], {
				item = shopShotgunResult[i].item,
				ammo = shopShotgunResult[i].ammo,
				price = shopShotgunResult[i].price,
				label = ESX.GetWeaponLabel(shopShotgunResult[i].item)
			})
		end

		TriggerClientEvent('esx_advancedweaponshop:sendShotgun', -1, shopShotgun)
	end)

	-- Get/Send Assault Rifles
	MySQL.Async.fetchAll('SELECT * FROM weaponshops WHERE category = @category', {
		['@category'] = 'assault'
	}, function(shopAssaultResult)
		for i=1, #shopAssaultResult, 1 do
			if shopAssault[shopAssaultResult[i].zone] == nil then
				shopAssault[shopAssaultResult[i].zone] = {}
			end
			
			table.insert(shopAssault[shopAssaultResult[i].zone], {
				item = shopAssaultResult[i].item,
				ammo = shopAssaultResult[i].ammo,
				price = shopAssaultResult[i].price,
				label = ESX.GetWeaponLabel(shopAssaultResult[i].item)
			})
		end

		TriggerClientEvent('esx_advancedweaponshop:sendAssault', -1, shopAssault)
	end)

	-- Get/Send LMGs
	MySQL.Async.fetchAll('SELECT * FROM weaponshops WHERE category = @category', {
		['@category'] = 'lmg'
	}, function(shopLMGResult)
		for i=1, #shopLMGResult, 1 do
			if shopLMG[shopLMGResult[i].zone] == nil then
				shopLMG[shopLMGResult[i].zone] = {}
			end
			
			table.insert(shopLMG[shopLMGResult[i].zone], {
				item = shopLMGResult[i].item,
				ammo = shopLMGResult[i].ammo,
				price = shopLMGResult[i].price,
				label = ESX.GetWeaponLabel(shopLMGResult[i].item)
			})
		end

		TriggerClientEvent('esx_advancedweaponshop:sendLMG', -1, shopLMG)
	end)

	-- Get/Send Sniper Rifles
	MySQL.Async.fetchAll('SELECT * FROM weaponshops WHERE category = @category', {
		['@category'] = 'sniper'
	}, function(shopSniperResult)
		for i=1, #shopSniperResult, 1 do
			if shopSniper[shopSniperResult[i].zone] == nil then
				shopSniper[shopSniperResult[i].zone] = {}
			end
			
			table.insert(shopSniper[shopSniperResult[i].zone], {
				item = shopSniperResult[i].item,
				ammo = shopSniperResult[i].ammo,
				price = shopSniperResult[i].price,
				label = ESX.GetWeaponLabel(shopSniperResult[i].item)
			})
		end

		TriggerClientEvent('esx_advancedweaponshop:sendSniper', -1, shopSniper)
	end)

	-- Get/Send Heavys
	MySQL.Async.fetchAll('SELECT * FROM weaponshops WHERE category = @category', {
		['@category'] = 'heavy'
	}, function(shopHeavyResult)
		for i=1, #shopHeavyResult, 1 do
			if shopHeavy[shopHeavyResult[i].zone] == nil then
				shopHeavy[shopHeavyResult[i].zone] = {}
			end
			
			table.insert(shopHeavy[shopHeavyResult[i].zone], {
				item = shopHeavyResult[i].item,
				ammo = shopHeavyResult[i].ammo,
				price = shopHeavyResult[i].price,
				label = ESX.GetWeaponLabel(shopHeavyResult[i].item)
			})
		end

		TriggerClientEvent('esx_advancedweaponshop:sendHeavy', -1, shopHeavy)
	end)

end)

ESX.RegisterServerCallback('esx_advancedweaponshop:getMelee', function(source, cb)
	cb(shopMelee)
end)

ESX.RegisterServerCallback('esx_advancedweaponshop:getHandgun', function(source, cb)
	cb(shopHandgun)
end)

ESX.RegisterServerCallback('esx_advancedweaponshop:getSMG', function(source, cb)
	cb(shopSMG)
end)

ESX.RegisterServerCallback('esx_advancedweaponshop:getShotgun', function(source, cb)
	cb(shopShotgun)
end)

ESX.RegisterServerCallback('esx_advancedweaponshop:getAssault', function(source, cb)
	cb(shopAssault)
end)

ESX.RegisterServerCallback('esx_advancedweaponshop:getLMG', function(source, cb)
	cb(shopLMG)
end)

ESX.RegisterServerCallback('esx_advancedweaponshop:getSniper', function(source, cb)
	cb(shopSniper)
end)

ESX.RegisterServerCallback('esx_advancedweaponshop:getHeavy', function(source, cb)
	cb(shopHeavy)
end)

-- Buy Weapon
ESX.RegisterServerCallback('esx_advancedweaponshop:buyWeapon', function(source, cb, weaponName, zone, ammo)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPrice(weaponName, zone)
	--local ammo = getAmmo(weaponName, zone)
	local xPlayer = ESX.GetPlayerFromId(source)



	if price == 0 then
		print(('esx_advancedweaponshop: %s attempted to buy a unknown weapon!'):format(xPlayer.identifier))
		cb(false)
	else
		if ammo == 'FULL' then
			--xPlayer.showNotification("MAX AMMO", false, true, 90)
			ammo = 0
		end
		if xPlayer.hasWeapon(weaponName) then
			xPlayer.showNotification(_U('already_owned'))
			cb(false)
		else
			if zone == 'BlackShop' then
				if Config.UseDirty then
					if xPlayer.getAccount('black_money').money >= price then
						xPlayer.removeAccountMoney('black_money', price)
						xPlayer.addWeapon(weaponName, ammo)

						cb(true)
					else
						xPlayer.showNotification(_U('not_enough_black'))
						cb(false)
					end
				else
					if xPlayer.getMoney() >= price then
						xPlayer.removeMoney(price)
						xPlayer.addWeapon(weaponName, ammo)

						cb(true)
					else
						xPlayer.showNotification(_U('not_enough'))
						cb(false)
					end
				end
			else
				if xPlayer.getMoney() >= price then
					xPlayer.removeMoney(price)
					xPlayer.addWeapon(weaponName, ammo)

					cb(true)
				else
					xPlayer.showNotification(_U('not_enough'))
					cb(false)
				end
			end
		end
	end
end)

function getPrice(weaponName, zone)
	local price = MySQL.Sync.fetchScalar('SELECT price FROM weaponshops WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if price then
		return price
	else
		return 0
	end
end

function getAmmo(weaponName, zone)
	local ammo = MySQL.Sync.fetchScalar('SELECT ammo FROM weaponshops WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if ammo then
		return ammo
	else
		return 0
	end
end