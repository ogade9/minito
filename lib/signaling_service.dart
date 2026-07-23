import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart' as ws;
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class Connections extends StatefulWidget{
  const Connections({super.key});

  @override
  State<Connections> createState() => _ConnectionState();

}
class _ConnectionState extends State<Connections>{
  @override
  void initState() {
    super.initState();
    _setup();
  }
  final renderer = RTCVideoRenderer();
  
  Future<void> _setup() async{
    await _initpeerConnection();
    await renderer.initialize();

    
    //listens for ice candidates
    _peerConnection.onIceCandidate= (candidate){
        final con = {
          "type": "candidate",
          "candidate":candidate.candidate,
          "sdpMid": candidate.sdpMid,
          "sdpMLineIndex": candidate.sdpMLineIndex,
        };
        //sends them
        connection.sink.add(jsonEncode(con));
        
      };
      //this checks the connection state to see if it connected
      _peerConnection.onIceConnectionState = (RTCIceConnectionState state){
          print("ICE Connection State: $state");

      };
      //To send video streams
      _peerConnection.onTrack = (RTCTrackEvent event){
        print("onTrack fired! streams: ${event.streams.length}");

        if(event.streams.isNotEmpty){
          setState(() {
            renderer.srcObject = event.streams[0];
            
          });
        }
      };
    connection.stream.listen((message) async{
      final parse = jsonDecode(message);
      print(parse['type']);
      print(parse);
      await _peerConnection.setRemoteDescription(RTCSessionDescription(parse['sdp'], parse['type']));
      final answer = await _peerConnection.createAnswer();
      await _peerConnection.setLocalDescription(answer);
      final localDesc = await _peerConnection.getLocalDescription();

      final answerMessage = {
        "sdp": localDesc!.sdp,
        "type": localDesc!.type,
      };
      print(localDesc!.sdp);
      connection.sink.add(jsonEncode(answerMessage));



    });
  }
  final connection = ws.WebSocketChannel.connect(Uri.parse('ws://localhost:8765'));
  late RTCPeerConnection _peerConnection;

  Future<void> _initpeerConnection() async{
      Map<String, dynamic> configuration = {
        "iceServers": [
          {"urls": "stun:stun1.l.google.com:19302"}, // Public Google STUN server
        ],
        "sdpSemantics": "unified-plan" 
        
      };
      Map<String, dynamic> constraints = {
        "mandatory": {},
        "optional": [
          {"DtlsSrtpKeyAgreement": true}, // Necessary for secure connections
        ],
      };
      _peerConnection = await createPeerConnection(configuration, constraints);
      //await _peerConnection.setRemoteDescription();




  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: RTCVideoView(renderer),
),
  
    );

  }
}
