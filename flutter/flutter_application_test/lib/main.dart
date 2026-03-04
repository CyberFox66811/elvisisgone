import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:livekit_client/livekit_client.dart';

void main() => runApp(const MaterialApp(home: LiveKitTest()));

class LiveKitTest extends StatefulWidget {
  const LiveKitTest({super.key});

  @override
  State<LiveKitTest> createState() => _LiveKitTestState();
}

class _LiveKitTestState extends State<LiveKitTest> {
  String status = "Not Connected";

  Future<void> joinRoom() async {
    try {
      // Fetch token
      final tokenResponse = await http.get(Uri.parse('http://localhost:8080/get-token'));
      final token = tokenResponse.body;

      // Connect to LiveKit
      final room = Room();
      await room.connect('ws://localhost:7880', token);

      setState(() => status = "Connected to Room: ${room.name}");
      
      // Camera (test)
      await room.localParticipant?.setCameraEnabled(true);
      await room.localParticipant?.setMicrophoneEnabled(true);

    } catch (e) {
      setState(() => status = "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(status, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: joinRoom,
              child: const Text("Join LiveKit Room"),
            ),
          ],
        ),
      ),
    );
  }
}