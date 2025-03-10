import 'package:flutter/material.dart';

class PersonInfo extends StatefulWidget {
  Map<String,dynamic> map;
  PersonInfo({super.key,required this.map});

  @override
  State<PersonInfo> createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.map['name']),
      ),
    );
  }
}
