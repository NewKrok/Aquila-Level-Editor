package aquila.ui;

import com.greensock.TweenMax;
import aquila.ui.UiElements;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.LinkedButton;
import openfl.Assets;
import openfl.display.Bitmap;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EditorTabs extends HUIBox
{
	var pages:Array<IEditor> = [];

	public function new(editors:Array<EditorTab>)
	{
		super(2);

		for (editor in editors) addEditorTab(editor);

		var childs:Array<LinkedButton> = [];
		for (i in 0...numChildren) childs.push(cast getChildAt(i));
		childs[0].linkToButtonList(childs);
	}

	function addEditorTab(editor:EditorTab)
	{
		pages.push(editor.instance);

		var tab:LinkedButton = new LinkedButton(
			function (_) { changeTab(editor.instance); },
			"",
			UiElements.getTabBaseBackground(),
			UiElements.getTabOverBackground(),
			UiElements.getTabSelectedBackground()
		);

		var icon:Bitmap = new Bitmap(Assets.getBitmapData(editor.iconUrl));
		var iconSelected:Bitmap = new Bitmap(Assets.getBitmapData(editor.iconUrl.split(".png")[0] + "_selected.png"));

		tab.addChild(icon);
		icon.scaleX = icon.scaleY = .5;
		icon.x = tab.width / 2 - icon.width / 2;
		icon.y = tab.height / 2 - icon.height / 2;

		tab.addChild(iconSelected);
		iconSelected.scaleX = iconSelected.scaleY = .5;
		iconSelected.x = tab.width / 2 - iconSelected.width / 2;
		iconSelected.y = tab.height / 2 - iconSelected.height / 2;
		iconSelected.visible = false;

		tab.onSelected = function (_)
		{
			icon.visible = false;
			iconSelected.visible = true;
		};

		tab.onDeselected = function (_)
		{
			icon.visible = true;
			iconSelected.visible = false;
		};

		addChild(tab);
		if (editor.isSelected) tab.isSelected = true;
	}

	function hideAllPage()
	{
		for (page in pages) page.disable();
	}

	function changeTab(t:BaseEditor)
	{
		hideAllPage();
		t.enable();

		parent.addChildAt(t, 3);

		t.alpha = 0;
		TweenMax.killTweensOf(t);
		TweenMax.to(t, .5, { set_alpha: 1 });
	}
}

typedef EditorTab = {
	var instance:BaseEditor;
	var iconUrl:String;
	@:optional var isSelected:Bool;
}