using UnityEngine;
using System;

public class CamNavigator : MonoBehaviour
{

	protected Transform CamTF;
	protected Transform CamParentTF;

	protected Vector3 LocalRotation;
	protected Vector3 LocalTranslation;
	protected float CamDistance = 10f;

	public float shiftSensitivity = 0.05f;
	public float MouseSensitivity = 4f;
	public float ScrollSensitivity = 2f;
	public float OrbitDampening = 10f;
	public float ScrollDampening = 5f;

	public bool CameraDisabled = false;

    // Start is called before the first frame update
    void Start()
    {
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
        		LocalRotation.x += Input.GetAxis("Mouse X") * MouseSensitivity;
        		LocalRotation.y += -Input.GetAxis("Mouse Y") * MouseSensitivity;
        	}

        	if((Input.GetAxis("Mouse X") != 0 || Input.GetAxis("Mouse Y") != 0) && Input.GetMouseButton(1)){
        		LocalTranslation.x = Input.GetAxis("Mouse X") * MouseSensitivity;
        		LocalTranslation.y = Input.GetAxis("Mouse Y") * MouseSensitivity;
        		this.CamParentTF.position += new Vector3(Mathf.Cos(this.CamParentTF.rotation.x) * LocalTranslation.x * shiftSensitivity * Time.deltaTime,
        												 0, 
        												 Mathf.Sin(this.CamParentTF.rotation.x) * LocalTranslation.y * shiftSensitivity * Time.deltaTime);
        	}

        	if(Input.GetAxis("Mouse ScrollWheel") != 0){
        		float ScrollAmount = Input.GetAxis("Mouse ScrollWheel") * ScrollSensitivity;
        		ScrollAmount *= (this.CamDistance * 0.3f);
        		this.CamDistance += ScrollAmount * -1f;
        		this.CamDistance = Mathf.Clamp(this.CamDistance, 1.5f, 100f);
        	}
        }

        Quaternion QT = Quaternion.Euler(LocalRotation.y, LocalRotation.x, 0);
        this.CamParentTF.rotation = Quaternion.Lerp(this.CamParentTF.rotation, QT, Time.deltaTime * OrbitDampening);


        if(this.CamTF.localPosition.z != this.CamDistance * -1f){
        	this.CamTF.localPosition = new Vector3(0f, 0f, Mathf.Lerp(this.CamTF.localPosition.z, this.CamDistance * -1f, Time.deltaTime * ScrollDampening));
        }
    }
}
