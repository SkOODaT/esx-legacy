Config = {}
Config.Locale = 'en'

Config.DrawDistance	 = 10
Config.MarkerInfo = {Type = 1, r = 0, g = 128, b = 255, x = 1.5, y = 1.5, z = 0.5}

Config.UseBlips = true

Config.Items = {
	{
		label = "Pistol Ammo - <span style='color: green;'>$250</span> (100 Rounds)",
		hash = 'AMMO_PISTOL',
		amount = 100,
		price = 250
	},
	{
		label = "SMG Ammo - <span style='color: green;'>$250</span> (100 Rounds)",
		hash = 'AMMO_SMG',
		amount = 100,
		price = 250
	},
	{
		label = "Shotgun Ammo - <span style='color: green;'>$250</span> (100 Rounds)",
		hash = 'AMMO_SHOTGUN',
		amount = 100,
		price = 250
	},
	{
		label = "Rifle Ammo - <span style='color: green;'>$250</span> (100 Rounds)",
		hash = 'AMMO_RIFLE',
		amount = 100,
		price = 250
	},
	{
		label = "MG Ammo - <span style='color: green;'>$250</span> (100 Rounds)",
		hash = 'AMMO_MG',
		amount = 100,
		price = 250
	},
	{
		label = "Sniper Ammo - <span style='color: green;'>$250</span> (100 Rounds)",
		hash = 'AMMO_SNIPER',
		amount = 100,
		price = 250
	},
	--[[{
		label = "Stun Cartridge - <span style='color: green;'>$250</span> (10 Rounds)",
		hash = 'WEAPON_STUNGUN',
		amount = 10,
		price = 250
	},]]--
	{
		label = "Minigun - <span style='color: green;'>$250</span> (100)",
		hash = 'AMMO_MINIGUN',
		amount = 100,
		price = 250
	},
	{
		label = "RPG - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_RPG',
		amount = 10,
		price = 250
	},
	{
		label = "Homeing RPG - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_HOMINGLAUNCHER',
		amount = 10,
		price = 250
	},
	{
		label = "Rail Rounds - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_RAILGUN',
		amount = 10,
		price = 250
	},
	{
		label = "Grenades - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_GRENADELAUNCHER',
		amount = 10,
		price = 250
	},
	{
		label = "Fireworks - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_FIREWORK',
		amount = 10,
		price = 250
	},
	{
		label = "Flares - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_FLARE',
		amount = 10,
		price = 250
	},
	{
		label = "Flare Gun Flares - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_FLAREGUN',
		amount = 10,
		price = 250
	},
	{
		label = "Smoke Gernades - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_SMOKEGRENADE',
		amount = 10,
		price = 250
	},
	{
		label = "Sticky Bombs - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_STICKYBOMB',
		amount = 10,
		price = 250
	},
	{
		label = "Proximity Mines - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_PROXMINE',
		amount = 10,
		price = 250
	},
	{
		label = "Pipe Bombs - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_PIPEBOMB',
		amount = 10,
		price = 250
	},
	{
		label = "BZ Gas - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_BZGAS',
		amount = 10,
		price = 250
	},
	{
		label = "Balls - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_BALL',
		amount = 10,
		price = 250
	},
	{
		label = "Snow Balls - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_SNOWBALL',
		amount = 10,
		price = 250
	},
	{
		label = "Extinguisher Rounds - <span style='color: green;'>$250</span> (1000)",
		hash = 'AMMO_FIREEXTINGUISHER',
		amount = 1000,
		price = 250
	},
	{
		label = "Petrol Can - <span style='color: green;'>$250</span> (10)",
		hash = 'AMMO_PETROLCAN',
		amount = 10,
		price = 250
	},
	{
		label = "ammo_emplauncher",
		hash = 'ammo_emplauncher',
		amount = 10,
		price = 10
	}
}

Config.Zones = {
	GunShop = {
		Legal = true,
		Locations = {
			vector3(19.85, -1106.50, 28.8),
			vector3(844.84, -1029.57, 28.19),
			vector3(-664.7, -939.22, 21.83),
			vector3(812.62, -2153.63, 29.62),
			vector3(1694.55, 3755.55, 34.71),
			vector3(-329.6, 6079.57, 31.45),
			vector3(249.69, -46.52, 69.94),
			vector3(2570.34, 297.98, 108.73),
			vector3(-1117.16, 2694.18, 18.55),
			vector3(-1305.65, -391.74, 35.7),
			--vector3(-1306.2, -394.0, 35.6),
			--vector3(-3171.97, 1087.4, 19.84)
		}
	},

	BlackShop = {
		Legal = false,
		Locations = {
			--vector3(119.47, -1977.88, 19.93)
		}
	}
}