import 'package:chat_app_flutter/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final snapshotData = snapshot.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: snapshotData.length,
              itemBuilder: (context, index) => MessageBubble(
                snapshotData[index]['text'],
                snapshotData[index]['username'],
                snapshotData[index]['userimage'],
                snapshotData[index]['uid'] == futureSnapshot.data!.uid,
                key: ValueKey(snapshotData[index].id), // late need to add
              ),
            );
          },
        );
      },
    );
  }
}
