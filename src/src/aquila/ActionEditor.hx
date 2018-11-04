package aquila;

import haxe.Json;
import aquila.ActionList.ActionType;
import aquila.ActionSelector;
import aquila.EditorMenu.Common;
import aquila.EnemySelector;
import aquila.ExtendedActionSelector;
import aquila.GamePreview;
import aquila.ui.BaseEditor;
import aquila.ui.UiElements;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.VUIBox;
import hpp.openfl.util.SpriteUtil;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ActionEditor extends BaseEditor
{
	var container:VUIBox;
	var gamePreview:GamePreview;
	var addActionButton:BaseButton;
	var saveButton:BaseButton;
	var loadButton:BaseButton;
	var playButton:BaseButton;
	var actionList:ActionList;
	var enemySelector:EnemySelector;
	var timeTooltip:TimeTooltip;
	var actionSelector:ActionSelector;
	var extendedActionSelector:ExtendedActionSelector;
	var actionListBasePosition:Float;
	var startDragPoint:Point;

	public function new(common:Common)
	{
		super();

		this.common = common;
		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		common.editorWorld.addChild(content = gamePreview = new GamePreview());
		gamePreview.visible = false;

		timeTooltip = new TimeTooltip();
		addChild(timeTooltip);

		addChild(container = new VUIBox(10));
		var saveAndLoadContainer:HUIBox = new HUIBox(2);

		saveButton = new BaseButton(
			saveHandler,
			"SAVE",
			UiElements.getSaveButtonBackground(),
			UiElements.getSaveButtonOverBackground()
		);
		saveAndLoadContainer.addChild(saveButton);

		loadButton = new BaseButton(
			loadHandler,
			"LOAD",
			UiElements.getLoadButtonBackground(),
			UiElements.getLoadButtonOverBackground()
		);
		saveAndLoadContainer.addChild(loadButton);

		container.addChild(saveAndLoadContainer);

		playButton = new BaseButton(
			simulateGameHandler,
			"PLAY",
			UiElements.getSimpleButtonBackground(),
			UiElements.getSimpleButtonOverBackground()
		);
		container.addChild(playButton);

		addActionButton = new BaseButton(
			addNewActionHandler,
			"ADD ACTION",
			UiElements.getSimpleButtonBackground(),
			UiElements.getSimpleButtonOverBackground()
		);
		container.addChild(addActionButton);

		actionList = new ActionList(openActionSelector, closeActionSelectors, openEnemySelector, closeEnemySelector, gamePreview, timeTooltip);
		actionList.addAction(ActionType.START_GAME);
		actionList.addAction(ActionType.END_GAME);
		container.addChild(actionList);

		addChild(enemySelector = new EnemySelector(onEnemySelected));
		enemySelector.visible = false;

		actionSelector = new ActionSelector(
			function() { addNewAction(ActionType.WAIT); },
			function() { addNewAction(ActionType.WAITING_FOR_ALL_ENEMIES_DIE); },
			function() { addNewAction(ActionType.ADD_ENEMY); }
		);
		addChild(actionSelector);
		actionSelector.x = container.width / 2 - actionSelector.width / 2;
		actionSelector.visible = false;

		extendedActionSelector = new ExtendedActionSelector(
			function(target:ExpandableBaseAction) { addNewAction(ActionType.WAIT, target); },
			function(target:ExpandableBaseAction) { addNewAction(ActionType.WAITING_FOR_ALL_ENEMIES_DIE, target); },
			function(target:ExpandableBaseAction) { addNewAction(ActionType.ADD_ENEMY, target); },
			function(target:ExpandableBaseAction) { modifyNewActionTo(target, ActionType.WAIT); },
			function(target:ExpandableBaseAction) { modifyNewActionTo(target, ActionType.WAITING_FOR_ALL_ENEMIES_DIE); },
			function(target:ExpandableBaseAction) { modifyNewActionTo(target, ActionType.ADD_ENEMY); }
		);
		addChild(extendedActionSelector);
		extendedActionSelector.x = container.width / 2 - extendedActionSelector.width / 2;
		extendedActionSelector.visible = false;

		var mask:Sprite = new Sprite();
		mask.graphics.beginFill(0);
		mask.graphics.drawRect(actionList.x, actionList.y, container.width, stage.stageHeight - actionList.y);
		mask.graphics.endFill();
		addChild(mask);
		mask.y = actionList.parent.y;
		actionList.mask = mask;

		startDragPoint = new Point();
		actionListBasePosition = actionList.y;
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onmMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onmMouseMove);

		common.updateMenuView();
	}

	function saveHandler(_)
	{
		stage.addChild(new SaveWindow(closeSaveWindow, Json.stringify(actionList.getData())));
	}

	function closeSaveWindow(target:SaveWindow)
	{
		stage.removeChild(target);
		target = null;
	}

	function loadHandler(_)
	{
		stage.addChild(new LoadWindow(closeLoadWindow, load));
	}

	function load(rawData:String, target:LoadWindow)
	{
		actionList.load(rawData);

		closeLoadWindow(target);
	}

	function closeLoadWindow(target:LoadWindow)
	{
		stage.removeChild(target);
		target = null;
	}

	function simulateGameHandler(target:BaseButton)
	{
		gamePreview.play(target, actionList.getData());
	}

	function addNewActionHandler(_)
	{
		actionSelector.visible = !actionSelector.visible;
		extendedActionSelector.visible = false;
		actionSelector.y = addActionButton.y + addActionButton.height;
	}

	function addNewAction(actionType:ActionType, target:ExpandableBaseAction = null)
	{
		closeActionSelectors();

		actionList.addAction(actionType, target);
		actionList.rePosition();
	}

	function modifyNewActionTo(target:ExpandableBaseAction, actionType:ActionType)
	{
		closeActionSelectors();

		actionList.modifyAction(target, actionType);
		actionList.rePosition();
	}

	function openActionSelector(target:ExpandableBaseAction)
	{
		if (common.isClickBlocked) return;

		closeEnemySelector();

		extendedActionSelector.target = target;
		extendedActionSelector.visible = !extendedActionSelector.visible;
		actionSelector.visible = false;
		extendedActionSelector.y = container.y + SpriteUtil.getContextPosition(this, target).y + target.height;
	}

	function closeActionSelectors()
	{
		actionSelector.visible = false;
		extendedActionSelector.visible = false;
		enemySelector.visible = false;
	}

	function onEnemySelected()
	{
		closeEnemySelector();
	}

	function openEnemySelector(target:EnemyInput)
	{
		if (common.isClickBlocked) return;

		actionSelector.visible = false;
		extendedActionSelector.visible = false;

		enemySelector.target = target;
		enemySelector.visible = !enemySelector.visible;
		enemySelector.x = target.x + target.parent.x + target.parent.parent.x + target.width / 2 - enemySelector.width / 2;
		enemySelector.y = container.y + SpriteUtil.getContextPosition(this, target).y + target.height;
	}

	function closeEnemySelector()
	{
		enemySelector.visible = false;
	}

	function onMouseDown(e:MouseEvent):Void
	{
		actionList.startDrag(false, new Rectangle(0, actionListBasePosition - actionList.height + 50, 0, actionList.height - 50));
		startDragPoint.setTo(actionList.x, actionList.y);
		common.isClickBlocked = false;
	}

	function onmMouseUp(e:MouseEvent):Void
	{
		actionList.stopDrag();
	}

	function onmMouseMove(e:MouseEvent):Void
	{
		if (!common.isClickBlocked && Math.sqrt(Math.pow(startDragPoint.x - actionList.x, 2) + Math.pow(startDragPoint.y - actionList.y, 2)) > 10)
		{
			closeActionSelectors();
			common.isClickBlocked = true;
		}
	}

	public function close():Void
	{
		closeActionSelectors();
		closeEnemySelector();
	}
}