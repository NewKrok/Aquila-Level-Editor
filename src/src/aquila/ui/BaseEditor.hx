package aquila.ui;
import aquila.EditorMenu;

import aquila.EditorMenu.Common;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class BaseEditor extends Sprite implements IEditor
{
	var common:Common;
	var content:DisplayObject;

	public function disable()
	{
		if (content == null) return;

		if (content.parent != null) common.editorWorld.removeChild(content);
		content.visible = false;
	}

	public function enable()
	{
		if (content == null) return;

		content.visible = true;
		common.editorWorld.addChild(content);
	}
}