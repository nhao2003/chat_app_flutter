import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMessage = '';
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'uid': uid,
      'username': userData['username'],
      'userimage': userData['userimage']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter message...',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}
