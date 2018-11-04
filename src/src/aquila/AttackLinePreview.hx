package aquila;

import com.greensock.easing.Linear;
import aquila.LinePoint;
import hpp.openfl.util.SpriteUtil;
import hpp.util.GeomUtil;
import hpp.util.GeomUtil.SimplePoint;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import com.greensock.TweenMax;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Krisztian Somoracz
 */
class AttackLinePreview extends Sprite
{
	public var isEnabled(default, default):Bool;
	public var lineDistance(default, null):Float;

	var currentLinePoints:Array<LinePoint>;
	var helperPoints:Array<Sprite>;
	var fastPreviewPoints:Array<SimplePoint>;
	var normalPreviewPoints:Array<SimplePoint>;
	var previewPoints:Array<SimplePoint>;
	var lineAnimationHelper:Sprite;
	var testEnemy:Sprite;
	var fastPreviewLine:Sprite;
	var draggedLinePoint:LinePoint;

	public function new()
	{
		super();

		currentLinePoints = [];
		helperPoints = [];

		addChild(fastPreviewLine = new Sprite());

		lineAnimationHelper = new Sprite();
		lineAnimationHelper.graphics.beginFill(0xFFFFFF);
		lineAnimationHelper.graphics.drawCircle(0, 0, 10);
		lineAnimationHelper.graphics.endFill();
		lineAnimationHelper.visible = false;
		addChild(lineAnimationHelper);

		testEnemy = new Sprite();
		var enemyGraphic:Bitmap = new Bitmap(Assets.getBitmapData("img/gamecontent/spaceship/enemy_a.png"));
		enemyGraphic.x = -enemyGraphic.width / 2;
		enemyGraphic.y = enemyGraphic.height / 2;
		enemyGraphic.rotation = -90;
		testEnemy.addChild(enemyGraphic);
		testEnemy.visible = false;
		addChild(testEnemy);

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		graphics.beginFill(0xFFFFFF, .1);
		graphics.drawRect(0, 0, 1136, 640);
		graphics.endFill();
	}

	public function loadPreview(points:Array<SimplePoint>):Void
	{
		normalPreviewPoints = previewPoints = points;
		fastPreviewPoints = null;
		redraw();
	}

	public function loadFastPreview(points:Array<SimplePoint>)
	{
		if (previewPoints == points) return;

		fastPreviewPoints = previewPoints = points;

		clearPreview();

		fastPreviewLine.graphics.lineStyle(1, 0xFFFFFF, .5);

		var index:UInt = 0;
		for (point in previewPoints)
		{
			var linePoint:LinePoint = new LinePoint(-1, point.x, point.y, null, null);
			currentLinePoints.push(linePoint);
			addChild(linePoint);

			if (index++ == 0)
			{
				fastPreviewLine.graphics.moveTo(point.x, point.y);
			}
			else if (index == previewPoints.length)
			{
				fastPreviewLine.graphics.lineTo(point.x, point.y);

				var angle:Float = GeomUtil.getAngle(point, previewPoints[index - 2]);
				var arrowAngle:Float = 10 * (Math.PI / 180);

				fastPreviewLine.graphics.beginFill(0xFFFFFF, .5);
				fastPreviewLine.graphics.lineTo(point.x + 40 * Math.cos(angle + arrowAngle), point.y + 40 * Math.sin(angle + arrowAngle));
				fastPreviewLine.graphics.lineTo(point.x + 40 * Math.cos(angle - arrowAngle), point.y + 40 * Math.sin(angle - arrowAngle));
				fastPreviewLine.graphics.lineTo(point.x + 15 * Math.cos(angle), point.y + 15 * Math.sin(angle));
			}
			else
			{
				fastPreviewLine.graphics.lineTo(point.x, point.y);
			}
		}
	}

	public function restoreNormalPreview()
	{
		if (normalPreviewPoints != null && (fastPreviewPoints == normalPreviewPoints || normalPreviewPoints != previewPoints))
		{
			fastPreviewPoints = null;

			loadPreview(normalPreviewPoints);
		}
	}

	function redraw()
	{
		clearPreview();

		var rawAttackLineDistance:Float = 0;
		var id:UInt = 0;
		var lastPoint:SimplePoint = null;

		for (point in previewPoints)
		{
			var linePoint:LinePoint = new LinePoint(id++, point.x, point.y, removeLinePoint, duplicateLinePoint);
			currentLinePoints.push(linePoint);
			addChild(linePoint);

			stage.addEventListener(MouseEvent.MOUSE_UP, stopPointDrag);
			linePoint.addEventListener(MouseEvent.MOUSE_DOWN, startPointDrag);

			if (lastPoint != null)
			{
				rawAttackLineDistance += GeomUtil.getDistance(point, lastPoint);
			}

			lastPoint = point;
		}

		lineAnimationHelper.visible = true;
		lineAnimationHelper.x = testEnemy.x = previewPoints[0].x;
		lineAnimationHelper.y = testEnemy.y = previewPoints[0].y;

		var ratio:Float = rawAttackLineDistance / 1000;

		TweenMax.to(lineAnimationHelper, .5 * ratio, { bezier: { type: "soft", values: convertSimplePointArrayForOpenFl(previewPoints), autoRotate:["set_x","set_y","set_rotation"] }, ease: Linear.easeNone, onUpdate: registerPoint, onComplete: onAttackLineBuildFinished });
	}

	public function clearPreview()
	{
		fastPreviewLine.graphics.clear();

		lineDistance = 0;

		TweenMax.killTweensOf(lineAnimationHelper);
		TweenMax.killTweensOf(testEnemy);
		TweenMax.killDelayedCallsTo(animateHelperPoint);

		testEnemy.visible = false;
		lineAnimationHelper.visible = false;

		for (helperPoint in helperPoints)
		{
			TweenMax.killTweensOf(helperPoint);
			removeChild(helperPoint);
			helperPoint = null;
		}
		helperPoints = [];

		for (linePoint in currentLinePoints)
		{
			removeChild(linePoint);
			linePoint = null;
		}

		currentLinePoints = [];
	}

	function duplicateLinePoint(linePoint:LinePoint)
	{
		for (point in previewPoints)
		{
			if (point.x == linePoint.x && point.y == linePoint.y)
			{
				var clone:SimplePoint = { x: point.x + 50, y: point.y };

				previewPoints.insert(previewPoints.indexOf(point) + 1, clone);
				break;
			}
		}

		redraw();
	}

	function removeLinePoint(linePoint:LinePoint)
	{
		if (previewPoints.length == 2) return;

		for (point in previewPoints)
		{
			if (point.x == linePoint.x && point.y == linePoint.y)
			{
				previewPoints.remove(point);
				break;
			}
		}

		redraw();
	}

	private function stopPointDrag(e:MouseEvent):Void
	{
		if (draggedLinePoint != null)
		{
			draggedLinePoint.stopDrag();
			draggedLinePoint = null;

			var index:UInt = 0;
			for (linePoint in currentLinePoints)
			{
				previewPoints[index].x = linePoint.x;
				previewPoints[index].y = linePoint.y;
				index++;
			}

			redraw();
		}
	}

	private function startPointDrag(e:MouseEvent):Void
	{
		draggedLinePoint = e.currentTarget;
		draggedLinePoint.startDrag(false, new Rectangle(-100, -100, 1136 + 200, 640 + 200));
	}

	function convertSimplePointArrayForOpenFl(points:Array<SimplePoint>):Array<{set_x:Float, set_y:Float}>
	{
		var result = [];

		for (point in points)
		{
			result.push({set_x: point.x, set_y: point.y});
		}

		return result;
	}

	function onAttackLineBuildFinished()
	{
		lineAnimationHelper.visible = false;
		testEnemy.visible = true;

		onAttackLineLengthCalculated(lineDistance);

		var ratio:Float = lineDistance / 1000;
		TweenMax.to(testEnemy, 5 * ratio, { bezier: { type: "soft", values: convertSimplePointArrayForOpenFl(previewPoints), autoRotate:["set_x", "set_y", "set_rotation"] }, ease: Linear.easeNone, repeat: -1 });

		var index:UInt = 0;
		for (helperPoint in helperPoints)
		{
			TweenMax.delayedCall( index * .05, animateHelperPoint, [helperPoint]);
			index++;
		}
	}

	function animateHelperPoint(helperPoint:Sprite)
	{
		TweenMax.to(helperPoint, .5, { set_alpha: 1 });
		TweenMax.to(helperPoint, .2, { delay: .5, set_alpha: .1 });
		TweenMax.delayedCall( helperPoints.length * .05, animateHelperPoint, [helperPoint]);
	}

	function registerPoint()
	{
		var arrowSize:UInt = 10;

		var helperPoint:Sprite = new Sprite();
		helperPoint.graphics.beginFill(0xFFFFFF);
		helperPoint.graphics.moveTo(-arrowSize / 2, -arrowSize / 2);
		helperPoint.graphics.lineTo(arrowSize, arrowSize / 2);
		helperPoint.graphics.lineTo(arrowSize / 2, arrowSize);
		helperPoint.graphics.lineTo(-arrowSize / 2, -arrowSize / 2);
		helperPoint.graphics.endFill();
		helperPoint.x = lineAnimationHelper.x;
		helperPoint.y = lineAnimationHelper.y;
		helperPoint.alpha = .1;
		helperPoint.mouseEnabled = false;
		helperPoint.rotation = lineAnimationHelper.rotation + 135;

		if (helperPoints.length > 0)
		{
			lineDistance += SpriteUtil.getDistance(helperPoint, helperPoints[helperPoints.length - 1]);
		}

		addChild(helperPoint);
		helperPoints.push(helperPoint);
	}

	dynamic public function onAttackLineLengthCalculated(length:Float) {}
}