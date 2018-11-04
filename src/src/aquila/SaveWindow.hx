package aquila;

import aquila.ui.UiElements;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.VUIBox;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SaveWindow extends Sprite
{
	var container:VUIBox;
	var closeButton:BaseButton;
	var input:TextField;

	public function new(onClose:SaveWindow->Void, data:String)
	{
		super();

		addChild(container = new VUIBox(20));

		var tFormat:TextFormat = new TextFormat("Verdana", 20);
		tFormat.align = "center";
		input = new TextField();
		input.text = "Copied to clipboard.";
		input.defaultTextFormat = tFormat;
		input.width = 900;
		input.autoSize = "center";
		input.wordWrap = true;
		input.textColor = 0xFFFFFF;
		container.addChild(input);

		untyped __js__("var saveTextArea = document.createElement('TextArea');");
		untyped __js__("saveTextArea.value = data;");
		untyped __js__("document.body.appendChild(saveTextArea);");
		untyped __js__("saveTextArea.select();");
		untyped __js__("document.execCommand('copy');");
		untyped __js__("document.body.removeChild(saveTextArea);");

		container.addChild(closeButton = new BaseButton(
			function(_) { onClose(this); },
			'CLOSE',
			UiElements.getSimpleButtonBackground(),
			UiElements.getSimpleButtonOverBackground()
		));
		closeButton.fontSize = 12;

		addEventListener(Event.ADDED_TO_STAGE, init);
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