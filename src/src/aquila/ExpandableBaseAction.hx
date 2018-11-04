package aquila;

import com.greensock.TweenMax;
import aquila.ActionMenu;
import aquila.ActionSelector;
import aquila.ActionSubContent;
import hpp.openfl.ui.BaseButton;
import hpp.openfl.ui.VUIBox;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.geom.Point;

/**
 * ...
 * @author Krisztian Somoracz
 */
class ExpandableBaseAction extends BaseAction
{
	var actionSubContentWrapper:Sprite;
	var actionSubContent:Sprite;
	var subContainer:VUIBox;
	var expandButton:BaseButton;
	var openActionSelector:ExpandableBaseAction->Void;
	var updateContainer:Void->Void;
	var upRequest:BaseAction->Void;
	var downRequest:BaseAction->Void;
	var duplicateRequest:BaseAction->Void;
	var removeRequest:BaseAction->Void;

	public function new(openActionSelector:ExpandableBaseAction->Void, updateContainer:Void->Void, upRequest:BaseAction->Void, downRequest:BaseAction->Void, duplicateRequest:BaseAction->Void, removeRequest:BaseAction->Void)
	{
		super();

		this.updateContainer = updateContainer;
		this.openActionSelector = openActionSelector;
		this.updateContainer = updateContainer;
		this.upRequest = upRequest;
		this.downRequest = downRequest;
		this.duplicateRequest = duplicateRequest;
		this.removeRequest = removeRequest;

		subContainer = new VUIBox();

		actionSubContentWrapper = new Sprite();
		actionSubContentWrapper.addChild(actionSubContent = new ActionSubContent());
		actionSubContent.x = 10;
		actionSubContent.y = 10;
		subContainer.addChild(actionSubContentWrapper);
		subContainer.addChild(
			new ActionMenu(
				function() { upRequest(this); },
				function() { downRequest(this); },
				function() { duplicateRequest(this); },
				function() { removeRequest(this); }
			)
		);

		title.addChild(expandButton = new BaseButton(
			toggleExpand,
			"",
			new Bitmap(Assets.getBitmapData("img/expand_arrow.png")),
			new Bitmap(Assets.getBitmapData("img/expand_arrow_over.png"))
		));
		expandButton.x = title.width - expandButton.width;

		constructed();
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
			rePosition();
		}
	}

	override function onClick()
	{
		if (subContainer.parent != null) toggleExpand(null);
		openActionSelector(this);
	}

	function constructed() {}
}