package aquila;

import aquila.EditorMenu;
import aquila.config.AnimationConfig.AnimationConfigs;
import aquila.config.AttackLineConfig;
import aquila.config.DecorationConfigs;
import aquila.config.SpaceshipConfigs;
import aquila.config.TileConfigs;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.PlaceHolder;
import hpp.openfl.ui.VUIBox;
import hpp.ui.HAlign;
import hpp.ui.VAlign;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;

/**
 * ...
 * @author Krisztian Somoracz
 */
class Main extends Sprite
{
	public function new()
	{
		super();
		stage.scaleMode = StageScaleMode.SHOW_ALL;
		stage.color = 0x222222;

		AnimationConfigs.init();
		DecorationConfigs.init();
		TileConfigs.init();
		SpaceshipConfigs.init();
		AttackLineConfig.init();

		var mainBox:HUIBox = new HUIBox(0, VAlign.TOP);

		var vUIBox:VUIBox = new VUIBox(0, HAlign.CENTER);
		vUIBox.addChild(new PlaceHolder(10, 100));

		var hUIBox:HUIBox = new HUIBox(0, VAlign.TOP);
		hUIBox.addChild(new PlaceHolder(100, 10));
		var editorWorld:EditorWorld = new EditorWorld();
		hUIBox.addChild(editorWorld);
		hUIBox.addChild(new PlaceHolder(100, 10));
		vUIBox.addChild(hUIBox);

		vUIBox.addChild(new PlaceHolder(10, 100));
		mainBox.addChild(vUIBox);
		mainBox.addChild(new EditorMenu(editorWorld));
		addChild(mainBox);
	}
}