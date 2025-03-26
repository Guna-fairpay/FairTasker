import 'package:flutter/material.dart';

import '../../../../Utilities/Utils.dart';
import '../../../../Utilities/appC.dart';

class VehicleLogUI extends StatefulWidget {
  const VehicleLogUI({super.key});

  @override
  _VehicleLogUIState createState() => _VehicleLogUIState();
}

class _VehicleLogUIState extends State<VehicleLogUI> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    print("Message sent: ${_messageController.text}");
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppC.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(), // Placeholder for chat messages
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {}, // Handle image selection
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {}, // Handle audio recording
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {}, // Handle video selection
          ),
          Expanded(
            child: Utils.getBorderedMultilineTextField(
              "Type a message...",
              _messageController,
              borderRadius: 20,
              maxLines: 5,
              minLines: 1
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
