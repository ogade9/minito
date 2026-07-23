import cv2
import asyncio
import av
import websockets
import json
from aiortc.mediastreams import VideoStreamTrack
from aiortc import RTCPeerConnection, RTCSessionDescription
from aiortc.sdp import candidate_from_sdp

class CameraTrack(VideoStreamTrack):
    def __init__(self):
        super().__init__()
        self.cam = cv2.VideoCapture(0)
        #ret lets me know if the read suceeded and frame is the actual image data 
        if not self.cam.isOpened():
            print("cam is not open")
            exit()
        self.width = int(self.cam.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.height = int(self.cam.get(cv2.CAP_PROP_FRAME_HEIGHT))



    async def recv(self):
        print("recv called")

        self.ret, self.frame = self.cam.read()
        if not self.ret:
            #ret lets me know if the read suceeded and frame is the actual image data 

            print("Can't receive frame")
        #convert numpy frame from self.frame into an av.VideoFrame
        self.converted_frame= av.VideoFrame.from_ndarray(self.frame, format = "bgr24")
        pts,time_base = await self.next_timestamp()
        self.converted_frame.pts = pts
        self.converted_frame.time_base = time_base

        return self.converted_frame
async def main():
    connection = RTCPeerConnection()
    camera = CameraTrack()
    sender = connection.addTrack(camera)
    print(f"Track added: {sender}")
    @connection.on("connectionstatechange")
    async def change():

        print(f"Connection state: ${connection.connectionState}")
        for t in connection.getTransceivers():
            print(f"Transceiver: {t.kind}, direction: {t.direction}, sender track: {t.sender.track}")

    #connect to the signaling server
    async with websockets.connect('ws://localhost:8765') as websocket:
        print("connected to signaling server")
    #creating the offer to show what this peerconnection can send
        offer = await connection.createOffer()
        await connection.setLocalDescription(offer)
        #print(await connection.setLocalDescription(offer))
        connect_dict = {"sdp":connection.localDescription.sdp, "type": connection.localDescription.type}
        print(connection.localDescription.sdp)
        await websocket.send(json.dumps(connect_dict))
    #receiving the answer after sending the offer
        async for message in websocket:
            message_dict = json.loads(message)
            if message_dict["type"] == "answer":
                await connection.setRemoteDescription(RTCSessionDescription(message_dict["sdp"], message_dict["type"]))
            elif message_dict["type"] == "candidate":
                candi = candidate_from_sdp(message_dict["candidate"])
                candi.sdpMid = message_dict["sdpMid"]
                candi.sdpMLineIndex = message_dict["sdpMLineIndex"]
                await connection.addIceCandidate(candi)


            
        #await connection.setRemoteDescription(RTCSessionDescription(answer_dict["sdp"], answer_dict["type"]))
        #this is an event listener that fires everytime a new address candidate is generated
            

            
    
        


if __name__ == '__main__':
    asyncio.run(main())

