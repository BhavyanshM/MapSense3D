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

    // Start is called before the first frame update
    void Start()
    {
        rosConnector = GetComponent<RosConnector>();
        string subscription_id = rosConnector.RosSocket.Subscribe<sensor.CompressedImage>("/map/regions", RegionMsgHandler);
        Debug.Log("Subscribed:"+subscription_id);
    }

    private static void RegionMsgHandler(sensor.CompressedImage message)
    {
    	// for(int i = 0; i<10; i++)
        	Debug.Log(message.header.seq);
    }


}
