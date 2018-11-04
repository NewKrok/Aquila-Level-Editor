package aquila;

import aquila.ActionList.ActionType;
import aquila.ActionList.ActionWaitData;
import hpp.openfl.ui.HUIBox;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WaitAction extends ExpandableBaseAction
{
	static inline var DEFAULT_TIME:Float = 1;

	var subContent:HUIBox;
	var numberInput:NumberInput;

	override function constructed()
	{
		duration = DEFAULT_TIME;
	}

	override function build()
	{
		actionType = ActionType.WAIT;

		subContent = new HUIBox(10);
		var textFormat:TextFormat = new TextFormat("Verdana", 12, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.LEFT);

		var textA = new TextField();
		textA.defaultTextFormat = textFormat;
		textA.autoSize = "left";
		textA.text = "WAIT";
		subContent.addChild(textA);

		subContent.addChild(numberInput = new NumberInput(onWaitTimeChange, duration, true));

		var textB = new TextField();
		textB.defaultTextFormat = textFormat;
		textB.autoSize = "left";
		textB.text = "SEC";
		subContent.addChild(textB);

		actionSubContent.addChild(subContent);

		update();
	}

	function onWaitTimeChange()
	{
		duration = numberInput.value;
	}

	public function updateDuration():Void
	{
		if (numberInput != null) numberInput.setValue(duration);
	}

	public function load(data:ActionWaitData)
	{
		duration = data.time;
		updateDuration();
	}

	override function update()
	{
		label.text = "WAIT (" + duration + ")";

		super.update();
	}

	override public function clone():WaitAction
	{
		var clone:WaitAction = new WaitAction(openActionSelector, updateContainer, upRequest, downRequest, duplicateRequest, removeRequest);
		clone.duration = duration;
		clone.updateDuration();

		return clone;
	}
}