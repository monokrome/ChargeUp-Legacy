class CUPlayerController extends UDKPlayerController;

var Bool IsWalkingBackwards; // Are we currently walking backwards?
var bool MovementDirectionChanged; // True when a position change has occured

var float DirectionChangedYawAlpha;
var float DirectionChangedInitialYaw;

var const float DirectionChangedYawRotationSpeed;

/**
 * Limits our pawn from rotating away from looking parellel of our camera
 */
event Rotator LimitViewRotation(Rotator ViewRotation, float ViewPitchMin, float ViewPitchMax)
{
	local float FinalYaw;

	ViewPitchMin = 0;
	ViewPitchMax = 0;

	ViewRotation = super.LimitViewRotation(ViewRotation, ViewPitchMax, ViewPitchMin);

	if (IsWalkingBackwards)
		FinalYaw = 270 * DegToUnrRot;
	else
		FinalYaw = PlayerCamera.Rotation.Yaw + (90 * DegToUnrRot);

	if (MovementDirectionChanged)
	{
		if (DirectionChangedYawAlpha >= 1.0f)
		{
			DirectionChangedYawAlpha = 1.0f;
			MovementDirectionChanged = false;
		}

		ViewRotation.Yaw = Lerp(DirectionChangedInitialYaw, FinalYaw, DirectionChangedYawAlpha);

		DirectionChangedYawAlpha += DirectionChangedYawRotationSpeed;
	}
	else
	{
		ViewRotation.Yaw = FinalYaw;
	}

	return ViewRotation;
}

state PlayerWalking
{
	ignores SeePlayer, HearNoise, Bump;

	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
	{
		local Rotator TempRot;

			// Updates the view pitch on remote clients
		if (ROLE == ROLE_Authority)
			Pawn.SetRemoteViewPitch(Rotation.Pitch);

		Pawn.Acceleration.X = 0;
		Pawn.Acceleration.Y = PlayerInput.aStrafe;
		Pawn.Acceleration.Z = 0;

			// Check if we have changed to walking backwards or not
		if ((PlayerInput.aStrafe < 0 && !IsWalkingBackwards) || (PlayerInput.aStrafe > 0 && IsWalkingBackwards))
		{
			IsWalkingBackwards = !IsWalkingBackwards;
			DirectionChangedInitialYaw = Pawn.Rotation.Yaw;
			DirectionChangedYawAlpha = 0.0f;
			MovementDirectionChanged = true;
		}

		Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);

		TempRot.Pitch = Pawn.Rotation.Pitch;
		TempRot.Roll = 0;

		if (Normal(Pawn.Acceleration) Dot Vect(1,0,0) > 0)
		{
			TempRot.Yaw = 0;
			Pawn.ClientSetRotation(TempRot);
		}
		if (Normal(Pawn.Acceleration) Dot Vect(1,0,0) > 0)
		{
			TempRot.Yaw = 0;
			Pawn.ClientSetRotation(TempRot);
		}

		CheckJumpOrDuck();
	}

	function PlayerMove(float DeltaTime)
	{
		local Vector X, Y, Z, NewAccel;
		local EDoubleClickDir DoubleClickMove;
		local Rotator OldRotation;
		local bool bSaveJump;

		if (Pawn == None)
		{
			GotoState('Dead');
		}
		else
		{
			GetAxes(Pawn.Rotation, X, Y, Z);

			// Update acceleration
			NewAccel = PlayerInput.aForward*X + PlayerInput.aStrafe*Y;
			NewAccel.Z = 0;
			NewAccel = Pawn.AccelRate * Normal(NewAccel);

			DoubleClickMove = PlayerInput.CheckForDoubleClickMove(
				DeltaTime / WorldInfo.TimeDilation
			);

			// Update rotation
			OldRotation = Rotation;
			UpdateRotation(DeltaTime);
			bDoubleJump = false;

			if (bPressedJump && Pawn.CannotJumpNow())
			{
				bSaveJump = true;
				bPressedJump = false;
			}
			else
			{
				bSaveJump = false;
			}

			if (Role < ROLE_Authority)
				ReplicateMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation-Rotation);
			else
				ProcessMove(DeltaTime, NewAccel, DoubleClickMove, OldRotation-Rotation);

			bPressedJump = bSaveJump;
		}
	}
}

DefaultProperties
{
	CameraClass = class'CUCamera'
	DirectionChangedYawRotationSpeed = 0.15f
}
