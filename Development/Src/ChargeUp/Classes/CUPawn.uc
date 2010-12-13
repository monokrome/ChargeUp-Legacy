class CUPawn extends UTPawn
	Config(ChargeUp);

simulated function name GetDefaultCameraMode(PlayerController Requestedby)
{
	return 'Side';
}

simulated event PostBeginPlay()
{
}

defaultproperties
{
}
