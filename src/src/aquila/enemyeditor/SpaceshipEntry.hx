package aquila.enemyeditor;

import aquila.ActionMenu;
import aquila.ActionSubContent;
import com.greensock.TweenMax;
import aquila.ui.BaseEntry;
import aquila.ui.TilePreview;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.HUIBox;
import hpp.openfl.ui.VUIBox;
import hpp.ui.HAlign;
import hpp.util.GeomUtil.SimplePoint;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import aquila.config.TileConfigs;
import aquila.config.SpaceshipConfigs;

/**
 * ...
 * @author Krisztian Somoracz
 */
class SpaceshipEntry extends BaseEntry
{
	public var config:SpaceshipConfig = aquila.config.SpaceshipConfigs.getEmpty();

	var labelHolder:VUIBox;
	var spaceshipPreview:TilePreview;

	public var onSelected:SpaceshipEntry->Void;

	var actionSubContentWrapper:Sprite;
	var actionSubContent:Sprite;
	var subContainer:VUIBox;
	var addEntryInstant:SpaceshipEntry->Void;
	var updateContainer:Void->Void;
	var upRequest:SpaceshipEntry->Void;
	var downRequest:SpaceshipEntry->Void;
	var duplicateRequest:SpaceshipEntry->Void;
	var removeRequest:SpaceshipEntry->Void;

	var nameLabel:TextField;

	public function new(
		config:SpaceshipConfig,
		addEntryInstant:SpaceshipEntry->Void,
		updateContainer:Void->Void,
		upRequest:SpaceshipEntry->Void,
		downRequest:SpaceshipEntry->Void,
		duplicateRequest:SpaceshipEntry->Void,
		removeRequest:SpaceshipEntry->Void
	){
		super("img/enemy_entry_icon.png", "img/enemy_entry_icon_selected.png", { x: 350, y: 45 });

		this.config = config;

		background.isSelectable = true;
		onToggleExpand = toggleExpand;
		onAddEntry = function(_) { addEntryInstant(this); };

		var entryContainer:HUIBox = new HUIBox(5);

		spaceshipPreview = new TilePreview(null, { editorUrl: config.tile, gameUrl: "" }, { x: 45, y: 45 });
		entryContainer.addChild(spaceshipPreview);

		labelHolder = new VUIBox(-2, HAlign.LEFT);

		nameLabel = new TextField();
		nameLabel.defaultTextFormat = new TextFormat("Verdana", 15, 0x000000, true);
		nameLabel.text = "W";
		nameLabel.autoSize = "left";
		nameLabel.selectable = false;
		nameLabel.mouseEnabled = false;
		labelHolder.addChild(nameLabel);

		var idLabel:TextField = new TextField();
		idLabel.defaultTextFormat = new TextFormat("Verdana", 12, 0xFFFFFF);
		idLabel.text = config.id;
		idLabel.autoSize = "left";
		idLabel.selectable = false;
		idLabel.mouseEnabled = false;
		labelHolder.addChild(idLabel);

		labelHolder.x = spaceshipPreview.x + spaceshipPreview.width + 5;
		labelHolder.y = background.height / 2 - labelHolder.height / 2;

		entryContainer.addChild(labelHolder);
		content.addChild(entryContainer);

		this.addEntryInstant = addEntryInstant;
		this.updateContainer = updateContainer;
		this.upRequest = upRequest;
		this.downRequest = downRequest;
		this.duplicateRequest = duplicateRequest;
		this.removeRequest = removeRequest;

		subContainer = new VUIBox();

		actionSubContentWrapper = new Sprite();
		actionSubContentWrapper.addChild(actionSubContent = new ActionSubContent());
		subContainer.addChild(actionSubContentWrapper);
		subContainer.addChild(
			new ActionMenu(
				function() { upRequest(this); },
				function() { downRequest(this); },
				function() { duplicateRequest(this); },
				function() { removeRequest(this); }
			)
		);

		subContainer.rePosition();

		constructed();
		update();
	}

	function toggleExpand(target:BaseButton)
	{
		expandButton.scaleY = -expandButton.scaleY;
		expandButton.y = expandButton.scaleY == 1 ? 0 : expandButton.height;

		if (subContainer.parent == null)
		{
			addChild(subContainer);
			subContainer.alpha = 0;
			TweenMax.killTweensOf(subContainer);
			TweenMax.to(subContainer, .5, { set_alpha: 1 });
		}
		else
		{
			removeChild(subContainer);
		}
		updateContainer();
	}

	override function update()
	{
		if (actionSubContentWrapper != null)
		{
			actionSubContentWrapper.graphics.beginFill(0x555555);
			actionSubContentWrapper.graphics.drawRect(0, 0, width, actionSubContent.height + 20);
			actionSubContentWrapper.graphics.endFill();

			subContainer.rePosition();
		}

		nameLabel.text = config.name;
		labelHolder.rePosition();

		if (spaceshipPreview.config.editorUrl != config.tile) spaceshipPreview.config = { editorUrl: config.tile, gameUrl: "" };
	}

	override function onClick()
	{
		background.isSelected = true;
		isSelected = true;
		nameLabel.textColor = 0x00FF00;
		onSelected(this);
	}

	override public function deSelect():Void
	{
		isSelected = false;
		nameLabel.textColor = 0x000000;
		background.isSelected = false;
	}

	function constructed() {}

	override public function clone():SpaceshipEntry
	{
		var clone:SpaceshipEntry = new SpaceshipEntry(
			aquila.config.SpaceshipConfigs.clone(config),
			addEntryInstant,
			updateContainer,
			upRequest,
			downRequest,
			duplicateRequest,
			removeRequest
		);

		return clone;
	}
}