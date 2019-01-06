package aquila.config;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AnimationConfigs
{
	public static var config(default, null):Array<AnimationConfig>;

	public static function init()
	{
		config = [
			{
				id: "bullet_a",
				tile: "img/gamecontent/bullet/bullet_a.png",
				frames: [0, 1],
				cols: 2,
				rows: 1,
				width: 15,
				height: 8,
				fps: 10
			},
			{
				id: "bullet_b",
				tile: "img/gamecontent/bullet/bullet_b.png",
				frames: [0, 1],
				cols: 2,
				rows: 1,
				width: 15,
				height: 8,
				fps: 10
			},
			{
				id: "fire_a",
				tile: "img/gamecontent/effects/fire_a.png",
				frames: [0, 1, 2, 3, 4],
				cols: 1,
				rows: 5,
				width: 34,
				height: 24,
				fps: 10
			},
			{
				id: "missle_a",
				tile: "img/gamecontent/missle/missle_a.png",
				frames: [0, 1, 2, 3, 4],
				cols: 1,
				rows: 5,
				width: 34,
				height: 24,
				fps: 10
			}
		];
	}

	public static function getConfig(id:String)
	{
		for (c in config) if (c.id == id) return c;

		return null;
	}
}

typedef AnimationConfig = {
	var id:String;
	var tile:String;
	var frames:Array<UInt>;
	var cols:UInt;
	var rows:UInt;
	var width:UInt;
	var height:UInt;
	var fps:UInt;
}