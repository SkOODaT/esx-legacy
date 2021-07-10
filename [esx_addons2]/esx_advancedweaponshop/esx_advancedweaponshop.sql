USE `es_extended`;

CREATE TABLE `weaponshops` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`zone` varchar(255) NOT NULL,
	`item` varchar(255) NOT NULL,
	`ammo` int(11) NOT NULL,
	`price` int(11) NOT NULL,
	`category` varchar(60) NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `licenses` (`type`, `label`) VALUES
	('weapon_melee', "Melee License"),
	('weapon_handgun', "Handgun License"),
	('weapon_smg', "SMG License"),
	('weapon_shotgun', "Shotgun License"),
	('weapon_assault', "Assault Rifle License"),
	('weapon_lmg', "LMG License"),
	('weapon_sniper', "Sniper Rifle License")
	('weapon_heavy', "Heavy Weapon License")
;

INSERT INTO `weaponshops` (`id`, `zone`, `item`, `ammo`, `price`, `category`) VALUES
	(1, 'GunShop', 'GADGET_PARACHUTE', 0, 800, 'melee'),
	(2, 'GunShop', 'WEAPON_FLASHLIGHT', 0, 25, 'melee'),
	(3, 'GunShop', 'WEAPON_MACHETE', 0, 20, 'melee'),
	(4, 'GunShop', 'WEAPON_BAT', 0, 20, 'melee'),
	(5, 'GunShop', 'WEAPON_NIGHTSTICK', 0, 15, 'melee'),
	(6, 'GunShop', 'WEAPON_KNIFE', 0, 30, 'melee'),
	(7, 'GunShop', 'WEAPON_HAMMER', 0, 5, 'melee'),
	(8, 'GunShop', 'WEAPON_GOLFCLUB', 0, 40, 'melee'),
	(9, 'GunShop', 'WEAPON_CROWBAR', 0, 15, 'melee'),
	(10, 'GunShop', 'WEAPON_DAGGER', 0, 15, 'melee'),
	(11, 'GunShop', 'WEAPON_KNUCKLE', 0, 25, 'melee'),
	(12, 'GunShop', 'WEAPON_HATCHET', 0, 20, 'melee'),
	(13, 'GunShop', 'WEAPON_SWITCHBLADE', 0, 25, 'melee'),
	(14, 'GunShop', 'WEAPON_POOLCUE', 0, 10, 'melee'),
	(15, 'GunShop', 'WEAPON_WRENCH', 0, 40, 'melee'),
	(16, 'GunShop', 'WEAPON_BOTTLE', 0, 10, 'melee'),
	(17, 'GunShop', 'WEAPON_BATTLEAXE', 0, 125, 'melee'),
	(18, 'GunShop', 'WEAPON_FIREEXTINGUISHER', 10, 100, 'melee'),
	(19, 'GunShop', 'WEAPON_BALL', 10, 25, 'melee'),
	(20, 'GunShop', 'WEAPON_SNOWBALL', 10, 25, 'melee'),
	(21, 'GunShop', 'WEAPON_BZGAS', 10, 250, 'melee'),
	(22, 'BlackShop', 'WEAPON_BZGAS', 10, 500, 'melee'),
	(23, 'GunShop', 'WEAPON_SMOKEGRENADE', 10, 250, 'melee'),
	(24, 'BlackShop', 'WEAPON_SMOKEGRENADE', 10, 500, 'melee'),
	(25, 'BlackShop', 'WEAPON_MOLOTOV', 10, 150, 'melee'),
	(26, 'GunShop', 'WEAPON_FLARE', 10, 100, 'melee'),
	(27, 'GunShop', 'WEAPON_FLAREGUN', 10, 500, 'handgun'),
	(28, 'GunShop', 'WEAPON_STUNGUN', 10, 500, 'handgun'),
	(29, 'GunShop', 'WEAPON_SNSPISTOL', 100, 150, 'handgun'),
	(30, 'BlackShop', 'WEAPON_SNSPISTOL', 100, 450, 'handgun'),
	(31, 'GunShop', 'WEAPON_VINTAGEPISTOL', 100, 300, 'handgun'),
	(32, 'BlackShop', 'WEAPON_VINTAGEPISTOL', 100, 900, 'handgun'),
	(33, 'GunShop', 'WEAPON_PISTOL', 100, 350, 'handgun'),
	(34, 'BlackShop', 'WEAPON_PISTOL', 100, 1050, 'handgun'),
	(35, 'GunShop', 'WEAPON_COMBATPISTOL', 100, 400, 'handgun'),
	(36, 'GunShop', 'WEAPON_PISTOL50', 100, 1500, 'handgun'),
	(37, 'GunShop', 'WEAPON_HEAVYPISTOL', 100, 550, 'handgun'),
	(38, 'GunShop', 'WEAPON_REVOLVER', 100, 1300, 'handgun'),
	(39, 'GunShop', 'WEAPON_APPISTOL', 100, 2700, 'handgun'),
	(40, 'GunShop', 'WEAPON_MICROSMG', 100, 900, 'smg'),
	(41, 'BlackShop', 'WEAPON_MICROSMG', 100, 2700, 'smg'),
	(42, 'GunShop', 'WEAPON_MINISMG', 100, 800, 'smg'),
	(43, 'BlackShop', 'WEAPON_MINISMG', 100, 2400, 'smg'),
	(44, 'GunShop', 'WEAPON_SMG', 100, 1600, 'smg'),
	(45, 'BlackShop', 'WEAPON_SMG', 100, 4800, 'smg'),
	(46, 'GunShop', 'WEAPON_MACHINEPISTOL', 100, 1300, 'smg'),
	(47, 'GunShop', 'WEAPON_ASSAULTSMG', 100, 1400, 'smg'),
	(48, 'GunShop', 'WEAPON_COMBATPDW', 100, 1500, 'smg'),
	(49, 'GunShop', 'WEAPON_PUMPSHOTGUN', 100, 350, 'shotgun'),
	(50, 'BlackShop', 'WEAPON_PUMPSHOTGUN', 100, 1050, 'shotgun'),
	(51, 'GunShop', 'WEAPON_SAWNOFFSHOTGUN', 100, 500, 'shotgun'),
	(52, 'BlackShop', 'WEAPON_SAWNOFFSHOTGUN', 100, 1500, 'shotgun'),
	(53, 'GunShop', 'WEAPON_DBSHOTGUN', 100, 450, 'shotgun'),
	(54, 'BlackShop', 'WEAPON_DBSHOTGUN', 100, 1350, 'shotgun'),
	(55, 'GunShop', 'WEAPON_HEAVYSHOTGUN', 100, 1000, 'shotgun'),
	(56, 'GunShop', 'WEAPON_ASSAULTSHOTGUN', 100, 1100, 'shotgun'),
	(57, 'GunShop', 'WEAPON_MUSKET', 100, 225, 'assault'),
	(58, 'GunShop', 'WEAPON_ASSAULTRIFLE', 100, 1200, 'assault'),
	(59, 'BlackShop', 'WEAPON_ASSAULTRIFLE', 100, 3600, 'assault'),
	(60, 'GunShop', 'WEAPON_CARBINERIFLE', 100, 2400, 'assault'),
	(61, 'BlackShop', 'WEAPON_CARBINERIFLE', 100, 7200, 'assault'),
	(62, 'GunShop', 'WEAPON_BULLPUPRIFLE', 100, 1200, 'assault'),
	(63, 'GunShop', 'WEAPON_SPECIALCARBINE', 100, 5200, 'assault'),
	(64, 'GunShop', 'WEAPON_COMPACTRIFLE', 100, 750, 'assault'),
	(65, 'GunShop', 'WEAPON_ADVANCEDRIFLE', 100, 2000, 'assault'),
	(66, 'GunShop', 'WEAPON_GUSENBERG', 100, 4280, 'lmg'),
	(67, 'GunShop', 'WEAPON_MG', 100, 8250, 'lmg'),
	(68, 'GunShop', 'WEAPON_COMBATMG', 100, 13950, 'lmg'),
	(69, 'GunShop', 'WEAPON_SNIPERRIFLE', 100, 2000, 'sniper'),
	(70, 'GunShop', 'WEAPON_MARKSMANRIFLE', 100, 3800, 'sniper'),
	(71, 'GunShop', 'WEAPON_HEAVYSNIPER', 100, 9900, 'sniper')
;
