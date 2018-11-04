package aquila.ui;

import hpp.util.GeomUtil.SimplePoint;
import openfl.display.Sprite;

/**
 * ...
 * @author Krisztian Somoracz
 */
class UiElements
{
	public static function getTabBaseBackground():Sprite return createRect(115, 35, 0x4DD2FF);
	public static function getTabOverBackground():Sprite return setBrightness(getTabBaseBackground(), .8);
	public static function getTabSelectedBackground():Sprite return createRect(115, 35, 0x00759B);

	public static function getBaseEntryBackground(size:SimplePoint):Sprite return createRect(size.x, size.y, 0x888888);
	public static function getBaseEntryOverBackground(size:SimplePoint):Sprite return setBrightness(getBaseEntryBackground(size), .8);
	public static function getBaseEntrySelectedBackground(size:SimplePoint):Sprite return setBrightness(getBaseEntryBackground(size), .6);

	public static function getTilePreviewBackground(size:SimplePoint):Sprite return createRect(size.x, size.y, 0x2e2e2e);
	public static function getTilePreviewOverBackground(size:SimplePoint):Sprite return setBrightness(getTilePreviewBackground(size), .8);
	public static function getTilePreviewSelectedBackground(size:SimplePoint):Sprite return setFrame(getTilePreviewOverBackground(size), 0x00FF00, 2);

	public static function getSaveButtonBackground():Sprite return createRect(174, 35, 0x00FF7F);
	public static function getSaveButtonOverBackground():Sprite return setBrightness(getSaveButtonBackground(), .8);

	public static function getLoadButtonBackground():Sprite return createRect(174, 35, 0x4DFFFF);
	public static function getLoadButtonOverBackground():Sprite return setBrightness(getLoadButtonBackground(), .8);

	public static function getSimpleButtonBackground():Sprite return createRect(350, 35, 0x4ED714);
	public static function getSimpleButtonOverBackground():Sprite return setBrightness(getSimpleButtonBackground(), .8);

	private static function createRect(width:Float, height:Float, color:UInt):Sprite
	{
		var g:Sprite = new Sprite();
		g.graphics.beginFill(color);
		g.graphics.drawRect(0, 0, width, height);
		g.graphics.endFill();

		return g;
	}

	private static function setBrightness(target:Sprite, brightness:Float):Sprite
	{
		if (brightness > 1)
			target.graphics.beginFill(0xFFFFFF, brightness - 1);
		else
			target.graphics.beginFill(0x000000, 1 - brightness);

		target.graphics.drawRect(0, 0, target.width, target.height);
		target.graphics.endFill();

		return target;
	}

	private static function setFrame(target:Sprite, color:UInt, frameSize:Float = 1):Sprite
	{
		target.graphics.beginFill(color);
		target.graphics.drawRect(0, 0, target.width, frameSize);
		target.graphics.drawRect(target.width - frameSize, frameSize, frameSize, target.height - frameSize);
		target.graphics.drawRect(0, target.height - frameSize, target.width - frameSize, frameSize);
		target.graphics.drawRect(0, frameSize, frameSize, target.height - frameSize * 2);
		target.graphics.endFill();

		return target;
	}
}