class CUGame extends UTGame;

static event class<GameInfo> SetGameType(String MapName, String Options, String Portal)
{
	return default.class;
}

DefaultProperties
{
	bDelayedStart = false
	PlayerControllerClass = class'CUPlayerController'
	DefaultPawnClass = class'CUPawn'

	Name = "Charge Up!"
}
