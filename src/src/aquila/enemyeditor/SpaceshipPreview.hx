package aquila.enemyeditor;

import aquila.config.DecorationConfigs;
import aquila.config.SpaceshipConfigs.DecorationData;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import aquila.ui.NumberProperty;
import aquila.ui.TilePreview;
import hpp.openfl.ui.VUIBox;
import hpp.util.GeomUtil.SimplePoint;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import aquila.config.TileConfigs;
import aquila.config.SpaceshipConfigs;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipPreview extends Sprite
{
	var preview:Bitmap;

	var bullets:Array<SampleBullet>;
	var firePoints:Array<SimplePoint>;
	var firePointMarkers:Array<FirePointMarker>;
	var fireBulletInfos:Array<FireBulletInfo>;
	var fireBulletMarkerContainer:Sprite;

	var missiles:Array<SampleBullet>;
	var fireMissilePoints:Array<SimplePoint>;
	var fireMissilePointMarkers:Array<FirePointMarker>;
	var fireMissileInfos:Array<FireBulletInfo>;
	var fireMissileMarkerContainer:Sprite;

	var bindedDecoration:Array<DecorationData> = [];
	var decorationDatas:Map<SpaceshipDecoration, DecorationData> = new Map<SpaceshipDecoration, DecorationData>();
	var decorations:Array<SpaceshipDecoration> = [];
	var decorContainer:Sprite;
	var decorationLibrary:DecorationLibrary;
	var activeDecor:SpaceshipDecoration;

	var previewContainer:Sprite;
	var moveDirection:Int = 1;
	var speed:Float = 1;

	var lastTime:Float;

	var lastFireTime:Float;
	var fireRate:Float = 1000;
	var bulletSpeed:Float = 5;
	var bulletTile:TileConfig = { editorUrl: aquila.config.TileConfigs.bulletTileConfig[0].editorUrl, gameUrl: "" };
	var activeBulletMarker:FirePointMarker;

	var lastMissileFireTime:Float;
	var fireMissileRate:Float = 5000;
	var missileSpeed:Float = 5;
	var missileTile:TileConfig = { editorUrl: aquila.config.TileConfigs.missileTileConfig[0].editorUrl, gameUrl: "" };
	var activeMissileMarker:FirePointMarker;

	var addBulletArea:TilePreview;
	var addMissileArea:TilePreview;
	var removeElementArea:Sprite;

	var speedMultiplierProp:NumberProperty;
	var gridSizeProp:NumberProperty;
	var previewPropHolder:VUIBox;

	public function new()
	{
		super();

		bullets = [];
		firePointMarkers = [];

		missiles = [];
		fireMissilePointMarkers = [];

		graphics.beginFill(0x111111);
		graphics.drawRect(0, 0, 400, 620);
		graphics.endFill();

		previewPropHolder = new VUIBox(2);
		previewPropHolder.x = 5;

		previewPropHolder.addChild(speedMultiplierProp = new NumberProperty("SPEED (%)", true, 0, 2, 390));
		speedMultiplierProp.value = 1;
		speedMultiplierProp.onValueChanged = function(v) {
			move(speed);
		};

		previewPropHolder.addChild(gridSizeProp = new NumberProperty("GRID", false, 1, 100, 390));
		gridSizeProp.value = 5;

		addChild(previewPropHolder);
		previewPropHolder.y = height - previewPropHolder.height - 5;

		addChild(removeElementArea = new Sprite());
		removeElementArea.graphics.beginFill(0xFF0000);
		removeElementArea.graphics.drawRect(0, 0, 35, 35);
		removeElementArea.graphics.endFill();
		removeElementArea.x = 5;
		removeElementArea.y = previewPropHolder.y - removeElementArea.height - 5;

		createAddBulletArea();
		createAddMissileArea();

		addChild(previewContainer = new Sprite());
		previewContainer.x = 75;
		previewContainer.y = height - 150;
		previewContainer.addChild(fireBulletMarkerContainer = new Sprite());
		fireBulletMarkerContainer.visible = false;
		previewContainer.addChild(fireMissileMarkerContainer = new Sprite());
		fireMissileMarkerContainer.visible = false;

		addChild(decorationLibrary = new DecorationLibrary(function(c) { addDecoration(c, null); }));
		decorationLibrary.x = width - decorationLibrary.width - 5;
		decorationLibrary.y = 5;
		previewContainer.addChild(decorContainer = new Sprite());

		addEventListener(Event.ADDED_TO_STAGE, init);
		addEventListener(Event.ENTER_FRAME, update);
		addEventListener(MouseEvent.MOUSE_OVER, mOver);
		addEventListener(MouseEvent.MOUSE_OUT, mOut);
		lastTime = lastFireTime = Date.now().getTime();

		move(10);
	}

	private function init(e):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
		stage.addEventListener(MouseEvent.MOUSE_MOVE, mMove);
	}

	function addDecoration(config, point:SimplePoint = null)
	{
		point = point == null ? {x: 0, y: 0} : point;

		var decor = new SpaceshipDecoration(config);
		decor.addEventListener(MouseEvent.MOUSE_DOWN, mDownDecor);
		decor.x = point.x;
		decor.y = point.y;

		decorations.push(decor);
		decorationDatas.set(decor, {id: config.id, point: point});

		decorContainer.addChild(decor);

		for (d in decorations) d.reset();
	}

	function updateBindedDecors()
	{
		for (i in 0...bindedDecoration.length) bindedDecoration.pop();
		for (d in decorationDatas) bindedDecoration.push(d);
	}

	function mOut(e:MouseEvent):Void
	{
		fireBulletMarkerContainer.visible = false;
		fireMissileMarkerContainer.visible = false;
		TweenMax.globalTimeScale(1);
	}

	function mOver(e:MouseEvent):Void
	{
		fireBulletMarkerContainer.visible = true;
		fireMissileMarkerContainer.visible = true;
		TweenMax.globalTimeScale(0);
	}

	function createAddBulletArea()
	{
		if (addBulletArea != null)
		{
			removeChild(addBulletArea);
			addBulletArea = null;
		}

		if (bulletTile != null && bulletTile.editorUrl != "")
		{
			addChild(addBulletArea = new TilePreview(null, bulletTile, { x: 35, y: 35 }));
			addBulletArea.buttonMode = true;
			addBulletArea.addEventListener(MouseEvent.CLICK, addFireBulletPoint);
			addBulletArea.rotation = -90;
			addBulletArea.x = width - addBulletArea.width - 5;
			addBulletArea.y = previewPropHolder.y - addBulletArea.height - 5;
		}
	}

	private function addFireBulletPoint(e:MouseEvent):Void
	{
		firePoints.push({ x: 0, y: 0 });
		createFirePoints();
	}

	function createAddMissileArea()
	{
		if (addMissileArea != null)
		{
			removeChild(addMissileArea);
			addMissileArea = null;
		}

		if (missileTile != null && missileTile.editorUrl != "")
		{
			addChild(addMissileArea = new TilePreview(null, missileTile, { x: 35, y: 35 }));
			addMissileArea.buttonMode = true;
			addMissileArea.addEventListener(MouseEvent.CLICK, addFireMissilePoint);
			addMissileArea.rotation = -90;
			addMissileArea.x = addBulletArea.x - addMissileArea.width - 5;
			addMissileArea.y = previewPropHolder.y - addMissileArea.height - 5;
		}
	}

	private function addFireMissilePoint(e:MouseEvent):Void
	{
		fireMissilePoints.push({ x: 0, y: 0 });
		createFireMissilePoints();
	}

	private function update(e:Event):Void
	{
		var now:Float = Date.now().getTime();
		var d:Float = (now - lastTime) / 10;
		lastTime = now;

		var index = 0;
		for (i in 0...bullets.length)
		{
			var bullet = bullets[index];
			bullet.update(d, speedMultiplierProp.value);
			if (bullets.indexOf(bullet) == -1) index--;
			index++;
		}

		if (fireRate != 0 && now - lastFireTime > fireRate / speedMultiplierProp.value)
		{
			for (point in firePoints)
			{
				var bullet = new SampleBullet(bulletTile.gameUrl, bulletSpeed, -Math.PI / 2, speedMultiplierProp.value, onBulletRemove);
				bullet.x = previewContainer.x + point.x;
				bullet.y = previewContainer.y + point.y;
				addChildAt(bullet, 0);
				bullets.push(bullet);
			}

			lastFireTime = now;
		}
	}

	function onBulletRemove(b:SampleBullet)
	{
		removeChild(b);
		bullets.remove(b);
		b = null;
	}

	function move(speed:Float, d:Int = null)
	{
		if (d != null) moveDirection = d;

		TweenMax.killTweensOf(previewContainer);
		if (moveDirection == 1)
		{
			TweenMax.to(
				previewContainer,
				(325 - previewContainer.x) / 1000 * speed / speedMultiplierProp.value,
				{set_x: 325, ease: Linear.easeNone, onComplete: move, onCompleteParams: [speed, -1]}
			);
		}
		else
		{
			TweenMax.to(
				previewContainer,
				(previewContainer.x - 75) / 1000 * speed / speedMultiplierProp.value,
				{set_x: 75, ease: Linear.easeNone, onComplete: move, onCompleteParams: [speed, 1]}
			);
		}
	}

	public function load(config:SpaceshipConfig):Void
	{
		if (preview != null) previewContainer.removeChild(preview);

		preview = new Bitmap(Assets.getBitmapData(config.tile));
		preview.scaleX = preview.scaleY = aquila.config.TileConfigs.TILE_SCALE;
		preview.x = -preview.width / 2;
		preview.y = -preview.height / 2;
		previewContainer.addChildAt(preview, 0);

		previewContainer.graphics.clear();
		previewContainer.graphics.lineStyle(2, 0xFFFFFF);
		previewContainer.graphics.moveTo(0, 0);
		previewContainer.graphics.drawCircle(0, 0, config.hitAreaRadius);

		move(speed = config.speed);
		fireRate = config.fireRate;
		bulletTile = { editorUrl: TileConfigs.getEditorUrlByGameUrl(config.bulletConfig.graphicId), gameUrl: config.bulletConfig.graphicId };
		bulletSpeed = config.bulletConfig.speed;
		firePoints = config.bulletConfig.firePoints;
		fireMissileRate = config.missileFireRate;
		bindedDecoration = config.decorations;
		missileTile = { editorUrl: TileConfigs.getEditorUrlByGameUrl(config.missileConfig.graphicId), gameUrl: config.missileConfig.graphicId };
		missileSpeed = config.missileConfig.speed;
		fireMissilePoints = config.missileConfig.firePoints;

		createFirePoints();
		createAddBulletArea();

		createFireMissilePoints();
		createAddMissileArea();

		for (i in 0...decorations.length)
		{
			var d = decorations[0];
			decorationDatas.remove(d);
			decorContainer.removeChild(d);
			decorations.remove(d);
		}
		for (i in 0...bindedDecoration.length)
		{
			var d = bindedDecoration[i];
			addDecoration(DecorationConfigs.getConfig(d.id), d.point);
		}
	}

	function createFirePoints()
	{
		for (marker in firePointMarkers)
		{
			marker.removeEventListener(MouseEvent.MOUSE_DOWN, mDownBullet);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
			fireBulletMarkerContainer.removeChild(marker);
			marker = null;
		}
		firePointMarkers = [];
		fireBulletInfos = [];

		if (bulletTile != null && bulletTile.editorUrl != "")
		{
			for (point in firePoints)
			{
				var marker:FirePointMarker = new FirePointMarker(bulletTile.gameUrl);
				marker.x = point.x;
				marker.y = point.y;
				marker.rotation = -90;
				fireBulletMarkerContainer.addChild(marker);
				firePointMarkers.push(marker);
				fireBulletInfos.push({ marker: marker, pointReference: point });
				marker.addEventListener(MouseEvent.MOUSE_DOWN, mDownBullet);
				stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mMove);
			}
		}
	}

	function createFireMissilePoints()
	{
		for (marker in fireMissilePointMarkers)
		{
			marker.removeEventListener(MouseEvent.MOUSE_DOWN, mDownMissile);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mMove);
			fireMissileMarkerContainer.removeChild(marker);
			marker = null;
		}
		fireMissilePointMarkers = [];
		fireMissileInfos = [];

		if (missileTile != null && missileTile.editorUrl != "")
		{
			for (point in fireMissilePoints)
			{
				var marker:FirePointMarker = new FirePointMarker(missileTile.gameUrl);
				marker.x = point.x;
				marker.y = point.y;
				marker.rotation = -90;
				fireMissileMarkerContainer.addChild(marker);
				fireMissilePointMarkers.push(marker);
				fireMissileInfos.push({ marker: marker, pointReference: point });
				marker.addEventListener(MouseEvent.MOUSE_DOWN, mDownMissile);
				stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mMove);
			}
		}
	}

	private function mMove(e:MouseEvent):Void
	{
		if (activeBulletMarker != null)
		{
			activeBulletMarker.x = Math.round(fireBulletMarkerContainer.mouseX / gridSizeProp.value) * gridSizeProp.value;
			activeBulletMarker.y = Math.round(fireBulletMarkerContainer.mouseY / gridSizeProp.value) * gridSizeProp.value;
		}

		if (activeMissileMarker != null)
		{
			activeMissileMarker.x = Math.round(fireMissileMarkerContainer.mouseX / gridSizeProp.value) * gridSizeProp.value;
			activeMissileMarker.y = Math.round(fireMissileMarkerContainer.mouseY / gridSizeProp.value) * gridSizeProp.value;
		}

		if (activeDecor != null)
		{
			activeDecor.x = Math.round((decorContainer.mouseX - activeDecor.width / 2) / gridSizeProp.value) * gridSizeProp.value;
			activeDecor.y = Math.round((decorContainer.mouseY - activeDecor.height / 2) / gridSizeProp.value) * gridSizeProp.value;

			var data = decorationDatas.get(activeDecor);
			data.point.x = activeDecor.x;
			data.point.y = activeDecor.y;

			updateBindedDecors();
		}
	}

	private function mUp(e:MouseEvent):Void
	{
		if (activeBulletMarker != null)
		{
			if (removeElementArea.hitTestObject(activeBulletMarker))
			{
				for (info in fireBulletInfos)
				{
					if (activeBulletMarker == info.marker)
					{
						firePoints.remove(info.pointReference);
					}
				}
				createFirePoints();

				activeBulletMarker = null;
				return;
			}

			for (i in 0...firePointMarkers.length)
			{
				var marker:FirePointMarker = firePointMarkers[i];
				firePoints[i].x = marker.x;
				firePoints[i].y = marker.y;
			}
			activeBulletMarker = null;
		}
		else if (activeMissileMarker != null)
		{
			if (removeElementArea.hitTestObject(activeMissileMarker))
			{
				for (info in fireMissileInfos)
				{
					if (activeMissileMarker == info.marker)
					{
						fireMissilePoints.remove(info.pointReference);
					}
				}
				createFireMissilePoints();

				activeMissileMarker = null;
				return;
			}

			for (i in 0...fireMissilePointMarkers.length)
			{
				var marker:FirePointMarker = fireMissilePointMarkers[i];
				fireMissilePoints[i].x = marker.x;
				fireMissilePoints[i].y = marker.y;
			}
			activeMissileMarker = null;
		}
		else if (activeDecor != null)
		{
			if (removeElementArea.hitTestObject(activeDecor))
			{
				for (decor in decorations)
				{
					if (activeDecor == decor)
					{
						decorationDatas.remove(activeDecor);
						decorations.remove(activeDecor);
						decorContainer.removeChild(activeDecor);
						updateBindedDecors();
					}
				}

				activeDecor = null;
				return;
			}

			activeDecor = null;
		}
	}

	private function mDownDecor(e:MouseEvent):Void
	{
		activeDecor = cast e.currentTarget;
	}

	private function mDownBullet(e:MouseEvent):Void
	{
		activeBulletMarker = cast e.currentTarget;
	}

	private function mDownMissile(e:MouseEvent):Void
	{
		activeMissileMarker = cast e.currentTarget;
	}
}

typedef FireBulletInfo = {
	var marker:FirePointMarker;
	var pointReference:SimplePoint;
}