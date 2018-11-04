package aquila.config;

import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipConfigs
{
	public static var config(default, null):Array<SpaceshipConfig>;

	public static function init()
	{
		config = [{"id":"1535737624855", "name":"Player", "isBoss":false, "tile":"img/gamecontent/spaceship/spaceship_a.png", "destroyRange":0, "hitAreaRadius":30, "maxLife":1, "speed":10, "fireRate":1000, "missileFireRate":1000, "chanceToDodge":0, "bulletConfig":{"firePoints":[{"x":0, "y":0}], "tile":"img/gamecontent/bullet/bullet_a.png", "speed":4, "damage":10, "maxLife":0}, "missileConfig":{"firePoints":[{"x":0, "y":0}], "tile":"img/gamecontent/missle/missle_a.png", "speed":10, "rotationSpeed":0, "maxDamage":0, "reducedDamage":0, "areaToReducedDamage":0, "maxLife":0}}, {"id":"1535737625655", "name":"Enemy1", "isBoss":false, "tile":"img/gamecontent/spaceship/enemy_a.png", "destroyRange":0, "hitAreaRadius":30, "maxLife":1, "speed":10, "fireRate":1000, "missileFireRate":1000, "chanceToDodge":0, "bulletConfig":{"firePoints":[{"x":0, "y":0}], "tile":"img/gamecontent/bullet/bullet_b.png", "speed":2, "damage":10, "maxLife":1}, "missileConfig":{"firePoints":[{"x":0, "y":0}], "tile":"img/gamecontent/missle/missle_a.png", "speed":10, "rotationSpeed":0, "maxDamage":0, "reducedDamage":0, "areaToReducedDamage":0, "maxLife":0}}];
	}

	public static function getSpaceshipConfig(id:String):SpaceshipConfig
	{
		for (entry in config)
		{
			if (entry.id == id)
			{
				return entry;
			}
		}

		return null;
	}

	public static function getEmpty():SpaceshipConfig
	{
		return {
			id: "",
			name: "unnamed",
			isBoss: false,
			tile: TileConfigs.spaceShipsTileConfig[0].editorUrl,
			destroyRange: 0,
			hitAreaRadius: 30,
			maxLife: 1,
			speed: 10,
			fireRate: 1000,
			missileFireRate: 1000,
			chanceToDodge: 0,
			bulletConfig: {
				firePoints: [{ x: 0, y: 0 }],
				tile: TileConfigs.bulletTileConfig[0].editorUrl,
				speed: 10,
				damage: 0,
				maxLife: 0
			},
			missileConfig: {
				firePoints: [{ x: 0, y: 0 }],
				tile: TileConfigs.missileTileConfig[0].editorUrl,
				speed: 10,
				rotationSpeed: 0,
				maxDamage: 0,
				reducedDamage: 0,
				areaToReducedDamage: 0,
				maxLife: 0,
			}
		};
	}

	public static function clone(target:SpaceshipConfig):SpaceshipConfig
	{
		var o:SpaceshipConfig = {
			id: target.id,
			name: target.name,
			isBoss: target.isBoss,
			tile: target.tile,
			destroyRange: target.destroyRange,
			hitAreaRadius: target.hitAreaRadius,
			maxLife: target.maxLife,
			speed: target.speed,
			fireRate: target.fireRate,
			missileFireRate: target.missileFireRate,
			chanceToDodge: target.chanceToDodge,
			bulletConfig: {
				firePoints: [],
				tile: target.bulletConfig.tile,
				speed: target.bulletConfig.speed,
				damage: target.bulletConfig.damage,
				maxLife: target.bulletConfig.maxLife
			},
			missileConfig: {
				firePoints: [],
				tile: target.missileConfig.tile,
				speed: target.missileConfig.speed,
				rotationSpeed: target.missileConfig.rotationSpeed,
				maxDamage: target.missileConfig.maxDamage,
				reducedDamage: target.missileConfig.reducedDamage,
				areaToReducedDamage: target.missileConfig.areaToReducedDamage,
				maxLife: target.missileConfig.maxLife
			}
		};

		for (p in target.bulletConfig.firePoints) o.bulletConfig.firePoints.push({ x: p.x, y: p.y });
		for (p in target.missileConfig.firePoints) o.missileConfig.firePoints.push({ x: p.x, y: p.y });

		return o;
	}
}

typedef SpaceshipConfig = {
	var id:String;
	var name:String;
	var isBoss:Bool;
	var tile:String; // WARNING different in the game
	var destroyRange:Float;
	var hitAreaRadius:UInt;
	var maxLife:Float;
	var speed:Float;
	var chanceToDodge:Float;
	var missileFireRate:Float;
	var fireRate:Float;
	var bulletConfig:BulletConfig;
	var missileConfig:MissileConfig;
	@:optional var fireModeConfig:FireModeConfig;
}

typedef FireModeConfig = {
	var fireMode:FireMode;
	@:optional var fireModeStartTime:Float;
	@:optional var fireModeDuration:Float;
}

enum FireMode {
	NORMAL;
	DOUBLE;
	TRIPLE;
	CROSS;
	BACKWARD;
}

typedef BulletConfig = {
	var tile:String;  // WARNING different in the game
	var speed:Float;
	var damage:Float;
	var firePoints:Array<SimplePoint>;
	var maxLife:Float;
	@:optional var criticalHitChance:Float;
	@:optional var criticalHitMultiplier:Float;
	@:optional var chanceToSplit:Float;
}

typedef MissileConfig = {
	var tile:String; // WARNING different in the game
	var speed:Float;
	var maxDamage:Float;
	var rotationSpeed:Float;
	var reducedDamage:Float;
	var areaToReducedDamage:Float;
	var maxLife:Float;
	var firePoints:Array<SimplePoint>;
}