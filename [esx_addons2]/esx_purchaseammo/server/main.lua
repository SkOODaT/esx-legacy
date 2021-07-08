ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local item_prices = {}
for k, v in pairs(Config.Items) do
	item_prices[v.item] = v.price
end

RegisterServerEvent("esx_purchaseammo:Buy", item)
AddEventHandler("esx_purchaseammo:Buy", function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	--if xPlayer.hasWeapon(item) then -- Checks to ensure the player has that item
	xPlayer.addWeaponAmmo(item, 100)
	xPlayer.removeMoney(item_prices[item])
	xPlayer.showNotification("~g~[SUCCESS]~w~ You purchased ammo!", false, true, 90) -- Shows notification
	--else
	--	xPlayer.showNotification("~r~[ERROR]~w~ You do not have that weapon", false, true, 90) -- Shows notification
	--end
end)
