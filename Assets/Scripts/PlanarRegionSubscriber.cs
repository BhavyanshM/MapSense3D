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
    private byte[] paramDataBytes;
    private MaterialPropertyBlock matBlock;


    void Start()
    {
        
        // rosConnector = GetComponent<RosConnector>();
        // var subscription_id = rosConnector.RosSocket.Subscribe<map_sense.PlanarRegions>("/map/regions", RegionMsgHandler);
        // paramData0 = new float[20];

        paramData0 = new float[1536];
        dtex = new Texture2D(12, 16, TextureFormat.RGBAFloat, false);
        meshRenderer.material = new Material(Shader.Find("Custom/QuadTessellationHLSL"));
        meshRenderer.material.SetTexture("_MainTex", dtex);


        // paramDataBytes = new byte[paramData.Length*sizeof(float)];
        // dtex = new Texture2D(1, 1, TextureFormat.RGBAFloat, false);


        // meshRenderer.material.SetFloatArray("Params0", paramData0);
        
        string[] lines = System.IO.File.ReadAllLines(@"/home/quantum/catkin_ws/src/map_sense/scripts/patches.csv");
        for (int i = 0; i < paramData0.Length; i++)
        {
            paramData0[i] = float.Parse(lines[i]);
            
        }

        for (int i = 0; i < dtex.width; i++){
            for (int j = 0; j < dtex.height; j++) {
                
                dtex.SetPixel(i%12,i/12, new Color(0.5f,0.7f,0.3f,0.0f));
                
            }
        }
        dtex.Apply();
        meshRenderer.material.SetTexture("_MainTex",dtex);

        
        
        Debug.Log(SystemInfo.SupportsTextureFormat(TextureFormat.RGBAFloat));
        
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

        // int height = 0;
        // for(int i = 1; i<paramData0.Length-1; i++)
        // {
        //     height = i;
        //     paramData0[i] = height;
        //
        // }
        
        for (int i = 0; i < dtex.width; i++){
            for (int j = 0; j < dtex.height; j++) {
                
                dtex.SetPixel(i%12,i/12, new Color(0.5f,0.7f,0.3f,0.0f));
                
            }
        }
        dtex.Apply();
        meshRenderer.material.SetTexture("_MainTex",dtex);
        
        // paramData4[0] += 1;
        // paramData4[0] %= 100;
        //
        // paramData4[191] -= 1;
        // paramData4[191] %= 100;
        
        // Buffer.BlockCopy(paramData,0,paramDataBytes,0,paramDataBytes.Length);
        // dtex.LoadImage(paramDataBytes);
        // dtex.Apply();
        // meshRenderer.material.SetTexture("_MainTex", dtex);
        
        // meshRenderer.material.SetFloatArray("Params0", paramData0);


    }

}
