import "package:flutter/material.dart";
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkCheck extends StatefulWidget {

  @override
  _NetworkState createState() => _NetworkState();
}

class _NetworkState extends State<NetworkCheck> {

  bool connection = false;

  void networkCheck() async {
    final connectivity = await (Connectivity().checkConnectivity());

    if (connectivity == ConnectivityResult.wifi || connectivity == ConnectivityResult.mobile) {
      setState(() {
        connection = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return connection ?
    const Text('인터넷 연결됨') : const Text('인터넷 연결을 확인해주세요.');
  }
}