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
    private Texture2D dtex;
    public MeshRenderer meshRenderer;

    private float[] paramData; 
    private MaterialPropertyBlock matBlock;


    void Start()
    {
        rosConnector = GetComponent<RosConnector>();
        string subscription_id = rosConnector.RosSocket.Subscribe<map_sense.PlanarRegions>("/map/regions", RegionMsgHandler);
        paramData = new float[504];
        meshRenderer.material = new Material(Shader.Find("Custom/QuadTessellationHLSL"));

        meshRenderer.material.SetFloatArray("Params", paramData);	
        meshRenderer.material.SetFloatArray("Params1", paramData);	
    } 

    private void RegionMsgHandler(map_sense.PlanarRegions message)
    {
        // Debug.Log(message.data.Length);

        for(int i = 0; i<paramData.Length; i++){
        	paramData[i] = message.data[i];
        	// if(i<8){
        	// 	Debug.LogFormat("Number: {0} ",paramData[i]);
        	// }

        }



    }
    void Update(){

        // paramData[0] += 1;
        // paramData[0] %= 100;
        meshRenderer.material.SetFloatArray("Params", paramData);
        meshRenderer.material.SetFloatArray("Params1", paramData);


    }

}
