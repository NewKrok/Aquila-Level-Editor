package aquila;

import com.greensock.TweenMax;
import aquila.enemyeditor.EnemyEditor;
import aquila.ui.EditorTabs;
import aquila.ui.UiElements;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.LinkedButton;
import hpp.openfl.ui.PlaceHolder;
import hpp.openfl.ui.VUIBox;
import hpp.ui.HAlign;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EditorMenu extends Sprite
{
	var container:VUIBox;
	var actionEditor:ActionEditor;
	var attackLineEditor:AttackLineEditor;
	var enemyEditor:EnemyEditor;

	var common:Common;

	public function new(editorWorld:EditorWorld)
	{
		super();

		common = {
			isClickBlocked: false,
			updateMenuView: updateMenuView,
			editorWorld: editorWorld
		};

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		container = new VUIBox(10, HAlign.LEFT);
		container.addChild(new PlaceHolder(10, 0));
		container.addChild(new Bitmap(Assets.getBitmapData("img/logo.png")));

		actionEditor = new ActionEditor(common);
		attackLineEditor = new AttackLineEditor(common);
		enemyEditor = new EnemyEditor(common);

		container.addChild(new EditorTabs([
			{ instance: actionEditor, iconUrl: "img/action_tab_icon.png", isSelected: true },
			{ instance: attackLineEditor, iconUrl: "img/attack_line_tab_icon.png" },
			{ instance: enemyEditor, iconUrl: "img/enemy_tab_icon.png" }
		]));

		container.addChild(actionEditor);
		container.addChild(attackLineEditor);
		container.addChild(enemyEditor);
		addChild(container);

		graphics.beginFill(0x333333);
		graphics.drawRect(0, 0, container.width, stage.stageHeight);
		graphics.endFill();
	}

	function updateMenuView()
	{
		container.rePosition();
	}
}

typedef Common = {
	var isClickBlocked:Bool;
	var updateMenuView:Void->Void;
	var editorWorld:EditorWorld;
}