package aquila;

import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.VUIBox;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ActionSelector extends Sprite
{
	var vUIBox:VUIBox;
	var waitButton:BaseButton;
	var waitForAllEnemiesDieButton:BaseButton;
	var addEnemyButton:BaseButton;

	public function new(onWaitAction:Void->Void, onWaitForAllEnemiesDieAction:Void->Void, onAddEnemyAction:Void->Void)
	{
		super();

		addChild(new Bitmap(Assets.getBitmapData("img/action_selector_back.png")));

		addChild(vUIBox = new VUIBox(5));
		vUIBox.x = 5;
		vUIBox.y = 10;

		vUIBox.addChild(addEnemyButton = new BaseButton(
			function(_) { onAddEnemyAction(); },
			'ADD "ADD ENEMY"',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		addEnemyButton.fontSize = 12;

		vUIBox.addChild(waitButton = new BaseButton(
			function(_) { onWaitAction(); },
			'ADD "WAIT"',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		waitButton.fontSize = 12;

		vUIBox.addChild(waitForAllEnemiesDieButton = new BaseButton(
			function(_) { onWaitForAllEnemiesDieAction(); },
			'ADD "WAITING FOR ALL ENEMIES DIE"',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		waitForAllEnemiesDieButton.fontSize = 12;
	}
}