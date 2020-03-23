using UnityEngine;
using System;

public class CamNavigator : MonoBehaviour
{

	protected Transform CamTF;
	protected Transform CamParentTF;

	protected Vector3 LocalRotation;
	protected Vector3 LocalTranslation;
	protected float CamDistance = 50f;

	private float SideShiftSensitivity = 1f;
	private float ForwardShiftSensitivity = 1.5f;
	private float UpShiftSensitivity = 0.1f;
	private float MouseSensitivity = 3f;
	private float ScrollSensitivity = 10f;
	private float OrbitDampening = 10f;
	private float ScrollDampening = 8f;
	private float ClipDistance = 250f;

	public bool CameraDisabled = false;

	public Renderer sphereRenderer;

    // Start is called before the first frame update
    void Start()
    {
    	sphereRenderer.enabled = false;
        this.CamTF = this.transform;
        this.CamParentTF = this.transform.parent;
    }

    // Late Update is called after all object updates
    void LateUpdate()
    {
        if(Input.GetKeyDown(KeyCode.LeftShift)){
        	CameraDisabled = !CameraDisabled;
        }

        if(Input.GetKeyDown(KeyCode.Z)){
        	this.CamParentTF.position = new Vector3(0,0,0);
        }

        if(!CameraDisabled){
        	if((Input.GetAxis("Mouse X") != 0 || Input.GetAxis("Mouse Y") != 0) && Input.GetMouseButton(0)){
        		sphereRenderer.enabled = true;
        		LocalRotation.x += Input.GetAxis("Mouse X") * MouseSensitivity;
        		LocalRotation.y += -Input.GetAxis("Mouse Y") * MouseSensitivity;
        	}

        	if((Input.GetAxis("Mouse X") != 0 || Input.GetAxis("Mouse Y") != 0) && Input.GetMouseButton(1)){
        		sphereRenderer.enabled = true;
        		LocalTranslation.x = Input.GetAxis("Mouse X") * MouseSensitivity;
        		LocalTranslation.y = Input.GetAxis("Mouse Y") * MouseSensitivity;
        		Vector3 rt = Vector3.right;
        		Vector3 fwd = transform.TransformVector(rt);
        		Vector3 perp = new Vector3(fwd.z, 0, -fwd.x);
        		this.CamParentTF.Translate(-rt * LocalTranslation.x * SideShiftSensitivity * Time.deltaTime);
        		this.CamParentTF.Translate(perp * LocalTranslation.y * Time.deltaTime * ForwardShiftSensitivity, Space.World);
        	}

        	if(Input.GetKey(KeyCode.Mouse2)){
        		sphereRenderer.enabled = true;
        		LocalTranslation.z = -Input.GetAxis("Mouse Y") * MouseSensitivity;
        		this.CamParentTF.Translate(Vector3.up * LocalTranslation.z * UpShiftSensitivity, Space.World);
        	}

        	if(Input.GetAxis("Mouse ScrollWheel") != 0){
        		float ScrollAmount = Input.GetAxis("Mouse ScrollWheel") * ScrollSensitivity;
        		ScrollAmount *= (this.CamDistance * 0.3f);
        		this.CamDistance += ScrollAmount * -1f;
        		this.CamDistance = Mathf.Clamp(this.CamDistance, 1.5f, ClipDistance);
        	}

        	if(Input.GetMouseButtonUp(0) || Input.GetMouseButtonUp(1) || Input.GetKeyUp(KeyCode.Mouse2)){
        		sphereRenderer.enabled = false;
        	}
        }

        Quaternion QT = Quaternion.Euler(LocalRotation.y, LocalRotation.x, 0);
        this.CamParentTF.rotation = Quaternion.Lerp(this.CamParentTF.rotation, QT, Time.deltaTime * OrbitDampening);


        if(this.CamTF.localPosition.z != this.CamDistance * -10f){
        	this.CamTF.localPosition = new Vector3(0f, 0f, Mathf.Lerp(this.CamTF.localPosition.z, this.CamDistance * -1f, Time.deltaTime * ScrollDampening));
        }
    }
}
