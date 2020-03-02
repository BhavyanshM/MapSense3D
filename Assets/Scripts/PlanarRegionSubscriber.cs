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
    private float[] msgData;
    private Texture2D dtex;
    //private GameObject pointMap;
    private MeshRenderer renderer;
    private MaterialPropertyBlock matProp;


    // Start is called before the first frame update
    void Start()
    {
        rosConnector = GetComponent<RosConnector>();
        string subscription_id = rosConnector.RosSocket.Subscribe<map_sense.PlanarRegions>("/map/regions/temp", RegionMsgHandler);
        
        renderer = GameObject.FindWithTag("CurvedRegions").GetComponent<MeshRenderer>();
        // dtex = new Texture2D(64,48);
        // renderer.material = new Material(Shader.Find("Custom/CurveShader"));

        var matProp = new MaterialPropertyBlock();
        renderer.SetPropertyBlock(matProp);


        Debug.Log("Subscribed:"+subscription_id);
    } 

    private void RegionMsgHandler(map_sense.PlanarRegions message)
    {
    	msgData = message.data;
        matProp.SetFloatArray("regions", msgData);
        // renderer.SetPropertyBlock(matProp);

        // Debug.LogFormat("{0},{1},{2},{3},{4},{5},{6},{7}", msgData[0],msgData[1],msgData[2],msgData[3],msgData[4],msgData[5],msgData[6],msgData[7]);
        // Debug.Log("Handler");
        // Debug.Log(msgData.Length);
    }


}
