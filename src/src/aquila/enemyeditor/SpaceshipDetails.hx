package aquila.enemyeditor;

import aquila.config.TileConfigs;
import aquila.ui.NumberProperty;
import aquila.ui.StaticProperty;
import aquila.ui.StringProperty;
import aquila.ui.TileProperty;
import hpp.openfl.ui.VUIBox;
import openfl.display.Sprite;
import aquila.config.SpaceshipConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipDetails extends Sprite
{
	var config:SpaceshipConfig;

	var idProp:StaticProperty;
	var nameProp:StringProperty;
	var tileProp:TileProperty;
	var hitAreaRadiusProp:NumberProperty;
	var lifeProp:NumberProperty;
	var speedProp:NumberProperty;
	var dodgeProp:NumberProperty;
	var fireRateProp:NumberProperty;
	var bulletTileProp:TileProperty;
	var bulletSpeedProp:NumberProperty;
	var bulletDamageProp:NumberProperty;
	var bulletLifeProp:NumberProperty;
	var missileFireRateProp:NumberProperty;
	var missileTileProp:TileProperty;
	var missileSpeedProp:NumberProperty;
	var missileRotationSpeedProp:NumberProperty;
	var missileDamageProp:NumberProperty;
	var missileReducedDamageProp:NumberProperty;
	var missileDamageAreaProp:NumberProperty;
	var missileLifeProp:NumberProperty;

	public function new(onChange:SpaceshipConfig->Void)
	{
		super();

		graphics.beginFill(0x111111);
		graphics.drawRect(0, 0, 700, 620);
		graphics.endFill();

		var propertyContainer:VUIBox = new VUIBox(2);

		propertyContainer.addChild(idProp = new StaticProperty("ID"));

		propertyContainer.addChild(nameProp = new StringProperty("NAME", 30));
		nameProp.onValueChanged = function(v) {
			config.name = v;
			onChange(config);
		};

		propertyContainer.addChild(tileProp = new TileProperty("TILE", aquila.config.TileConfigs.spaceShipsTileConfig));
		tileProp.onValueChanged = function(v) {
			config.tile = v;
			onChange(config);
		};

		propertyContainer.addChild(hitAreaRadiusProp = new NumberProperty("HIT AREA RADIUS", true, 5, 200));
		hitAreaRadiusProp.onValueChanged = function(v) {
			config.hitAreaRadius = v;
			onChange(config);
		};

		propertyContainer.addChild(lifeProp = new NumberProperty("MAX LIFE", false, 1, 99999999));
		lifeProp.onValueChanged = function(v) {
			config.maxLife = v;
			onChange(config);
		};

		propertyContainer.addChild(speedProp = new NumberProperty("SPEED (sec/1000px)", true, 1, 100));
		speedProp.onValueChanged = function(v) {
			config.speed = v;
			onChange(config);
		};

		propertyContainer.addChild(dodgeProp = new NumberProperty("CHANCE TO DODGE (%)", true, 0, 100));
		dodgeProp.onValueChanged = function(v) {
			config.chanceToDodge = v;
			onChange(config);
		};

		propertyContainer.addChild(fireRateProp = new NumberProperty("FIRE RATE (ms)", true, 0, 99999999));
		fireRateProp.onValueChanged = function(v) {
			config.fireRate = v;
			onChange(config);
		};

		propertyContainer.addChild(bulletTileProp = new TileProperty("BULLET TILE", aquila.config.TileConfigs.bulletTileConfig));
		bulletTileProp.onValueChanged = function(v) {
			config.bulletConfig.graphicId = v;
			onChange(config);
		};

		propertyContainer.addChild(bulletSpeedProp = new NumberProperty("BULLET SPEED", true, 0, 999999));
		bulletSpeedProp.onValueChanged = function(v) {
			config.bulletConfig.speed = v;
			onChange(config);
		};

		propertyContainer.addChild(bulletDamageProp = new NumberProperty("BULLET DAMAGE", true, 0, 999999));
		bulletDamageProp.onValueChanged = function(v) {
			config.bulletConfig.damage = v;
			onChange(config);
		};

		propertyContainer.addChild(bulletLifeProp = new NumberProperty("BULLET LIFE (hit)", false, 1, 999999));
		bulletLifeProp.onValueChanged = function(v) {
			config.bulletConfig.maxLife = v;
			onChange(config);
		};

		propertyContainer.addChild(missileFireRateProp = new NumberProperty("MISSILE FIRE RATE (ms)", true, 0, 99999999));
		missileFireRateProp.onValueChanged = function(v) {
			config.missileFireRate = v;
			onChange(config);
		};

		propertyContainer.addChild(missileTileProp = new TileProperty("MISSILE TILE", aquila.config.TileConfigs.missileTileConfig));
		missileTileProp.onValueChanged = function(v) {
			config.missileConfig.graphicId = v;
			onChange(config);
		};

		propertyContainer.addChild(missileSpeedProp = new NumberProperty("MISSILE SPEED", true, 0, 999999));
		missileSpeedProp.onValueChanged = function(v) {
			config.missileConfig.speed = v;
			onChange(config);
		};

		propertyContainer.addChild(missileRotationSpeedProp = new NumberProperty("MISSILE ROT SPEED (DEG)", true, 0, 360));
		missileRotationSpeedProp.onValueChanged = function(v) {
			config.missileConfig.rotationSpeed = v * (Math.PI / 180);
			onChange(config);
		};

		propertyContainer.addChild(missileDamageProp = new NumberProperty("MISSILE MAX DAMAGE", true, 0, 999999));
		missileDamageProp.onValueChanged = function(v) {
			config.missileConfig.maxDamage = v;
			onChange(config);
		};

		propertyContainer.addChild(missileReducedDamageProp = new NumberProperty("MISSILE AREA DAMAGE", true, 0, 999999));
		missileReducedDamageProp.onValueChanged = function(v) {
			config.missileConfig.reducedDamage = v;
			onChange(config);
		};

		propertyContainer.addChild(missileDamageAreaProp = new NumberProperty("MISSILE AREA DAMAGE AREA", true, 0, 999999));
		missileDamageAreaProp.onValueChanged = function(v) {
			config.missileConfig.areaToReducedDamage = v;
			onChange(config);
		};

		propertyContainer.addChild(missileLifeProp = new NumberProperty("MISSILE LIFE (hit)", false, 1, 999999));
		missileLifeProp.onValueChanged = function(v) {
			config.missileConfig.maxLife = v;
			onChange(config);
		};

		addChild(propertyContainer);
	}

	public function load(config:SpaceshipConfig):Void
	{
		this.config = config;

		idProp.value = config.id;
		nameProp.value = config.name;
		tileProp.value = config.tile;
		hitAreaRadiusProp.value = config.hitAreaRadius;
		lifeProp.value = config.maxLife;
		speedProp.value = config.speed;
		dodgeProp.value = config.chanceToDodge;
		fireRateProp.value = config.fireRate;
		bulletTileProp.value = config.bulletConfig.graphicId;
		bulletSpeedProp.value = config.bulletConfig.speed;
		bulletDamageProp.value = config.bulletConfig.damage;
		bulletLifeProp.value = config.bulletConfig.maxLife;
		missileFireRateProp.value = config.missileFireRate;
		missileTileProp.value = config.missileConfig.graphicId;
		missileSpeedProp.value = config.missileConfig.speed;
		missileRotationSpeedProp.value = Math.round(config.missileConfig.rotationSpeed * (180 / Math.PI));
		missileDamageProp.value = config.missileConfig.maxDamage;
		missileReducedDamageProp.value = config.missileConfig.reducedDamage;
		missileDamageAreaProp.value = config.missileConfig.areaToReducedDamage;
		missileLifeProp.value = config.missileConfig.maxLife;
	}
}