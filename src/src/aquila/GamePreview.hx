package aquila;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import aquila.ActionList.Action;
import aquila.ActionList.ActionAddEnemyData;
import aquila.ActionList.ActionType;
import aquila.ActionList.ActionWaitData;
import hpp.openfl.ui.BaseButton;
import hpp.util.GeomUtil;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import aquila.config.AttackLineConfig;
import aquila.config.SpaceshipConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class GamePreview extends Sprite
{
	var fastPreviewLine:Sprite;
	var activeAttackLineId:String;
	var isPreviewInProgress:Bool;

	var enemies:Array<Sprite>;

	public function new()
	{
		super();

		addChild(fastPreviewLine = new Sprite());

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	function init(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		graphics.beginFill(0xFFFFFF, .1);
		graphics.drawRect(0, 0, 1136, 640);
		graphics.endFill();
	}

	public function loadAttackLinePreview(attackLine:AttackLine)
	{
		if (activeAttackLineId == attackLine.id)
		{
			return;
		}

		clearPreview();
		activeAttackLineId = attackLine.id;
		visible = true;

		fastPreviewLine.graphics.lineStyle(1, 0xFFFFFF, .5);

		var index:UInt = 0;
		for (point in attackLine.line)
		{
			if (index++ == 0)
			{
				fastPreviewLine.graphics.moveTo(point.x, point.y);
			}
			else if (index == attackLine.line.length)
			{
				fastPreviewLine.graphics.lineTo(point.x, point.y);

				var angle:Float = GeomUtil.getAngle(point, attackLine.line[index - 2]);
				var arrowAngle:Float = 20 * (Math.PI / 180);

				fastPreviewLine.graphics.beginFill(0xFFFFFF, .5);
				fastPreviewLine.graphics.lineTo(point.x + 20 * Math.cos(angle + arrowAngle), point.y + 20 * Math.sin(angle + arrowAngle));
				fastPreviewLine.graphics.lineTo(point.x + 20 * Math.cos(angle - arrowAngle), point.y + 20 * Math.sin(angle - arrowAngle));
				fastPreviewLine.graphics.lineTo(point.x, point.y);
			}
			else
			{
				fastPreviewLine.graphics.lineTo(point.x, point.y);
			}
		}
	}

	public function clearPreview()
	{
		fastPreviewLine.graphics.clear();
		activeAttackLineId = "";

		if (!isPreviewInProgress)
		{
			visible = false;
		}
	}

	public function play(target:BaseButton, actionList:Array<Action>)
	{
		if (isPreviewInProgress)
		{
			target.labelText = "PLAY";
			stop();
			return;
		}

		visible = true;
		enemies = [];
		isPreviewInProgress = true;
		target.labelText = "STOP";
		var commonDelay:Float = 0;

		for (action in actionList)
		{
			switch action.type
			{
				case ActionType.WAIT:
					var data:ActionWaitData = cast action.data;
					commonDelay += data.time;

				case ActionType.WAITING_FOR_ALL_ENEMIES_DIE:
					// To simulate all enemies die we wait 5 sec
					commonDelay += 5;

				case ActionType.ADD_ENEMY:
					addEnemy(commonDelay, cast action.data);

				case _:
			}
		}

		TweenMax.delayedCall(commonDelay, play, [target, null]);
	}

	function stop()
	{
		isPreviewInProgress = false;
		visible = false;
		TweenMax.killDelayedCallsTo(play);

		for (enemy in enemies)
		{
			TweenMax.killTweensOf(enemy);
			removeChild(enemy);
			enemy = null;
		}
	}

	function addEnemy(delay:Float, data:ActionAddEnemyData)
	{
		var attackLine:AttackLine = aquila.config.AttackLineConfig.getAttackLine(data.attackLineId);
		var spaceshipConfig:SpaceshipConfig = aquila.config.SpaceshipConfigs.getSpaceshipConfig(data.enemyId);
		var ratio:Float = attackLine.length / 1000;

		for (i in 0...data.count)
		{
			var enemy:Sprite = new Sprite();
			var enemyGraphic:Bitmap = new Bitmap(Assets.getBitmapData(spaceshipConfig.tile));
			enemyGraphic.x = -enemyGraphic.width / 2;
			enemyGraphic.y = -enemyGraphic.height / 2;
			enemyGraphic.rotation = 90;
			enemy.addChild(enemyGraphic);
			enemy.x = attackLine.line[0].x;
			enemy.y = attackLine.line[0].y;
			enemy.visible = false;
			addChild(enemy);
			enemies.push(enemy);

			TweenMax.to(enemy, spaceshipConfig.speed * ratio, {
				bezier: {
					type: "soft",
					values: convertSimplePointArrayForOpenFl(attackLine.line),
					autoRotate:["set_x", "set_y", "set_rotation"]
				},
				ease: Linear.easeNone,
				delay: delay + i * data.delay,
				onStart: function () {
					enemy.visible = true;
				},
				onComplete: function () {
					enemy.visible = false;
				}
			});
		}
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
}