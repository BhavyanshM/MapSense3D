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
    //private GameObject pointMap;
    public MeshRenderer renderer;

    public ComputeBuffer cb_params;



    // Start is called before the first frame update
    void Start()
    {
        rosConnector = GetComponent<RosConnector>();
        string subscription_id = rosConnector.RosSocket.Subscribe<map_sense.PlanarRegions>("/map/regions", RegionMsgHandler);
        
        cb_params = new ComputeBuffer(1536, sizeof(float));
        renderer = GameObject.FindWithTag("QuadMap").GetComponent<MeshRenderer>();
        renderer.material.SetBuffer("params", cb_params);
        // cb_params.Release();
        Debug.Log("Subscribed:"+subscription_id);   
    } 

    private void RegionMsgHandler(map_sense.PlanarRegions message)
    {
        Debug.Log(message.data.Length);
    	cb_params.SetData(message.data);

        // ImageConversion.LoadImage(dtex, msgData);
        // renderer.material.SetTexture("_MainTex", dtex);

    }

    void OnDestroy() {
        cb_params.Release();
    }


}
