import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlackButton extends StatelessWidget {
  final String? text;
  const BlackButton({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width*0.1,
      width: MediaQuery.of(context).size.width*0.8,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(child: Text(text!,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
    );
  }
}
