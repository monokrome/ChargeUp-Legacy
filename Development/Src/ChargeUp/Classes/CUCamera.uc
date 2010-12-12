class CUCamera extends GamePlayerCamera
	config(Camera);

/* Represents the camera to use in side-scrolling mode. */
var(Camera) editinline transient GameCameraBase SideCam;
/* Class to use for side-scrolling camera. */
var(Camera) protected const class<GameCameraBase> SideCameraClass;

function PostBeginPlay()
{
	super.PostBeginPlay();

	if ((SideCam == None) && (SideCameraClass != None))
		SideCam = CreateCamera(SideCameraClass);
}

function FindBestCameraType(Actor CameraTarget)
{
	local GameCameraBase BestChoice;

		// If our target is a camera actor, use the fixed camera
	if (CameraActor(CameraTarget) != None)
		BestChoice = FixedCam;

	// TODO: Use some sort of hinting (CamVolume?) to switch between camera types.

		// Revert to SideCam if no hints supplied a match.
	if (BestChoice == None)
		BestChoice = SideCam;

	return BestChoice;
}

DefaultProperties
{
	SideCameraClass = class'CUGameSideCamera';
}
