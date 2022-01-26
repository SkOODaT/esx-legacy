ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_purchaseammo:Buy", hash, price, amount)
AddEventHandler("esx_purchaseammo:Buy", function(hash, price, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	if amount == 'FULL' then
		xPlayer.showNotification(_U('AMMO_MAX').._U(hash), false, true, 90)
	else
		xPlayer.addAmmoType(hash, amount)
		xPlayer.removeMoney(price)
		xPlayer.showNotification(_U('shop_buy').." "..amount.."X ".._U(hash), false, true, 90)
	end
end)
