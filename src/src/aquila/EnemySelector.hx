package aquila;

import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.UIGrid;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import aquila.config.SpaceshipConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EnemySelector extends Sprite
{
	public var target:EnemyInput;

	var grid:UIGrid;

	public function new(onEnemySelected:Void->Void)
	{
		super();

		var config:Array<SpaceshipConfig> = aquila.config.SpaceshipConfigs.config;

		addChild(new Bitmap(Assets.getBitmapData("img/enemy_selector_back.png")));

		addChild(grid = new UIGrid(5, 5));
		grid.x = 5;
		grid.y = 11;

		for (i in 0...10)
		{
			var enemy:SpaceshipConfig = i < config.length ? config[i] : null;

			var enemyButton:BaseButton = new BaseButton(
				function(_) {
					onEnemySelected();
					target.setValue(enemy != null ? enemy.id : "UNKNOWN");
				},
				"",
				new Bitmap(Assets.getBitmapData("img/enemy_back.png")),
				new Bitmap(Assets.getBitmapData("img/enemy_back_over.png"))
			);
			if (enemy != null)
			{
				var icon:Bitmap = new Bitmap(Assets.getBitmapData(config[i].tile));
				enemyButton.addChild(icon);
				icon.x = enemyButton.width / 2 - icon.width / 2;
				icon.y = enemyButton.height / 2 - icon.height / 2;
			}
			grid.addChild(enemyButton);
		}
	}
}