package aquila;

import aquila.ui.UiElements;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.VUIBox;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Krisztian Somoracz
 */
class LoadWindow extends Sprite
{
	var container:VUIBox;
	var closeButton:BaseButton;
	var pasteData:String;
	var info:TextField;
	var onLoad:String->LoadWindow->Void;

	public function new(onClose:LoadWindow->Void, onLoad:String->LoadWindow->Void)
	{
		super();
		this.onLoad = onLoad;

		untyped __js__("window.addEventListener('paste', (e)=>this.onPaste(e));");

		addChild(container = new VUIBox(20));

		var tFormat:TextFormat = new TextFormat("Verdana", 20);
		tFormat.align = "center";
		info = new TextField();
		info.text = "Load from clipboard with CTRL+V.";
		info.defaultTextFormat = tFormat;
		info.width = 900;
		info.autoSize = "center";
		info.wordWrap = true;
		info.textColor = 0xFFFFFF;
		container.addChild(info);

		var buttonContainer:HUIBox = new HUIBox(20);

		buttonContainer.addChild(closeButton = new BaseButton(
			function(_) { onClose(this); },
			'CLOSE',
			UiElements.getSimpleButtonBackground(),
			UiElements.getSimpleButtonOverBackground()
		));
		closeButton.fontSize = 12;

		container.addChild(buttonContainer);

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	function onPaste(e:Dynamic)
	{
		try
		{
			onLoad(e.clipboardData.getData('text/plain'), this);
		}
		catch (e:Dynamic)
		{
			info.text = "Wrong data! Update your clipboard and try again.";
		}
	}

	function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		graphics.beginFill(0, .8);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.endFill();

		container.x = width / 2 - container.width / 2;
		container.y = height / 2 - container.height / 2;
	}
}