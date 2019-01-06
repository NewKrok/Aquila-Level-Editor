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
			}
		];
	}

	public static function getConfig(id:String)
	{
		for (c in config) if (c.id == id) return c;

		return null;
	}
}

typedef DecorationConfig = {
	var id:String;
	var type:DecorationType;
}

enum DecorationType {
	ANIMATION;
}