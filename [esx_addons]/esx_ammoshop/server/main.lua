ESX.RegisterServerCallback('esx_purchaseammo:Buy', function(source, cb, price, amount, name, ammoname)
	local xPlayer = ESX.GetPlayerFromId(source)
	if amount == 'FULL' then
		xPlayer.showNotification(_U('AMMO_MAX')..name, false, true, 90)
	else
		xPlayer.addAmmoType(ammoname, amount)
		xPlayer.removeMoney(price)
		xPlayer.showNotification(_U('shop_buy').." "..amount.."X "..name.." rounds", false, true, 90)
	end
end)
