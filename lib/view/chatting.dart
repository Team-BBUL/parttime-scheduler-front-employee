import "package:flutter/material.dart";

class Chatting extends StatefulWidget {

  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: const Text("chatting"),
        )
    );
  }
}