package aquila;

import haxe.Json;
import aquila.ActionList.Action;
import aquila.AnimatedVUIBox;
import aquila.BaseAction;
import aquila.EndGameAction;
import aquila.StartGameAction;
import aquila.config.AttackLineConfig;
import hpp.ui.HAlign;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ActionList extends AnimatedVUIBox
{
	var timeTooltip:TimeTooltip;
	var openActionSelector:ExpandableBaseAction->Void;
	var closeActionSelectors:Void->Void;
	var openEnemySelector:EnemyInput->Void;
	var closeEnemySelector:Void->Void;
	var attackLineSelector:AttackLineSelector;
	var gamePreview:GamePreview;

	public function new(
		openActionSelector:ExpandableBaseAction->Void,
		closeActionSelectors:Void->Void,
		openEnemySelector:EnemyInput->Void,
		closeEnemySelector:Void->Void,
		gamePreview:GamePreview,
		timeTooltip:TimeTooltip
	)
	{
		super(5, HAlign.LEFT);
		this.openActionSelector = openActionSelector;
		this.closeActionSelectors = closeActionSelectors;
		this.openEnemySelector = openEnemySelector;
		this.closeEnemySelector = closeEnemySelector;
		this.gamePreview = gamePreview;
		this.timeTooltip = timeTooltip;
		timeTooltip.visible = false;

		addEventListener(Event.ADDED_TO_STAGE, onInit);
	}

	private function onInit(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, onInit);

		stage.addChild(attackLineSelector = new AttackLineSelector());
	}

	public function addAction(actionType:ActionType, addTarget:ExpandableBaseAction = null):BaseAction
	{
		var index:UInt = addTarget == null ? actionType == ActionType.START_GAME ? 0 : actionType == ActionType.END_GAME ? numChildren : numChildren - 1 : getChildIndex(addTarget) + 1;
		var selectedAction:BaseAction = null;

		switch (actionType)
		{
			case START_GAME: selectedAction = new StartGameAction();
			case END_GAME: selectedAction = new EndGameAction();
			case WAIT: selectedAction = new WaitAction(openActionSelector, updateContainer, upRequest, downRequest, duplicateRequest, removeRequest);
			case WAITING_FOR_ALL_ENEMIES_DIE: selectedAction = new WaitingForAllEnemiesDieAction(openActionSelector, updateContainer, upRequest, downRequest, duplicateRequest, removeRequest);
			case ADD_ENEMY:
				selectedAction = new AddEnemyAction(openActionSelector, updateContainer, upRequest, downRequest, duplicateRequest, removeRequest);
				cast(selectedAction, AddEnemyAction).openEnemySelector = openEnemySelector;
				cast(selectedAction, AddEnemyAction).openAttackLineSelector = openAttackLineSelector;
			case _:
		}

		addListenersToAction(selectedAction);
		addChildAt(selectedAction, index);

		return selectedAction;
	}

	function openAttackLineSelector(target:AttackLineInput)
	{
		closeActionSelectors();
		closeEnemySelector();

		attackLineSelector.visible = true;
		attackLineSelector.target = target;
		attackLineSelector.build(aquila.config.AttackLineConfig.config);
	}

	public function modifyAction(target:ExpandableBaseAction, actionType:ActionType):Void
	{
		if (target.actionType != actionType)
		{
			addAction(actionType, target).y = target.y - target.height;
			removeRequest(target);
		}
	}

	public function setEnemy(target:AddEnemyAction, enemyType:String):Void
	{
		target.enemyType = enemyType;
	}

	private function onActionMouseOver(e:MouseEvent):Void
	{
		var target:BaseAction = cast e.currentTarget;
		var time:Float = calculateDurationByAction(target) * 1000;

		timeTooltip.updateTime(time);
		timeTooltip.visible = true;
		timeTooltip.x = target.x - timeTooltip.width - 5;
		timeTooltip.y = target.y + y + parent.y;

		if (target.actionType == ActionType.ADD_ENEMY)
		{
			var addEnemyAction:AddEnemyAction = cast target;

			gamePreview.visible = true;
			gamePreview.loadAttackLinePreview(aquila.config.AttackLineConfig.getAttackLine(addEnemyAction.attackLine));
		}
	}

	function calculateDurationByAction(target:BaseAction):Float
	{
		var duration:Float = 0;

		for (i in 0...numChildren)
		{
			var child:BaseAction = cast getChildAt(i);
			duration += child.duration;

			if (child == target) break;
		}

		return duration;
	}

	private function onActionMouseOut(e:MouseEvent):Void
	{
		timeTooltip.visible = false;
		timeTooltip.x = 0;

		gamePreview.clearPreview();
	}

	function upRequest(target:BaseAction)
	{
		var index:UInt = getChildIndex(target);

		if (index > 1)
		{
			swapChildrenAt(index, index - 1);
		}
		rePosition();
	}

	function downRequest(target:BaseAction)
	{
		var index:UInt = getChildIndex(target);

		if (index < numChildren - 2)
		{
			swapChildrenAt(index, index + 1);
		}
		rePosition();
	}

	function duplicateRequest(target:BaseAction)
	{
		var index:UInt = getChildIndex(target);
		var instance = addChildAt(target.clone(), index + 1);
		addListenersToAction(cast instance);
		instance.y = target.y;
	}

	function updateContainer()
	{
		closeActionSelectors();
		rePosition();
	}

	function removeRequest(target:BaseAction)
	{
		removeChild(target);
		target.dispose();
		target = null;

		stage.focus = this;
	}

	function addListenersToAction(action:BaseAction):Void
	{
		action.addEventListener(MouseEvent.MOUSE_OVER, onActionMouseOver);
		action.addEventListener(MouseEvent.MOUSE_OUT, onActionMouseOut);
	}

	public function getData():Array<Action>
	{
		var result:Array<Action> = [];

		for (i in 0...numChildren)
		{
			var action:BaseAction = cast getChildAt(i);
			if (action.actionType != null)
			{
				switch action.actionType
				{
					case WAIT: result.push({ type: action.actionType, data: { time: action.duration } });

					case WAITING_FOR_ALL_ENEMIES_DIE: result.push({ type: action.actionType });

					case ADD_ENEMY:
						var addEnemyAction:AddEnemyAction = cast action;
						result.push({ type: action.actionType, data: {
							count: addEnemyAction.enemyCount,
							enemyId: addEnemyAction.enemyType,
							attackLineId: addEnemyAction.attackLine,
							delay: addEnemyAction.addDelay,
						}});

					case _:
				}
			}
		}

		return result;
	}

	public function load(rawData:String)
	{
		if (rawData.charAt(rawData.length) == ",")
			rawData = rawData.substr(0, rawData.length - 1);

		var data:Array<Action> = Json.parse(rawData);

		for (action in data)
		{
			var createdAction = addAction(action.type);

			switch action.type
			{
				case WAIT:
					var actionWaitData:ActionWaitData = cast action.data;
					cast(createdAction, WaitAction).load(cast action.data);

				case ADD_ENEMY:
					var actionAddEnemyData:ActionAddEnemyData = cast action.data;
					cast(createdAction, AddEnemyAction).load(cast action.data);

				case _:
			}
		}
	}
}

enum ActionType {
	START_GAME;
	END_GAME;
	WAIT;
	ADD_ENEMY;
	WAITING_FOR_ALL_ENEMIES_DIE;
}

typedef Action = {
	var type:ActionType;
	@:optional var data:Dynamic;
}

typedef ActionAddEnemyData = {
	var count:UInt;
	var enemyId:String;
	var attackLineId:String;
	var delay:Float;
}

typedef ActionWaitData = {
	var time:Float;
}