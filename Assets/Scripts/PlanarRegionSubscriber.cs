using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using map_sense = RosSharp.RosBridgeClient.MessageTypes.MapSense;
using sensor = RosSharp.RosBridgeClient.MessageTypes.Sensor;
using RosSharp.RosBridgeClient;

[RequireComponent(typeof(RosConnector))]
public class PlanarRegionSubscriber : MonoBehaviour
{
	private RosConnector rosConnector;
    private byte[] msgData;
    private Texture2D dtex;
    //private GameObject pointMap;
    private MeshRenderer renderer;



    // Start is called before the first frame update
    void Start()
    {
        rosConnector = GetComponent<RosConnector>();
        string subscription_id = rosConnector.RosSocket.Subscribe<sensor.CompressedImage>("/map/regions", RegionMsgHandler);
        
        renderer = GameObject.FindWithTag("PointMap").GetComponent<MeshRenderer>();
        dtex = new Texture2D(64,48);
        renderer.material = new Material(Shader.Find("Custom/CurveShader"));

        Debug.Log("Subscribed:"+subscription_id);
    } 

    private void RegionMsgHandler(sensor.CompressedImage message)
    {
    	msgData = message.data;
        ImageConversion.LoadImage(dtex, msgData);
        renderer.material.SetTexture("_MainTex", dtex);
        Debug.Log(msgData.Length);

    }


}
