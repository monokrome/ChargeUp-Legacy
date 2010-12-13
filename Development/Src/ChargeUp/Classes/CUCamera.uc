class CUCamera extends Camera
	config(Camera);

function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local Vector Loc, Pos, HitLocation, HitNormal;
	local Rotator Rot;
	local Actor HitActor;
	local CameraActor CamActor;
	local bool bDoNotApplyModifiers;
	local TPOV OrigPOV;

	OrigPOV = OutVT.POV;
	OutVT.POV.FOV = DefaultFOV;

		// Check if we are using a fixed camera. If we are, then get it's view.
	CamActor = CameraActor(OutVT.Target);
	if (CamActor != None)
	{
		CamActor.GetCameraView(DeltaTime, OutVT.POV);
		bConstrainAspectRatio = bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
		CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
		CamPostProcessSettings = CamActor.CamOverridePostProcess;
	}
	else
	{
		// Let the pawn viewtarget dictate the camera position
		if (Pawn(OutVT.Target) == None || !Pawn(OutVT.Target).CalcCamera(DeltaTime, OutVT.POV.Location, OutVT.POV.Rotation, OutVT.POV.FOV))
		{
			bDoNotApplyModifiers = false;

			// Temporary.
			if (CameraStyle == '')
				CameraStyle = 'Side';

			switch (CameraStyle)
			{
			case 'Fixed':
				OutVT.POV = OrigPOV;
				break;

			case 'ThirdPerson':
			case 'FreeCam':
			case 'FreeCam_Default':
				Loc = OutVT.Target.Location;
				Rot = OutVT.Target.Rotation;

				if (CameraStyle == 'FreeCam' || CameraStyle == 'FreeCam_Default')
					Rot = PCOwner.Rotation;

				Loc += FreeCamOffset;

				Pos = Loc - Vector(Rot) * FreeCamDistance;

				HitActor = Trace(HitLocation, HitNormal, Pos, Loc, FALSE, vect(12,12,12));

				OutVT.POV.Location = (HitActor == none) ? Pos : HitLocation;
				OutVT.POV.Rotation = Rot;
				break;


			case 'FirstPerson':
				OutVT.Target.GetActorEyesViewPoint(OutVT.POV.Location, OutVT.POV.Rotation);
				break;

			case 'Side':
				Rot.Pitch = (0 * DegToRad) * RadToUnrRot;
				Rot.Roll = Rot.Pitch;
				Rot.Yaw = Rot.Roll;

				Loc.X = PCOwner.Pawn.Location.X; //- 32
				Loc.Y = PCOwner.Pawn.Location.Y + 40;
				Loc.Z = PCOwner.Pawn.Location.Z + 50;

				Pos = Loc - Vector(Rot) * FreeCamDistance;

				OutVT.POV.Location = Pos;
				OutVT.POV.Rotation = Rot;

			default:
				break;
			}
		}
	}

	if (!bDoNotApplyModifiers)
		ApplyCameraModifiers(DeltaTime, OutVT.POV);
}

defaultproperties
{
	DefaultFOV = 90.0f;
}
