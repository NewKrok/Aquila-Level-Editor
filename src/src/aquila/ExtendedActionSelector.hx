package aquila;

import aquila.ExpandableBaseAction;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.VUIBox;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ExtendedActionSelector extends Sprite
{
	public var target:ExpandableBaseAction;

	var vUIBox:VUIBox;
	var waitButton:BaseButton;
	var waitForAllEnemiesDieButton:BaseButton;
	var addEnemyButton:BaseButton;

	public function new(onAddWaitAction:ExpandableBaseAction->Void, onAddWaitForAllEnemiesDieAction:ExpandableBaseAction->Void, onAddAddEnemyAction:ExpandableBaseAction->Void,
						onModifyToWaitAction:ExpandableBaseAction->Void, onModifyToWaitForAllEnemiesDieAction:ExpandableBaseAction->Void, onModifyToAddEnemyAction:ExpandableBaseAction->Void
	)
	{
		super();

		addChild(new Bitmap(Assets.getBitmapData("img/action_selector_extended_back.png")));

		addChild(vUIBox = new VUIBox(5));
		vUIBox.x = 5;
		vUIBox.y = 11;

		vUIBox.addChild(addEnemyButton = new BaseButton(
			function(_) { onAddAddEnemyAction(target); },
			'ADD TO "ADD ENEMY"',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		addEnemyButton.fontSize = 12;

		vUIBox.addChild(waitButton = new BaseButton(
			function(_) { onAddWaitAction(target); },
			'ADD TO "WAIT"',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		waitButton.fontSize = 12;

		vUIBox.addChild(waitForAllEnemiesDieButton = new BaseButton(
			function(_) { onAddWaitForAllEnemiesDieAction(target); },
			'ADD "WAITING FOR ALL ENEMIES DIE"',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		waitForAllEnemiesDieButton.fontSize = 12;

		vUIBox.addChild(addEnemyButton = new BaseButton(
			function(_) { onModifyToAddEnemyAction(target); },
			'MODIFY TO "ADD ENEMY"',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		addEnemyButton.fontSize = 12;

		vUIBox.addChild(waitButton = new BaseButton(
			function(_) { onModifyToWaitAction(target); },
			'MODIFY TO "WAIT"',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		waitButton.fontSize = 12;

		vUIBox.addChild(waitForAllEnemiesDieButton = new BaseButton(
			function(_) { onModifyToWaitForAllEnemiesDieAction(target); },
			'MODIFY "TO WAITING FOR ALL..."',
			new Bitmap(Assets.getBitmapData("img/action_selector_button.png")),
			new Bitmap(Assets.getBitmapData("img/action_selector_button_over.png"))
		));
		waitForAllEnemiesDieButton.fontSize = 12;
	}
}