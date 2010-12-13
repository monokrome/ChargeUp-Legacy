class CUPlayerController extends UTPlayerController;

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
		Pawn.Acceleration.Y = 1 * PlayerInput.aStrafe;
		Pawn.Acceleration.Z = 0;

		// Pawn.Acceleration.Y = Pawn.AccelRate * Normal(Pawn.Acceleration);

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
}
