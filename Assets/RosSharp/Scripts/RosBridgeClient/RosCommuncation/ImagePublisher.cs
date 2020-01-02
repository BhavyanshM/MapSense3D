/*
© CentraleSupelec, 2017
Author: Dr. Jeremy Fix (jeremy.fix@centralesupelec.fr)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
<http://www.apache.org/licenses/LICENSE-2.0>.
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Adjustments to new Publication Timing and Execution Framework 
// © Siemens AG, 2018, Dr. Martin Bischoff (martin.bischoff@siemens.com)

using UnityEngine;
using UnityEngine.Rendering;
using Unity.Collections;

namespace RosSharp.RosBridgeClient
{
    public class ImagePublisher : UnityPublisher<MessageTypes.Sensor.CompressedImage>
    {
        public Camera ImageCamera;
        public string FrameId = "Camera";
        public int resolutionWidth = 1024;
        public int resolutionHeight = 768;
        [Range(0, 100)]
        public int qualityLevel = 80;

        public Material dmat;

        private MessageTypes.Sensor.CompressedImage message;
        private Texture2D texture2D;
        private Rect rect;
        private RenderTexture rTex;

        protected override void Start()
        {
            // ImageCamera.pixelRect = new Rect(0,0,resolutionWidth,resolutionHeight);
            ImageCamera.depthTextureMode = DepthTextureMode.Depth;
            base.Start();
            InitializeGameObject();
            InitializeMessage();
            Camera.onPostRender += UpdateImage;
        }

        private void UpdateImage(Camera _camera)
        {
            if (texture2D != null && _camera == this.ImageCamera)
                UpdateMessage();
        }

        private void InitializeGameObject()
        {
            texture2D = new Texture2D(resolutionWidth, resolutionHeight, TextureFormat.RGB24, false);
            rect = new Rect(0, 0, resolutionWidth, resolutionHeight);
            ImageCamera.targetTexture = new RenderTexture(resolutionWidth, resolutionHeight, 24);
            rTex = new RenderTexture(resolutionWidth, resolutionHeight, 24);
        }

        private void InitializeMessage()
        {
            message = new MessageTypes.Sensor.CompressedImage();
            message.header.frame_id = FrameId;
            message.format = "png";
        }

        private void UpdateMessage()
        {
            // Debug.Log(ImageCamera.pixelWidth);
            var oldRT = RenderTexture.active;
            Graphics.Blit(ImageCamera.targetTexture, rTex, dmat);
            message.header.Update();

            RenderTexture.active = rTex;
            texture2D.ReadPixels(rect, 0, 0);
            texture2D.Apply();
            message.data = ImageConversion.EncodeToPNG(texture2D);
            Publish(message);

            RenderTexture.active = oldRT; 
            // }
            // Debug.Log("Published");


        }

    }
}
