class CUGameSideCamera extends GameCameraBase
	config(Camera);

var() const protected float DefaultFOV;

var() protected float CamDistance;

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
		OutVT.POV.Rotation.Pitch = (0 * DegToRad) * RadToUnrRot;
		OutVT.POV.Rotation.Roll = OutVT.POV.Rotation.Pitch;
		OutVT.POV.Rotation.Yaw = OutVT.POV.Rotation.Pitch;

		OutVT.POV.Location.X = OutVT.Target.Location.X; //- 32
		OutVT.POV.Location.Y = OutVT.Target.Location.Y + 40;
		OutVT.POV.Location.Z = OutVT.Target.Location.Z + 50;

		OutVT.POV.Location = OutVT.POV.Location - Vector(OutVT.POV.Rotation) * CamDistance;
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
	CamDistance = 200.0f
}
