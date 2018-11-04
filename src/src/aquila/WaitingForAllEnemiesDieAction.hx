package aquila;

import aquila.ActionList.ActionType;
import aquila.ExpandableBaseAction;

/**
 * ...
 * @author Krisztian Somoracz
 */
class WaitingForAllEnemiesDieAction extends ExpandableBaseAction
{
	override function build()
	{
		super.build();
		actionType = ActionType.WAITING_FOR_ALL_ENEMIES_DIE;

		label.text = "WAITING FOR ALL ENEMIES DIE";
	}

	override public function clone():WaitingForAllEnemiesDieAction
	{
		var clone:WaitingForAllEnemiesDieAction = new WaitingForAllEnemiesDieAction(openActionSelector, updateContainer, upRequest, downRequest, duplicateRequest, removeRequest);

		return clone;
	}
}