local SkOODaTDebug = false
local SkOODaTDebug2 = false

function CreateExtendedPlayer(playerId, identifier, group, accounts, inventory, weight, job, loadout, ammotypes, name, coords)
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
	if Config.Multichar then self.license = 'license'..string.sub(identifier, 6) else self.license = 'license:'..identifier end

	ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))

	self.triggerEvent = function(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

	self.setCoords = function(coords)
		self.updateCoords(coords)
		self.triggerEvent('esx:teleport', coords)
	end

	self.updateCoords = function(coords)
		self.coords = {x = ESX.Math.Round(coords.x, 1), y = ESX.Math.Round(coords.y, 1), z = ESX.Math.Round(coords.z, 1), heading = ESX.Math.Round(coords.heading or 0.0, 1)}
	end

	self.getCoords = function(vector)
		if vector then
			return vector3(self.coords.x, self.coords.y, self.coords.z)
		else
			return self.coords
		end
	end

	self.kick = function(reason)
		DropPlayer(self.source, reason)
	end

	self.setMoney = function(money)
		money = ESX.Math.Round(money)
		self.setAccountMoney('money', money)
	end

	self.getMoney = function()
		return self.getAccount('money').money
	end

	self.addMoney = function(money)
		money = ESX.Math.Round(money)
		self.addAccountMoney('money', money)
	end

	self.removeMoney = function(money)
		money = ESX.Math.Round(money)
		self.removeAccountMoney('money', money)
	end

	self.getIdentifier = function()
		return self.identifier
	end

	self.setGroup = function(newGroup)
		ExecuteCommand(('remove_principal identifier.%s group.%s'):format(self.license, self.group))
		self.group = newGroup
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))
	end

	self.getGroup = function()
		return self.group
	end

	self.set = function(k, v)
		self.variables[k] = v
	end

	self.get = function(k)
		return self.variables[k]
	end

	self.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.getAccount = function(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

	self.getInventory = function(minimal)
		if minimal then
			local minimalInventory = {}

			for k,v in ipairs(self.inventory) do
				if v.count > 0 then
					minimalInventory[v.name] = v.count
				end
			end

			return minimalInventory
		else
			return self.inventory
		end
	end

	self.getJob = function()
		return self.job
	end

	self.getLoadout = function(minimal)
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
							table.insert(components, component)
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

	self.getAmmotype = function(minimal)
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

	self.getName = function()
		return self.name
	end

	self.setName = function(newName)
		self.name = newName
	end

	self.setAccountMoney = function(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.getInventoryItem = function(name)
		for k,v in ipairs(self.inventory) do
			if v.name == name then
				return v
			end
		end

		return
	end

	self.addInventoryItem = function(name, count)
		local item = self.getInventoryItem(name)

		if item then
			count = ESX.Math.Round(count)
			item.count = item.count + count
			self.weight = self.weight + (item.weight * count)

			TriggerEvent('esx:onAddInventoryItem', self.source, item.name, item.count)
			self.triggerEvent('esx:addInventoryItem', item.name, item.count)
		end
	end

	self.removeInventoryItem = function(name, count)
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

	self.setInventoryItem = function(name, count)
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

	self.getWeight = function()
		return self.weight
	end

	self.getMaxWeight = function()
		return self.maxWeight
	end

	self.canCarryItem = function(name, count)
		local currentWeight, itemWeight = self.weight, ESX.Items[name].weight
		local newWeight = currentWeight + (itemWeight * count)

		return newWeight <= self.maxWeight
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		local firstItemObject = self.getInventoryItem(firstItem)
		local testItemObject = self.getInventoryItem(testItem)

		if firstItemObject.count >= firstItemCount then
			local weightWithoutFirstItem = ESX.Math.Round(self.weight - (firstItemObject.weight * firstItemCount))
			local weightWithTestItem = ESX.Math.Round(weightWithoutFirstItem + (testItemObject.weight * testItemCount))

			return weightWithTestItem <= self.maxWeight
		end

		return false
	end

	self.setMaxWeight = function(newWeight)
		self.maxWeight = newWeight
		self.triggerEvent('esx:setMaxWeight', self.maxWeight)
	end

	self.setJob = function(job, grade)
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

	self.addWeapon = function(weapon, ammoCount)
		if not self.hasWeapon(weapon) then

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

			self.triggerEvent('esx:addWeapon', weapon, ammoCount)
			self.triggerEvent('esx:addInventoryItem', weaponLabel, false, true)
		end
	end

	self.addWeaponComponent = function(weaponName, weaponComponent)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			local component = ESX.GetWeaponComponent(weaponName, weaponComponent)

			if component then
				if not self.hasWeaponComponent(weaponName, weaponComponent) then
					table.insert(self.loadout[loadoutNum].components, weaponComponent)
					self.triggerEvent('esx:addWeaponComponent', weaponName, weaponComponent)
					self.triggerEvent('esx:addInventoryItem', component.label, false, true)
				end
			end
		end
	end

	self.addWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo + ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end

		--local ammoHash = ESX.GetWeaponAmmoType(weaponName)
		--local ammoNum, ammotype = self.getAmmo(tostring(ammoHash))

		--if ammotype then
		--	ammotype.ammo = ammotype.ammo + ammoCount
		--	self.triggerEvent('esx:setAmmo', tonumber(ammotype.name), ammotype.ammo)
		--end
	end

	self.addAmmoWeapon = function(weaponName, ammoCount)
		local ammoHash = ESX.GetWeaponAmmoType(weaponName)
		local ammoNum, ammotype = self.getAmmo(ammoHash)

		if ammotype then
			ammotype.ammo = ammotype.ammo + ammoCount
			self.triggerEvent('esx:setAmmo', ammotype.name, ammotype.ammo)
		end
	end

	self.addAmmoType = function(ammotypename, ammoCount)
		local ammoNum, ammotype = self.getAmmo(ammotypename)

		if ammotype then
			ammotype.ammo = ammotype.ammo + ammoCount
			self.triggerEvent('esx:setAmmo', ammotype.name, ammotype.ammo)
		end
	end

	self.updateWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			if ammoCount < weapon.ammo then
				weapon.ammo = ammoCount
			end
		end
	end

	self.updateAmmo = function(ammoType, ammoCount, ammoMax)
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

	self.setWeaponTint = function(weaponName, weaponTintIndex)
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

	self.getWeaponTint = function(weaponName)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			return weapon.tintIndex
		end

		return 0
	end

	self.removeWeapon = function(weaponName)
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

	self.removeWeaponComponent = function(weaponName, weaponComponent)
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

	self.removeWeaponAmmo = function(weaponName, ammoCount)
		local loadoutNum, weapon = self.getWeapon(weaponName)

		if weapon then
			weapon.ammo = weapon.ammo - ammoCount
			self.triggerEvent('esx:setWeaponAmmo', weaponName, weapon.ammo)
		end
	end

	self.removeAmmo = function(ammotypename, ammoCount)
		local ammoNum, ammotype = self.getAmmo(ammotypename)

		if ammotype then
			ammotype.ammo = ammotype.ammo + ammoCount
			self.triggerEvent('esx:setAmmo', ammotype.name, ammotype.ammo)
		end
	end

	self.hasWeaponComponent = function(weaponName, weaponComponent)
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

	self.hasWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return true
			end
		end

		return false
	end

	self.getWeapon = function(weaponName)
		for k,v in ipairs(self.loadout) do
			if v.name == weaponName then
				return k, v
			end
		end

		return
	end

	self.getAmmo = function(ammoName)
		for k,v in ipairs(self.ammotypes) do
			if v.name == ammoName then
				return k, v
			end
		end

		return
	end

	self.showNotification = function(msg)
		self.triggerEvent('esx:showNotification', msg)
	end

	self.showHelpNotification = function(msg, thisFrame, beep, duration)
		self.triggerEvent('esx:showHelpNotification', msg, thisFrame, beep, duration)
	end

	return self
end
