package aquila.enemyeditor;

import aquila.AnimatedVUIBox;
import aquila.EditorMenu;
import com.greensock.TweenMax;
import aquila.EditorMenu.Common;
import hpp.ui.HAlign;
import openfl.events.MouseEvent;
import aquila.config.SpaceshipConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipList extends AnimatedVUIBox
{
	public var entries:Array<SpaceshipEntry>;

	var openActionSelector:SpaceshipEntry->Void;
	var closeActionSelectors:Void->Void;
	var spaceshipPage:SpaceshipPage;
	var common:Common;

	public function new(common:Common, spaceshipPage:SpaceshipPage)
	{
		super(2, HAlign.LEFT);
		this.common = common;
		this.spaceshipPage = spaceshipPage;

		entries = [];

		load();
		entries[0].select();
	}

	function load() for (c in aquila.config.SpaceshipConfigs.config) addSpaceshipEntry(null, c, c.id);

	public function onChange(c:SpaceshipConfig)
	{
		for (entry in entries)
		{
			if (entry.config.id == c.id)
			{
				entry.update();
				return;
			}
		}
	}

	public function addSpaceshipEntry(index:UInt = null, config:SpaceshipConfig = null, customId:String = null):SpaceshipEntry
	{
		if (config == null) config = aquila.config.SpaceshipConfigs.getEmpty();
		config.id = customId == null ? Std.string(Date.now().getTime()) : customId;

		var enemyEntry:SpaceshipEntry = new SpaceshipEntry(
			config,
			addEntryInstant, updateContainer,
			upRequest,
			downRequest,
			duplicateRequest,
			removeRequest
		);
		enemyEntry.onSelected = spaceshipEntrySelected;
		addListenersToEnemyEntry(enemyEntry);

		if (index == null)
		{
			addChild(enemyEntry);
		}
		else
		{
			addChildAt(enemyEntry, index);
		}

		entries.push(enemyEntry);

		return enemyEntry;
	}

	function spaceshipEntrySelected(spaceshipEntry:SpaceshipEntry)
	{
		for (entry in entries)
		{
			if (entry != spaceshipEntry)
			{
				entry.deSelect();
			}
		}

		spaceshipPage.load(spaceshipEntry.config);
	}

	function addEntryInstant(requestOwner:SpaceshipEntry)
	{
		var index:UInt = getChildIndex(requestOwner);
		addSpaceshipEntry(index + 1);
	}

	function upRequest(target:SpaceshipEntry)
	{
		var index:UInt = getChildIndex(target);

		if (index > 0)
		{
			swapChildrenAt(index, index - 1);
		}
		rePosition();
	}

	function downRequest(target:SpaceshipEntry)
	{
		var index:UInt = getChildIndex(target);

		if (index < numChildren - 1)
		{
			swapChildrenAt(index, index + 1);
		}
		rePosition();
	}

	function duplicateRequest(target:SpaceshipEntry)
	{
		var index:UInt = getChildIndex(target);
		var instance:SpaceshipEntry = cast addChildAt(target.clone(), index + 1);
		instance.y = target.y;

		addListenersToEnemyEntry(instance);
		instance.onSelected = spaceshipEntrySelected;
		entries.push(instance);
	}

	function updateContainer()
	{
		rePosition();
	}

	function removeRequest(target:SpaceshipEntry)
	{
		entries.remove(target);
		removeChild(target);
		target.dispose();
		target = null;

		stage.focus = this;
	}

	function addListenersToEnemyEntry(entry:SpaceshipEntry):Void
	{
		entry.addEventListener(MouseEvent.MOUSE_OVER, onAttackLineMouseOver);
		entry.addEventListener(MouseEvent.MOUSE_OUT, onAttackLineMouseOut);
	}

	private function onAttackLineMouseOut(e):Void
	{
	}

	private function onAttackLineMouseOver(e):Void
	{
	}
}