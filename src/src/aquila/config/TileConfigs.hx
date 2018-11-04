package aquila.config;

/**
 * ...
 * @author Krisztian Somoracz
 */
class TileConfigs
{
	public static var TILE_SCALE:Float = 1;

	public static var spaceShipsTileConfig(default, null):Array<TileConfig>;
	public static var bulletTileConfig(default, null):Array<TileConfig>;
	public static var missileTileConfig(default, null):Array<TileConfig>;

	public static function init()
	{
		spaceShipsTileConfig = [
			{
				editorUrl: "img/gamecontent/spaceship/spaceship_a.png",
				gameUrl: "img/gamecontent/spaceship/spaceship_a",
			},
			{
				editorUrl: "img/gamecontent/spaceship/enemy_a.png",
				gameUrl: "img/gamecontent/spaceship/enemy_a",
			},
			{
				editorUrl: "img/gamecontent/spaceship/enemy_b.png",
				gameUrl: "img/gamecontent/spaceship/enemy_b",
			},
			{
				editorUrl: "img/gamecontent/spaceship/enemy_c.png",
				gameUrl: "img/gamecontent/spaceship/enemy_c",
			}
		];

		bulletTileConfig = [
			{
				editorUrl: "img/gamecontent/bullet/bullet_a.png",
				gameUrl: "img/gamecontent/bullet/bullet_a",
			},
			{
				editorUrl: "img/gamecontent/bullet/bullet_b.png",
				gameUrl: "img/gamecontent/bullet/bullet_b",
			}
		];

		missileTileConfig = [
			{
				editorUrl: "img/gamecontent/missle/missle_a.png",
				gameUrl: "img/gamecontent/missle/missle_a",
			},
			{
				editorUrl: "img/gamecontent/missle/missle_b.png",
				gameUrl: "img/gamecontent/missle/missle_b",
			},
			{
				editorUrl: "img/gamecontent/missle/missle_c.png",
				gameUrl: "img/gamecontent/missle/missle_c",
			}
		];
	}
}

typedef TileConfig = {
	var editorUrl:String;
	var gameUrl:String;
}