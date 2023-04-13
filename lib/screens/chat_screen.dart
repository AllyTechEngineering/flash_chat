import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

// Initialize Cloud Firestore
final _firestore = FirebaseFirestore.instance;

late auth.User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  } // initState

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print('this is the logged in user variable: $loggedInUser.email');
      } //if
    } catch (e) {
      print(e);
    } //catch
  } // getCurrentUser

  // code from a student - it works
  // void getMessages() async {
  //   QuerySnapshot querySnapshot = await _firestore.collection('messages').get();
  //   final messages = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   for (var message in messages) {
  //     print('This is the students solution for getMessages: $message');
  //   }
  // }

// code from the class - deprecated and does not work
  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print('This is the message.data output: $message.data');
  //   } //for loop
  // } //getMessages

  //Original code from class - returns Instance of '_JsonQueryDocumentSnapshot'.data which is not what is shown in the lecture.
  // void messagesStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print('This is the stream message.data: $message.data');
  //     } //for
  //   } //await
  // } //messagesStream

  //Students code
  void messagesStream() async {
    await _firestore.collection('messages').snapshots().forEach((snapshot) {
      for (var message in snapshot.docs) {
        // print(message.data());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messagesStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else {
          final messages = snapshot.data?.docs;
          for (var message in messages!) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            //final messageWidget = Text('$messageText from $messageSender');
            final messageBubble = MessageBubble(sender: messageSender, text: messageText);
            messageBubbles.add(messageBubble);
          } //for
        } //else
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      }, //builder
    );
  } //Widget
} //class

class MessageBubble extends StatelessWidget {
  //Properties
  final String sender;
  final String text;
// Constructor
  MessageBubble({super.key, required this.sender, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  } //Widget
} //class
