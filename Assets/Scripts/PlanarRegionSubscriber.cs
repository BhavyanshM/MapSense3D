using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
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

    private float[] paramData0;
    private float[] paramData1;
    private float[] paramData2;
    private float[] paramData3;
    private float[] paramData4;
    private float[] paramData5;
    private float[] paramData6;
    private float[] paramData7;
    
    private byte[] paramDataBytes;
    private MaterialPropertyBlock matBlock;


    void Start()
    {
        rosConnector = GetComponent<RosConnector>();
        var subscription_id = rosConnector.RosSocket.Subscribe<map_sense.PlanarRegions>("/map/regions", RegionMsgHandler);
        paramData0 = new float[192];
        paramData1 = new float[192];
        paramData2 = new float[192];
        paramData3 = new float[192];
        paramData4 = new float[192];
        paramData5 = new float[192];
        paramData6 = new float[192];
        paramData7 = new float[192];

        meshRenderer.material = new Material(Shader.Find("Custom/QuadTessellationHLSL"));
        
        // paramDataBytes = new byte[paramData.Length*sizeof(float)];
        // dtex = new Texture2D(1, 1, TextureFormat.RGBAFloat, false);
        
        // meshRenderer.material.SetTexture("_MainTex", dtex);
        meshRenderer.material.SetFloatArray("Params0", paramData0);
        meshRenderer.material.SetFloatArray("Params1", paramData1);
        meshRenderer.material.SetFloatArray("Params2", paramData2);
        meshRenderer.material.SetFloatArray("Params3", paramData3);
        meshRenderer.material.SetFloatArray("Params4", paramData4);
        meshRenderer.material.SetFloatArray("Params5", paramData5);
        meshRenderer.material.SetFloatArray("Params6", paramData6);
        meshRenderer.material.SetFloatArray("Params7", paramData7);
    } 

    private void RegionMsgHandler(map_sense.PlanarRegions message)
    {
        // Debug.Log(message.data.Length);

        // for(int i = 0; i<paramData.Length; i++){
        // 	// paramData[i] = message.data[i];
        //     paramData[i] = i;
        //     paramData1[i] = i * i;
        //     // if(i<8){
        //     // 	Debug.LogFormat("Number: {0} ",paramData[i]);
        //     // }
        // }
    }
    void Update()
    {

        // int id = 6;
        //
        // paramData0[id] += 1;
        // paramData0[id] %= 100;
        //
        // paramData1[id] += 4;
        // paramData1[id] %= 400;
        //
        // paramData2[id] += 6;
        // paramData2[id] %= 600;
        //
        // paramData3[id] += 8;
        // paramData3[id] %= 800;
        //
        // paramData4[id] += 10;
        // paramData4[id] %= 1000;
        //
        // paramData5[id] += 12;
        // paramData5[id] %= 1200;
        //
        // paramData6[id] += 3;
        // paramData6[id] %= 1400;
        //
        // paramData7[id] += 2;
        // paramData7[id] %= 1600;

        int height = 0;
        for(int i = 0; i<paramData0.Length; i++)
        {
            height = i;
            paramData0[i] = height;
            paramData1[i] = height;
            paramData2[i] = height;
            paramData3[i] = height;
            paramData4[i] = height;
            paramData5[i] = height;
            paramData6[i] = height;
            paramData7[i] = height;
        }
        
        // paramData4[0] += 1;
        // paramData4[0] %= 100;
        //
        // paramData4[191] -= 1;
        // paramData4[191] %= 100;
        
        // Buffer.BlockCopy(paramData,0,paramDataBytes,0,paramDataBytes.Length);
        // dtex.LoadImage(paramDataBytes);
        // dtex.Apply();
        // meshRenderer.material.SetTexture("_MainTex", dtex);
        
        meshRenderer.material.SetFloatArray("Params0", paramData0);
        meshRenderer.material.SetFloatArray("Params1", paramData1);
        meshRenderer.material.SetFloatArray("Params2", paramData2);
        meshRenderer.material.SetFloatArray("Params3", paramData3);
        meshRenderer.material.SetFloatArray("Params4", paramData4);
        meshRenderer.material.SetFloatArray("Params5", paramData5);
        meshRenderer.material.SetFloatArray("Params6", paramData6);
        meshRenderer.material.SetFloatArray("Params7", paramData7);


    }

}
