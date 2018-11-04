package aquila.enemyeditor;

import aquila.EditorMenu;
import haxe.Json;
import aquila.EditorMenu.Common;
import aquila.enemyeditor.SpaceshipList;
import aquila.ui.BaseEditor;
import aquila.ui.UiElements;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.VUIBox;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import aquila.config.SpaceshipConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EnemyEditor extends BaseEditor
{
	var container:VUIBox;
	var enemyPage:SpaceshipPage;

	var saveButton:BaseButton;
	var addEnemyButton:BaseButton;

	var enemyList:SpaceshipList;
	var attackLineListBasePosition:Float;
	var startDragPoint:Point;

	public function new(appData:Common)
	{
		super();

		this.common = appData;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		common.editorWorld.addChild(content = enemyPage = new SpaceshipPage());
		content.visible = false;
		content.x = 1136 / 2 - content.width / 2;
		content.y = 640 / 2 - content.height / 2;

		addChild(container = new VUIBox(10));

		saveButton = new BaseButton(
			saveHandler,
			"SAVE",
			UiElements.getSaveButtonBackground(),
			UiElements.getSaveButtonOverBackground()
		);
		container.addChild(saveButton);

		addEnemyButton = new BaseButton(
			function (_) { addNewAttackLineHandler(); },
			"ADD ENEMY",
			UiElements.getSimpleButtonBackground(),
			UiElements.getSimpleButtonOverBackground()
		);
		container.addChild(addEnemyButton);

		enemyList = new SpaceshipList(common, cast content);
		container.addChild(enemyList);

		var mask:Sprite = new Sprite();
		mask.graphics.beginFill(0);
		mask.graphics.drawRect(0, enemyList.y, container.width, stage.stageHeight - enemyList.y);
		mask.graphics.endFill();
		addChild(mask);
		mask.y = enemyList.parent.y;
		enemyList.mask = mask;

		startDragPoint = new Point();
		attackLineListBasePosition = enemyList.y;
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onmMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onmMouseMove);
		enemyPage.onChange = enemyList.onChange;
	}

	function onMouseDown(e:MouseEvent):Void
	{
		enemyList.startDrag(false, new Rectangle(0, attackLineListBasePosition - enemyList.height + 25, 0, enemyList.height - 25));
		startDragPoint.setTo(enemyList.x, enemyList.y);
		common.isClickBlocked = false;
	}

	function onmMouseUp(e:MouseEvent):Void
	{
		enemyList.stopDrag();
	}

	function onmMouseMove(e:MouseEvent):Void
	{
		if (!common.isClickBlocked && Math.sqrt(Math.pow(startDragPoint.x - enemyList.x, 2) + Math.pow(startDragPoint.y - enemyList.y, 2)) > 10)
		{
			common.isClickBlocked = true;
		}
	}

	function addNewAttackLineHandler()
	{
		enemyList.addSpaceshipEntry();
		enemyList.rePosition();
		container.rePosition();
	}

	function saveHandler(_)
	{
		var data:Array<SpaceshipConfig> = [];

		for (enemy in enemyList.entries) data.push(enemy.config);

		trace(Json.stringify(data));
	}
}