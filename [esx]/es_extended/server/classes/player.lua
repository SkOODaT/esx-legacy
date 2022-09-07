local SkOODaTDebug = false
local SkOODaTDebug2 = true

function CreateExtendedPlayer(playerId, identifier, group, accounts, inventory, weight, job, loadout, ammotypes, name, coords)
	local targetOverrides = Config.PlayerFunctionOverride and Core.PlayerFunctionOverrides[Config.PlayerFunctionOverride] or {}
	local self = {}

	self.accounts = accounts
	self.coords = coords
	self.group = group
	self.identifier = identifier
	self.inventory = inventory
	self.job = job
	self.loadout = loadout
	self.ammotypes = ammotypes
	self.name = name
	self.playerId = playerId
	self.source = playerId
	self.variables = {}
	self.weight = weight
	self.maxWeight = Config.MaxWeight
	if Config.Multichar then self.license = 'license'.. identifier:sub(identifier:find(':'), identifier:len()) else self.license = 'license:'..identifier end

	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))

	function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	function self.setCoords(coords)
		self.updateCoords(coords)
		local Ped = GetPlayerPed(self.source)
		local vector = type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0) or
		vec(coords.x, coords.y, coords.z, coords.heading or 0.0)
		SetEntityCoords(Ped, vector.xyz, false, false, false, false)
		SetEntityHeading(Ped, vector.w)
	end

	function self.updateCoords()
		local Ped = GetPlayerPed(self.source)
		local coords = GetEntityCoords(Ped)
		self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading or 0.0, 1)}
	end

	function self.getCoords(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	function self.kick(reason)
		DropPlayer(self.source, reason)
	end

	function self.setMoney(money)
		money = ESX.Math.Round(money)
		self.setAccountMoney('money', money)
	end

	function self.getMoney()
		return self.getAccount('money').money
	end

	function self.addMoney(money)
		money = ESX.Math.Round(money)
		self.addAccountMoney('money', money)
	end

	function self.removeMoney(money)
		money = ESX.Math.Round(money)
		self.removeAccountMoney('money', money)
	end

	function self.getIdentifier()
		return self.identifier
	end

	function self.setGroup(newGroup)
		ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.license, self.group))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))
	end

	function self.getGroup()
		return self.group
	end

	function self.set(k, v)
		self.variables[k] = v
	end

	function self.get(k)
		return self.variables[k]
	end

	function self.getAccounts(minimal)
		if minimal then
			local minimalAccounts = {}

			for i=1, #self.accounts do
				minimalAccounts[self.accounts[i].name] = self.accounts[i].money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	function self.getAccount(account)
		for i=1, #self.accounts do
			if self.accounts[i].name == account then
				return self.accounts[i], i
			end
		end
	end

	function self.getInventory(minimal)
		if minimal then
			local minimalInventory = {}

			for k, v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		end

		return self.inventory
	end

	function self.getJob()
		return self.job
	end

	function self.getLoadout(minimal)
		if minimal then
			local minimalLoadout = {}

			for k,v in ipairs(self.loadout) do
				minimalLoadout[v.name] = {ammo = v.ammo}
				if SkOODaTDebug then
					print("Saved Loadout: ", v.name, v.ammo)
				end
				if v.tintIndex > 0 then minimalLoadout[v.name].tintIndex = v.tintIndex end

				if #v.components > 0 then
					local components = {}

					for k2,component in ipairs(v.components) do
						if component ~= 'clip_default' then
							components[#components + 1] = component
						end
					end

					if #components > 0 then
						minimalLoadout[v.name].components = components
					end
				end
			end

			return minimalLoadout
		else
			return self.loadout
		end
	end

	function self.getAmmotype(minimal)
		if minimal then
			local minimalAmmotype = {}

			for k,v in ipairs(self.ammotypes) do
				minimalAmmotype[v.name] = {ammo = v.ammo}
				if SkOODaTDebug2 then
					print("Saved AmmoType: ", v.name, v.ammo)
				end
			end

			return minimalAmmotype
		else
			return self.ammotypes
		end
	end

	function self.getName()
		return self.name
	end

	function self.setName(newName)
		self.name = newName
	end

	function self.setAccountMoney(accountName, money)
		if not tonumber(money) then 
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
			return
		end
		if money >= 0 then
			local account, index = self.getAccount(accountName)

			if account then
				money = account.round and ESX.Math.Round(money) or money
				self.accounts[index].money = money

				self.triggerEvent('esx:setAccountMoney', account)
			else 
				print(('[^1ERROR^7] Tried To Set Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
			end
		else 
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
		end
	end

	function self.addAccountMoney(accountName, money)
		if not tonumber(money) then 
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
			return
		end
		if money > 0 then
			local account, index = self.getAccount(accountName)
			if account then
				money = account.round and ESX.Math.Round(money) or money
				self.accounts[index].money = money

				self.triggerEvent('esx:setAccountMoney', account)
			else 
				print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
			end
		else 
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
		end
	end

	function self.removeAccountMoney(accountName, money)
		if not tonumber(money) then 
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
			return
		end
		if money > 0 then
			local account, index = self.getAccount(accountName)

			if account then
				money = account.round and ESX.Math.Round(money) or money
				self.accounts[index].money = money

				self.triggerEvent('esx:setAccountMoney', account)
			else 
				print(('[^1ERROR^7] Tried To Set Add To Invalid Account ^5%s^0 For Player ^5%s^0!'):format(accountName, self.playerId))
			end
		else 
			print(('[^1ERROR^7] Tried To Set Account ^5%s^0 For Player ^5%s^0 To An Invalid Number!'):format(accountName, self.playerId))
		end
	end

	function self.getInventoryItem(name, metadata)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end
	end

	function self.addInventoryItem(name, count, metadata, slot)
		local item = self.getInventoryItem(name)

		if item then
			count = ESX.Math.Round(count)
			item.count = item.count + count
			self.weight = self.weight + (item.weight * count)

			TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
			self.triggerEvent('esx:addInventoryItem', item.name, item.count)
		end
	end

	function self.removeInventoryItem(name, count, metadata, slot)
		local item = self.getInventoryItem(name)

		if item then
			count = ESX.Math.Round(count)
			local newCount = item.count - count

			if newCount >= 0 then
				item.count = newCount
				self.weight = self.weight - (item.weight * count)

				TriggerEvent('esx:onRemoveInventoryItem', self.source, item.name, item.count)
				self.triggerEvent('esx:removeInventoryItem', item.name, item.count)
			end
		end
	end

	function self.setInventoryItem(name, count, metadata)
		local item = self.getInventoryItem(name)

		if item and count >= 0 then
			count = ESX.Math.Round(count)

			if count > item.count then
				self.addInventoryItem(item.name, count - item.count)
			else
				self.removeInventoryItem(item.name, item.count - count)
			end
		end
	end

	function self.getWeight()
		return self.weight
	end

	function self.getMaxWeight()
		return self.maxWeight
	end

	function self.canCarryItem(name, count, metadata)
		local currentWeight, itemWeight = self.weight, ESX.Items[name].weight
		local newWeight = currentWeight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	function self.canSwapItem(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	function self.setMaxWeight(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('esx:setMaxWeight', self.maxWeight)
	end

	function self.setJob(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if ESX.DoesJobExist(job, grade) then
			local jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('esx:setJob', self.source, self.job, lastJob)
			self.triggerEvent('esx:setJob', self.job)
		else
			print(('[es_extended] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.identifier))
		end
	end

	function self.addWeapon(weapon, ammoCount)
		if not self.hasWeapon(weaponName) then
			local weaponLabel = ESX.GetWeaponLabel(weapon)
			local loadoutNum, weaponName = self.getWeapon(weapon)
			local lWeaponName = nil if weaponName then lWeaponName = weaponName.name end

			if SkOODaTDebug then
				print("@@@@@@@@@@@@@@@@@@")
				print(playerId, weapon, ammoCount)
				print("Weapon Table Count:", #self.loadout)
			end
			for k1,v1 in ipairs(self.loadout) do
				if v1.name == weapon then
					if SkOODaTDebug then
						print("UPDATE WEAPON: ", k1, v.name)
					end
					v1.ammo = v1.ammo + ammoCount
					self.loadout[v1.name] = {ammo = v1.ammo, components = {}, tintIndex = 0}
				end
			end
			if SkOODaTDebug then
				print("@@@@@@@@@@@@@@@@@@")
				print(weapon, lWeaponName)
				print("@@@@@@@@@@@@@@@@@@")
			end
			if weapon ~= lWeaponName then
				if SkOODaTDebug then
					print("NEW WEAPON: ", #self.loadout+1, weapon)
				end
				self.loadout[#self.loadout+1] = {name = weapon, ammo = ammoCount, components = {}, tintIndex = 0}
			end

			--[[table.insert(self.loadout, {
				name = weapon,
				--ammotype = ammotype,
				ammo = ammoCount,
				label = weaponLabel,
				components = {},
				tintIndex = 0
			})]]--
 
 			local ammotype = ESX.GetWeaponAmmoType(weapon)
			local ammoNum, ammoTypeName = self.getAmmo(ammotype)
			local lAmmoName = nil if ammoTypeName then lAmmoName = ammoTypeName.name end

			if SkOODaTDebug2 then
				print("------------------")
				print(playerId, weapon, ammoCount)
				print("Ammmo Table Count:", #self.ammotypes)
			end
			for k2,v2 in ipairs(self.ammotypes) do
				if v2.name == ammotype then
					if SkOODaTDebug2 then
						print("UPDATE AMMO: ", k2, v2.name)
					end
					v2.ammo = v2.ammo + ammoCount
					self.ammotypes[v2.name] = {ammo = v2.ammo}
				end
			end
			if SkOODaTDebug2 then
				print("------------------")
				print(ammotype, lAmmoName)
				print("------------------")
			end
			if ammotype ~= lAmmoName then
				if SkOODaTDebug2 then
					print("NEW AMMO: ", #self.ammotypes+1, ammotype)
				end
				self.ammotypes[#self.ammotypes+1] = {name = ammotype, ammo = ammoCount}
			end

			--self.triggerEvent('esx:addWeapon', weapon, ammoCount)
			GiveWeaponToPed(GetPlayerPed(self.source), joaat(weapon), ammoCount, false, false)

			self.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
		end
	end

	function self.addWeaponComponent(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					self.loadout[loadoutNum].components[#self.loadout[loadoutNum].components + 1] = weaponComponent
					local componentHash = ESX.GetWeaponComponent(weapon, weaponComponent).hash
					GiveWeaponComponentToPed(GetPlayerPed(self.source), joaat(weapon), componentHash)
					self.triggerEvent('esx:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	function self.addWeaponAmmo(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			SetPedAmmo(GetPlayerPed(self.source), joaat(weaponName), weapon.ammo)
		end

		--local ammoHash = ESX.GetWeaponAmmoType(weaponName)
		--local ammoNum, ammotype = self.getAmmo(tostring(ammoHash))

		--if ammotype then
		--	ammotype.ammo = ammotype.ammo + ammoCount
		--	self.triggerEvent('esx:setAmmo', tonumber(ammotype.name), ammotype.ammo)
		--end
	end

	function self.addAmmoWeapon(weaponName, ammoCount)
		local ammoHash = ESX.GetWeaponAmmoType(weaponName)
		local ammoNum, ammotype = self.getAmmo(ammoHash)

		if ammotype then
			ammotype.ammo = ammotype.ammo + ammoCount
			self.triggerEvent('esx:setAmmo', ammotype.name, ammotype.ammo)
		end
	end

	function self.addAmmoType(ammotypename, ammoCount)
		local ammoNum, ammotype = self.getAmmo(ammotypename)

		if ammotype then
			ammotype.ammo = ammotype.ammo + ammoCount
			self.triggerEvent('esx:setAmmo', ammotype.name, ammotype.ammo)
		end
	end

	function self.updateWeaponAmmo(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			if ammoCount < weapon.ammo then
				weapon.ammo = ammoCount
			end
		end
	end

	function self.updateAmmo(ammoType, ammoCount, ammoMax)
		local ammoNum, ammotype = self.getAmmo(ammoType)

		if ammotype then
			if ammoCount < ammotype.ammo then
				--if ammoCount <= ammoMax then
				ammotype.ammo = ammoCount
				--else
					--ammotype.ammo = ammoMax
				--end
			end
		end
	end

	function self.setWeaponTint(weaponName, weaponTintIndex)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local weaponNum, weaponObject = ESX.GetWeapon(weaponName)

			if weaponObject.tints and weaponObject.tints[weaponTintIndex] then
				self.loadout[loadoutNum].tintIndex = weaponTintIndex
				self.triggerEvent('esx:setWeaponTint', weaponName, weaponTintIndex)
				self.triggerEvent('esx:addInventoryItem', weaponObject.tints[weaponTintIndex], false, true)
			end
		end
	end

	function self.getWeaponTint(weaponName)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	function self.removeWeapon(weaponName)
		local weaponLabel

		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				weaponLabel = v.label

				for k2,v2 in ipairs(v.components) do
					self.removeWeaponComponent(weaponName, v2)
				end

				table.remove(self.loadout, k)
				break
			end
		end

		if weaponLabel then
			self.triggerEvent('esx:removeWeapon', weaponName)
			self.triggerEvent('esx:removeInventoryItem', weaponLabel, false, true)
		end
	end

	function self.removeWeaponComponent(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if self.hasWeaponComponent(weaponName, weaponComponent) then
					for k,v in ipairs(self.loadout[loadoutNum].components) do
						if v == weaponComponent then
							table.remove(self.loadout[loadoutNum].components, k)
							break
						end
					end

					self.triggerEvent('esx:removeWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:removeInventoryItem', component.label, false, true)
				end
			end
		end
	end

	function self.removeWeaponAmmo(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	function self.removeAmmo(ammotypename, ammoCount)
		local ammoNum, ammotype = self.getAmmo(ammotypename)

		if ammotype then
			ammotype.ammo = ammotype.ammo + ammoCount
			self.triggerEvent('esx:setAmmo', ammotype.name, ammotype.ammo)
		end
	end

	function self.hasWeaponComponent(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			for k,v in ipairs(weapon.components) do
				if v == weaponComponent then
					return true
				end
			end

			return false
		else
			return false
		end
	end

	function self.hasWeapon(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	function self.hasItem(item, metadata)
		for k,v in ipairs(self.inventory) do
			if (v.name == item) and (v.count >= 1) then
				return v, v.count
			end
		end

		return false
	end

	function self.getWeapon(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end
	end

	function self.getAmmo(ammoName)
		for k,v in ipairs(self.ammotypes) do
			if v.name == ammoName then
				return k, v
			end
		end

		return
	end

	function self.showNotification(msg)
		self.triggerEvent('esx:showNotification', msg)
	end

	function self.showHelpNotification(msg, thisFrame, beep, duration)
		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	for fnName,fn in pairs(targetOverrides) do
		self[fnName] = fn(self)
	end

	return self
end
