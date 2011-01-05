class CUPawn extends UTPawn
	Config(ChargeUp);

/**
 * Get the default type of camera to use when controlling this pawn.
 */
simulated function name GetDefaultCameraMode(PlayerController Requestedby)
{
	return 'Side';
}

defaultproperties
{
}
