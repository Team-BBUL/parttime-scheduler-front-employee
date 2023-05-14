import "package:flutter/material.dart";

class Cost extends StatefulWidget {

  @override
  _CostState createState() => _CostState();
}

class _CostState extends State<Cost> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text("cost"),
      )
    );
  }
}