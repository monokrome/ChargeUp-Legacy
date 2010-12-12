class CUGameSideCamera extends GameCameraBase
	config(Camera);

var() const protected float DefaultFOV;

	// Set up the location, rotation, and FOV of our camera
simulated function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
	local CameraActor CamActor;

		// Results in None if OutVT.Target isn't a CameraActor object.
	CamActor = CameraActor(OutVT.Target);

		// Use the CamActor angle if one exists.
	if (CamActor != None)
		OutVT.POV.FOV = CamActor.FOVAngle;
	else
		OutVT.POV.FOV = DefaultFOV;

		// Use the location of our target if it exists
	if (OutVT.Target != None)
	{
		OutVT.POV.Location = CameraActor.Location;
		OutVT.POV.Rotation = CameraActor.Rotation;
	}

		// Set up camera
	PlayerCamera.ApplyCameraModifiers(DeltaTime, OutVT.POV);
	bResetCameraInterpolation = FALSE;
}

	// Temporarily disables interpolation when switching to this camera
function OnBecomeActive(GameCameraBase OldCamera)
{
	bResetCameraInterpolation = TRUE;
	super.OnBecomeActive(OldCamera);
}

DefaultProperties
{
	DefaultFOV = 90
}
