class CUCamera extends GamePlayerCamera
	config(Camera);

/** Implements a typical side-scrolling camera. */
var(Camera) editinline transient GameCameraBase			SideCam;
/** Class to use for side-scrolling camera. */
var(Camera) protected const  class<GameCameraBase>      SideCameraClass;

	// Create our side-scrolling camera
function PostBeginPlay()
{
	super.PostBeginPlay();

	if ((SideCam == None) && (SideCameraClass != None))
		SideCam = CreateCamera(SideCameraClass);
}

protected function GameCameraBase FindBestCameraType(Actor CameraTarget)
{
 	local GameCameraBase BestCam;

	if (CameraStyle == 'Side')
	{
		BestCam = SideCam;
	}

 	else if (CameraStyle == 'default')
	{
		if (CameraActor(CameraTarget) != None)
			BestCam = FixedCam;
		else 
			BestCam = SideCam;
	}

	return BestCam;
}

defaultproperties
{
	SideCameraClass = class'CUGameSideCamera'
	DefaultFOV = 90.0f;
}
