package aquila;

import com.greensock.TweenMax;
import aquila.AnimatedVUIBox;
import aquila.BaseAction;
import aquila.EditorMenu.Common;
import aquila.config.AttackLineConfig;
import hpp.ui.HAlign;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AttackLineList extends AnimatedVUIBox
{
	public var entries:Array<AttackLineEntry>;

	var openActionSelector:AttackLineEntry->Void;
	var closeActionSelectors:Void->Void;
	var attackLinePreview:AttackLinePreview;
	var common:Common;

	public function new(common:Common, attackLinePreview:AttackLinePreview)
	{
		super(5, HAlign.LEFT);
		this.common = common;
		this.attackLinePreview = attackLinePreview;

		entries = [];

		load();
	}

	function load()
	{
		for (attackLine in aquila.config.AttackLineConfig.config)
		{
			var attackLineEntry = addAttackLine(null, cast attackLine.id);
			attackLineEntry.line = attackLine.line;
			attackLineEntry.onAttackLineLengthCalculated(attackLine.length);
		}
	}

	public function addAttackLine(index:UInt = null, customId:Float = null):AttackLineEntry
	{
		var attackLineEntry:AttackLineEntry = new AttackLineEntry(Std.string(customId == null ? Date.now().getTime() : customId), addEntryInstant, updateContainer, upRequest, downRequest, duplicateRequest, removeRequest);
		attackLineEntry.onSelected = attackLineEntrySelected;
		addListenersToAttackLineEntry(attackLineEntry);

		if (index == null)
		{
			addChild(attackLineEntry);
		}
		else
		{
			addChildAt(attackLineEntry, index);
		}

		entries.push(attackLineEntry);

		return attackLineEntry;
	}

	function attackLineEntrySelected(attackLineEntry:AttackLineEntry)
	{
		for (entry in entries)
		{
			if (entry != attackLineEntry)
			{
				entry.deSelect();
			}
		}

		attackLinePreview.onAttackLineLengthCalculated = attackLineEntry.onAttackLineLengthCalculated;
		attackLinePreview.loadPreview(attackLineEntry.line);
	}

	function addEntryInstant(requestOwner:AttackLineEntry)
	{
		var index:UInt = getChildIndex(requestOwner);
		addAttackLine(index + 1);
	}

	function upRequest(target:AttackLineEntry)
	{
		var index:UInt = getChildIndex(target);

		if (index > 0)
		{
			swapChildrenAt(index, index - 1);
		}
		rePosition();
	}

	function downRequest(target:AttackLineEntry)
	{
		var index:UInt = getChildIndex(target);

		if (index < numChildren - 1)
		{
			swapChildrenAt(index, index + 1);
		}
		rePosition();
	}

	function duplicateRequest(target:AttackLineEntry)
	{
		var index:UInt = getChildIndex(target);
		var instance:AttackLineEntry = cast addChildAt(target.clone(), index + 1);
		instance.y = target.y;

		addListenersToAttackLineEntry(instance);
		instance.onSelected = attackLineEntrySelected;
		entries.push(instance);
	}

	function updateContainer()
	{
		rePosition();
	}

	function removeRequest(target:AttackLineEntry)
	{
		entries.remove(target);
		removeChild(target);
		target.dispose();
		target = null;

		stage.focus = this;
	}

	function addListenersToAttackLineEntry(entry:AttackLineEntry):Void
	{
		entry.addEventListener(MouseEvent.MOUSE_OVER, onAttackLineMouseOver);
		entry.addEventListener(MouseEvent.MOUSE_OUT, onAttackLineMouseOut);
	}

	private function onAttackLineMouseOut(e):Void
	{
		TweenMax.killDelayedCallsTo(attackLinePreview.restoreNormalPreview);
		TweenMax.delayedCall(.2, attackLinePreview.restoreNormalPreview);
	}

	private function onAttackLineMouseOver(e):Void
	{
		TweenMax.killDelayedCallsTo(attackLinePreview.restoreNormalPreview);

		var entry:AttackLineEntry = e.currentTarget;

		attackLinePreview.loadFastPreview(entry.line);
	}
}