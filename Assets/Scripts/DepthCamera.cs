using System.IO; 
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class DepthCamera : MonoBehaviour
{
	public Material mat;
	public bool saved = false;
	public Texture2D depthTexture;
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    // Update is called once per frame
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
    	// Graphics.Blit(source, destination, mat); 
        // Debug.Log("RT_Width:" + rentex.width + "\tRT_Height:" + rentex.height);
        // if(saved == false){
        	// Debug.Log("SAVED_PNG_Texture2D");
        	// RenderTexture rentex = new RenderTexture(Camera.main.pixelWidth, Camera.main.pixelHeight, 24);
        	// Graphics.Blit(source, rentex, mat); 
        	// depthTexture = toTexture2D(rentex); 
        	// saved = true;
        	// byte[] bytes = depthTexture.EncodeToPNG();
        	// File.WriteAllBytes(Application.dataPath + "/my_file.png", bytes);
        // }
        // Debug.Log("Width:" + Camera.main.pixelWidth + "\tHeight:" + Camera.main.pixelHeight); 
    }

    Texture2D toTexture2D(RenderTexture rTex){

	    Texture2D tex = new Texture2D(rTex.width, rTex.height, TextureFormat.RGB24, false);
	    RenderTexture.active = rTex;
	    tex.ReadPixels(new Rect(0, 0, rTex.width, rTex.height), 0, 0);
	    tex.Apply();
	    return tex;
	}
}
