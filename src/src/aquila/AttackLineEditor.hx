package aquila;

import aquila.EditorMenu.Common;
import aquila.ui.BaseEditor;
import aquila.ui.UiElements;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.VUIBox;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AttackLineEditor extends BaseEditor
{
	var container:VUIBox;

	var saveButton:BaseButton;
	var addAttackLineButton:BaseButton;

	var attackLineList:AttackLineList;
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
		common.editorWorld.addChild(content = new AttackLinePreview());
		content.visible = false;

		addChild(container = new VUIBox(10));

		saveButton = new BaseButton(
			saveHandler,
			"SAVE",
			UiElements.getSaveButtonBackground(),
			UiElements.getSaveButtonOverBackground()
		);
		container.addChild(saveButton);

		addAttackLineButton = new BaseButton(
			function (_) { addNewAttackLineHandler(); },
			"ADD ATTACK LINE",
			UiElements.getSimpleButtonBackground(),
			UiElements.getSimpleButtonOverBackground()
		);
		container.addChild(addAttackLineButton);

		attackLineList = new AttackLineList(common, cast content);
		container.addChild(attackLineList);

		var mask:Sprite = new Sprite();
		mask.graphics.beginFill(0);
		mask.graphics.drawRect(0, attackLineList.y, container.width, stage.stageHeight - attackLineList.y);
		mask.graphics.endFill();
		addChild(mask);
		mask.y = attackLineList.parent.y;
		attackLineList.mask = mask;

		startDragPoint = new Point();
		attackLineListBasePosition = attackLineList.y;
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		stage.addEventListener(MouseEvent.MOUSE_UP, onmMouseUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onmMouseMove);
	}

	function onMouseDown(e:MouseEvent):Void
	{
		attackLineList.startDrag(false, new Rectangle(0, attackLineListBasePosition - attackLineList.height + 25, 0, attackLineList.height - 25));
		startDragPoint.setTo(attackLineList.x, attackLineList.y);
		common.isClickBlocked = false;
	}

	function onmMouseUp(e:MouseEvent):Void
	{
		attackLineList.stopDrag();
	}

	function onmMouseMove(e:MouseEvent):Void
	{
		if (!common.isClickBlocked && Math.sqrt(Math.pow(startDragPoint.x - attackLineList.x, 2) + Math.pow(startDragPoint.y - attackLineList.y, 2)) > 10)
		{
			common.isClickBlocked = true;
		}
	}

	function addNewAttackLineHandler()
	{
		attackLineList.addAttackLine();
		attackLineList.rePosition();
		container.rePosition();
	}

	function saveHandler(_)
	{
		var data:String = "[";

		for (actionEntry in attackLineList.entries)
		{
			if (actionEntry.lineLength == null)
			{
				trace("Saving Error - Attack line # " + actionEntry.id + " not builded yet!");
				return;
			}

			data += "{id:'" + actionEntry.id + "',length:" + Math.round(actionEntry.lineLength) + ",line:[";

			for (point in actionEntry.line)
			{
				data += "{x:" + point.x + ",y:" + point.y + "},";
			}

			data = data.substr(0, data.length - 1);
			data += "]},";
		}
		data = data.substr(0, data.length - 1);
		data += "]";

		trace(data);
	}
}