package aquila;

/**
 * ...
 * @author Krisztian Somoracz
 */
class EndGameAction extends BaseAction
{
	public function new()
	{
		super("img/action_header_end.png");

		label.text = "END GAME";
	}

	override function build()
	{
		super.build();

		background.buttonMode = false;
	}
}