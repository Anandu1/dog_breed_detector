import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tensorflow_app/Screens/TfliteHome.dart';
import 'package:tensorflow_app/Widgets/BlackButton.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset("assets/icons/list.png",height: 25,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Screen 1",style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.4,),
            GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return TfliteHome();
                  }));
                },
                child: BlackButton(text: "Add Image",))
          ],
        ),
      ),
    );
  }
  Widget cameraIcon(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle
      ),
      child: Icon(Icons.camera_alt,color: Colors.white,),
    );
  }
}
