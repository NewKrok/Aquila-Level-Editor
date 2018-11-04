package aquila;

/**
 * ...
 * @author Krisztian Somoracz
 */
class StartGameAction extends BaseAction
{
	public function new()
	{
		super("img/action_header_start.png");

		label.text = "START GAME";
	}

	override function build()
	{
		super.build();

		background.buttonMode = false;
	}
}