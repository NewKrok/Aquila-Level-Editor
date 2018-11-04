package aquila;

import com.greensock.TweenMax;
import aquila.ActionMenu;
import aquila.ActionSelector;
import aquila.ActionSubContent;
import aquila.AttackLineEntry;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.VUIBox;
import hpp.util.GeomUtil.SimplePoint;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AttackLineEntry extends BaseAction
{
	public var lineLength(default, null):Float;

	public var line:Array<SimplePoint>;
	public var id:String;
	public var onSelected:AttackLineEntry->Void;

	var actionSubContentWrapper:Sprite;
	var actionSubContent:Sprite;
	var subContainer:VUIBox;
	var expandButton:BaseButton;
	var addEntryButton:BaseButton;
	var addEntryInstant:AttackLineEntry->Void;
	var updateContainer:Void->Void;
	var upRequest:AttackLineEntry->Void;
	var downRequest:AttackLineEntry->Void;
	var duplicateRequest:AttackLineEntry->Void;
	var removeRequest:AttackLineEntry->Void;

	public function new(id:String, addEntryInstant:AttackLineEntry->Void, updateContainer:Void->Void, upRequest:AttackLineEntry->Void, downRequest:AttackLineEntry->Void, duplicateRequest:AttackLineEntry->Void, removeRequest:AttackLineEntry->Void)
	{
		super("img/attack_line_button.png", "img/attack_line_button_over.png", "img/attack_line_button_selected.png");
		background.isSelectable = true;
		label.text = "# " + id;

		this.id = id;
		this.addEntryInstant = addEntryInstant;
		this.updateContainer = updateContainer;
		this.upRequest = upRequest;
		this.downRequest = downRequest;
		this.duplicateRequest = duplicateRequest;
		this.removeRequest = removeRequest;

		subContainer = new VUIBox();

		actionSubContentWrapper = new Sprite();
		actionSubContentWrapper.addChild(actionSubContent = new ActionSubContent());
		subContainer.addChild(actionSubContentWrapper);
		subContainer.addChild(
			new ActionMenu(
				function() { upRequest(this); },
				function() { downRequest(this); },
				function() { duplicateRequest(this); },
				function() { removeRequest(this); }
			)
		);

		title.addChild(addEntryButton = new BaseButton(
			function (_) { addEntryInstant(this); },
			"",
			new Bitmap(Assets.getBitmapData("img/instant_add_entry_button.png")),
			new Bitmap(Assets.getBitmapData("img/instant_add_entry_button_over.png"))
		));
		addEntryButton.x = title.width - addEntryButton.width;

		title.addChild(expandButton = new BaseButton(
			toggleExpand,
			"",
			new Bitmap(Assets.getBitmapData("img/expand_arrow.png")),
			new Bitmap(Assets.getBitmapData("img/expand_arrow_over.png"))
		));
		expandButton.x = addEntryButton.x - expandButton.width;

		line = [{ x: 1136 / 2 - 300, y: 640 / 2 }, { x: 1136 / 2 + 300, y: 640 / 2 }];

		var subContent:HUIBox = new HUIBox(2);


		var flipXButton:BaseButton = new BaseButton(
			function (_) { flipXEntry(this); },
			"FLIP X",
			new Bitmap(Assets.getBitmapData("img/line_action_button.png")),
			new Bitmap(Assets.getBitmapData("img/line_action_button_over.png"))
		);
		flipXButton.label.textColor = 0xFFFFFF;
		flipXButton.fontSize = 12;
		subContent.addChild(flipXButton);

		var flipYButton:BaseButton = new BaseButton(
			function (_) { flipYEntry(this); },
			"FLIP Y",
			new Bitmap(Assets.getBitmapData("img/line_action_button.png")),
			new Bitmap(Assets.getBitmapData("img/line_action_button_over.png"))
		);
		flipYButton.label.textColor = 0xFFFFFF;
		flipYButton.fontSize = 12;
		subContent.addChild(flipYButton);

		var reverseButton:BaseButton = new BaseButton(
			function (_) { reverseEntry(this); },
			"REVERSE",
			new Bitmap(Assets.getBitmapData("img/line_action_button.png")),
			new Bitmap(Assets.getBitmapData("img/line_action_button_over.png"))
		);
		reverseButton.label.textColor = 0xFFFFFF;
		reverseButton.fontSize = 12;
		subContent.addChild(reverseButton);

		actionSubContent.addChild(subContent);

		subContainer.rePosition();
		rePosition();

		constructed();
	}

	function flipXEntry(attackLineEntry:AttackLineEntry)
	{
		for (point in line)
		{
			point.x = 1136 / 2 - ( point.x - 1136 / 2 );
		}

		onSelected(this);
	}

	function flipYEntry(attackLineEntry:AttackLineEntry)
	{
		for (point in line)
		{
			point.y = 640 / 2 - ( point.y - 640 / 2 );
		}

		onSelected(this);
	}

	function reverseEntry(attackLineEntry:AttackLineEntry)
	{
		line.reverse();
		onSelected(this);
	}

	function toggleExpand(target:BaseButton)
	{
		expandButton.scaleY = -expandButton.scaleY;
		expandButton.y = expandButton.scaleY == 1 ? 0 : expandButton.height;

		if (subContainer.parent == null)
		{
			addChild(subContainer);
			subContainer.alpha = 0;
			TweenMax.killTweensOf(subContainer);
			TweenMax.to(subContainer, .5, { set_alpha: 1 });
		}
		else
		{
			removeChild(subContainer);
		}
		updateContainer();
	}

	override function update()
	{
		if (actionSubContentWrapper != null)
		{
			actionSubContentWrapper.graphics.beginFill(0x555555);
			actionSubContentWrapper.graphics.drawRect(0, 0, width, actionSubContent.height + 20);
			actionSubContentWrapper.graphics.endFill();

			subContainer.rePosition();
			rePosition();
		}
	}

	override function onClick()
	{
		background.isSelected = true;
		onSelected(this);
	}

	public function deSelect():Void
	{
		background.isSelected = false;
	}

	public function onAttackLineLengthCalculated(length:Float)
	{
		lineLength = length;
	}

	function constructed() {}

	override public function clone():AttackLineEntry
	{
		var clone:AttackLineEntry = new AttackLineEntry(Std.string(Date.now().getTime()), addEntryInstant, updateContainer, upRequest, downRequest, duplicateRequest, removeRequest);

		var lineClone:Array<SimplePoint> = [];

		for (point in line)
		{
			lineClone.push({ x: point.x, y: point.y });
		}

		clone.line = lineClone;

		return clone;
	}
}