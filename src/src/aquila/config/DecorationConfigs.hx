package aquila.config;

import hpp.util.GeomUtil.SimplePoint;

/**
 * ...
 * @author Krisztian Somoracz
 */
class DecorationConfigs
{
	public static var config(default, null):Array<DecorationConfig>;

	public static function init()
	{
		config = [
			{
				id: "fire_a",
				type: ANIMATION,
				tile: "img/gamecontent/effects/fire_a.png",
				frames: [0, 1, 2, 3, 4],
				cols: 1,
				rows: 5,
				width: 34,
				height: 24,
				fps: 10
			},
			{
				id: "pulse_a",
				type: ANIMATION,
				tile: "img/gamecontent/effects/pulse_a.png",
				frames: [0, 1, 2, 3, 4, 5],
				cols: 6,
				rows: 1,
				width: 30,
				height: 30,
				fps: 10
			}
		];
	}
}

typedef DecorationConfig = {
	var id:String;
	var type:DecorationType;
	var tile:String;
	var frames:Array<UInt>;
	var cols:UInt;
	var rows:UInt;
	var width:UInt;
	var height:UInt;
	var fps:UInt;
}

enum DecorationType {
	ANIMATION;
}