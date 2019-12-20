using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using map_sense = RosSharp.RosBridgeClient.MessageTypes.MapSense;
using RosSharp.RosBridgeClient;

[RequireComponent(typeof(RosConnector))]
public class PlanarRegionSubscriber : MonoBehaviour
{
	private RosConnector rosConnector;

    // Start is called before the first frame update
    void Start()
    {
        rosConnector = GetComponent<RosConnector>();
        string subscription_id = rosConnector.RosSocket.Subscribe<map_sense.PlanarRegion>("/planar_regions", PlaneMsgHandler);
        Debug.Log("Subscribed:"+subscription_id);
    }

    private static void PlaneMsgHandler(map_sense.PlanarRegion message)
    {
    	// for(int i = 0; i<10; i++)
     //    	Debug.Log(message.polygon.polygon.points[i].x + " " + message.polygon.polygon.points[i].y + " " + message.polygon.polygon.points[i].z);
    }


}
