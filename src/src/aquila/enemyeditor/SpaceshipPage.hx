package aquila.enemyeditor;

import hpp.openfl.ui.HUIBox;
import openfl.display.Sprite;
import aquila.config.SpaceshipConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipPage extends HUIBox
{
	var spaceshipPreview:SpaceshipPreview;
	var spaceshipDetails:SpaceshipDetails;

	public function new()
	{
		super(10);

		build();
	}

	function build()
	{
		addChild(spaceshipPreview = new SpaceshipPreview());
		addChild(spaceshipDetails = new SpaceshipDetails(function(c) {
			onChange(c);
			spaceshipPreview.load(c);
		}));
	}

	public function load(c:SpaceshipConfig):Void
	{
		spaceshipPreview.load(c);
		spaceshipDetails.load(c);
	}

	dynamic public function onChange(c:SpaceshipConfig) {};
}