import 'package:flutter/material.dart';
class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("客服中心"),
      ),
      body: Center(
        child: Text("微信号：abc18268878",style: TextStyle(fontSize: 25,color: Colors.grey[700]),),
      ),
    );
  }
}
