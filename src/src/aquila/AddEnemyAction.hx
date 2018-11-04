package aquila;

import aquila.ActionList.ActionAddEnemyData;
import aquila.ActionList.ActionType;
import aquila.config.AttackLineConfig;
import aquila.config.SpaceshipConfigs;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.UIFlow;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AddEnemyAction extends ExpandableBaseAction
{
	public var openEnemySelector:EnemyInput->Void;
	public var openAttackLineSelector:AttackLineInput->Void;

	public var enemyCount(default, set):UInt;
	public var enemyType(default, set):String;
	public var attackLine(default, set):String;
	public var addDelay(default, set):Float;

	var subContent:UIFlow;
	var countInput:NumberInput;
	var enemyInput:EnemyInput;
	var attackLineInput:AttackLineInput;
	var delayInput:NumberInput;

	override function build()
	{
		actionType = ActionType.ADD_ENEMY;

		subContent = new UIFlow(width - 20, 10, 5);
		var textFormat:TextFormat = new TextFormat("Verdana", 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);

		var textA = new TextField();
		textA.defaultTextFormat = textFormat;
		textA.autoSize = "left";
		textA.text = "ADD";
		subContent.addChild(textA);

		subContent.addChild(countInput = new NumberInput(onEnemyCountUpdate, 5, false));
		subContent.addChild(enemyInput = new EnemyInput(onEnemyTypeUpdate, aquila.config.SpaceshipConfigs.config[0].id));
		enemyInput.addEventListener(MouseEvent.CLICK, function(_) { openEnemySelector(enemyInput); });

		var textB = new TextField();
		textB.defaultTextFormat = textFormat;
		textB.autoSize = "left";
		textB.text = "TO ATTACK LINE";
		subContent.addChild(textB);

		subContent.addChild(attackLineInput = new AttackLineInput(onAttackLineUpdate, aquila.config.AttackLineConfig.config[0].id));
		attackLineInput.addEventListener(MouseEvent.CLICK, function(_) { openAttackLineSelector(attackLineInput); });

		var textC = new TextField();
		textC.defaultTextFormat = textFormat;
		textC.autoSize = "left";
		textC.text = "WITH";
		subContent.addChild(textC);

		subContent.addChild(delayInput = new NumberInput(onDelayUpdate, .5, true));

		var textD = new TextField();
		textD.defaultTextFormat = textFormat;
		textD.autoSize = "left";
		textD.text = "SEC DELAYS";
		subContent.addChild(textD);

		actionSubContent.addChild(subContent);

		if (addDelay == null)
		{
			addDelay = delayInput.value;
			attackLine = attackLineInput.value;
			enemyType = enemyInput.value;
			enemyCount = cast countInput.value;
		}
		else
		{
			delayInput.setValue(addDelay);
			attackLineInput.setValue(attackLine);
			enemyInput.setValue(enemyType);
			countInput.setValue(enemyCount);
		}

		update();
	}

	public function updateDuration():Void
	{
		if (countInput != null) countInput.setValue(duration);
	}

	function onEnemyCountUpdate()
	{
		enemyCount = cast countInput.value;
		update();
	}

	function onEnemyTypeUpdate()
	{
		enemyType = enemyInput.value;
		update();
	}

	function onAttackLineUpdate()
	{
		attackLine = attackLineInput.value;
		update();
	}

	function onDelayUpdate()
	{
		addDelay = delayInput.value;
		update();
	}

	override function update()
	{
		if (label != null && countInput != null)
		{
			label.text = "ADD (" + countInput.value + "x " + enemyInput.value + ", delay: " + delayInput.value + ", total: " + (Math.floor(countInput.value * delayInput.value * 100) / 100) + ")";

			super.update();
		}
	}

	function set_enemyCount(value:UInt):UInt
	{
		enemyCount = value;
		update();

		return value;
	}

	function set_enemyType(value:String):String
	{
		enemyType = value;
		update();

		return value;
	}

	function set_attackLine(value:String):String
	{
		attackLine = value;
		update();

		return value;
	}

	function set_addDelay(value:Float):Float
	{
		addDelay = value;
		update();

		return value;
	}

	public function load(data:ActionAddEnemyData)
	{
		countInput.setValue(data.count);
		enemyCount = data.count;

		enemyInput.setValue(data.enemyId);
		enemyType = data.enemyId;

		attackLineInput.setValue(data.attackLineId);
		attackLine = data.attackLineId;

		delayInput.setValue(data.delay);
		addDelay = data.delay;
	}

	override public function clone():AddEnemyAction
	{
		var clone:AddEnemyAction = new AddEnemyAction(openActionSelector, updateContainer, upRequest, downRequest, duplicateRequest, removeRequest);

		clone.enemyCount = enemyCount;
		clone.enemyType = enemyType;
		clone.attackLine = attackLine;
		clone.addDelay = addDelay;
		clone.openEnemySelector = openEnemySelector;
		clone.openAttackLineSelector = openAttackLineSelector;

		return clone;
	}
}