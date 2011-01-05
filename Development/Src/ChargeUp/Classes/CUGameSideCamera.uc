class CUGameSideCamera extends GameCameraBase
	config(Camera);

var() const protected float DefaultFOV;

var() protected float CamDistance;
var() protected float CamOffset;

	// Set up the location, rotation, and FOV of our camera
simulated function UpdateCamera(Pawn P, GamePlayerCamera CameraActor, float DeltaTime, out TViewTarget OutVT)
{
	local CameraActor CamActor;
	local CUPlayerController PC;

	local float NextY;

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
			// 0 = (0 * DegToRad) * RadToUnrRot
		OutVT.POV.Rotation.Pitch = 0.0f;
		OutVT.POV.Rotation.Roll = 0.0f;
		OutVT.POV.Rotation.Yaw = 0.0f;

		OutVT.POV.Location.X = OutVT.Target.Location.X - 32;
		OutVT.POV.Location.Y = OutVT.Target.Location.Y;
		OutVT.POV.Location.Z = OutVT.Target.Location.Z + 60;

		OutVT.POV.Location = OutVT.POV.Location - Vector(OutVT.POV.Rotation) * CamDistance;

		if (P != None)
		{
			PC = CUPlayerController(P.Controller);

			if (PC != None)
			{
				if (!PC.IsWalkingBackwards)
					NextY = OutVT.POV.Location.Y + CamOffset;
				else
					NextY = OutVT.POV.Location.Y - CamOffset;
				
					// TODO: Interpolate this movement
				OutVT.POV.Location.Y = NextY;
			}
		}
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
	CamDistance = 250.0f
	CamOffset = 100.0f;
}
