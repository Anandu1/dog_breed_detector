import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tensorflow_app/Widgets/BlackButton.dart';
import 'package:tflite/tflite.dart';

import 'Screen1.dart';

class TfliteHome extends StatefulWidget {
  const TfliteHome({Key? key}) : super(key: key);

  @override
  _TfliteHomeState createState() => _TfliteHomeState();
}

class _TfliteHomeState extends State<TfliteHome> {
  File? _image;
  List? output;
  bool reset=false;
  final picker = ImagePicker();
List imageHistory=[];
  @override
  void initState() {
    loadModel().then((value){
      setState(() {

      });
    });
  }

  detectImage(File _image) async{
    var _output = await Tflite.runModelOnImage(path:_image.path,
    numResults: 5,threshold: 0.6,imageMean: 127.5,imageStd: 127.5
    );
    setState(() {
      output=_output;

    });
  }
  loadModel() async{
    await Tflite.loadModel(model: "assets/model_unquant.tflite",labels: "assets/labels.txt");
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  pickImage() async{
    var image = await picker.getImage(source: ImageSource.camera);
    if(image==null) return null ;
    setState(() {
      _image=File(image.path);
      imageHistory.add(_image);
    });
    detectImage(_image!);
  }
  pickGalleryImage() async{
    var image = await picker.getImage(source: ImageSource.gallery);
    if(image==null) return null ;
    setState(() {
      _image=File(image.path);
      imageHistory.add(_image);
    });
    detectImage(_image!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.camera),
      //   onPressed: () {
      //   pickGalleryImage();
      // },
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset("assets/icons/list.png",height: 25,),
                    output==null ?
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Screen 2",style: TextStyle(fontWeight: FontWeight.bold),),
                    ):
                    _image==null ?
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Screen 1",style: TextStyle(fontWeight: FontWeight.bold),),
                    ) :Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Screen 2",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Spacer(),
                    CircleAvatar(foregroundImage: AssetImage("assets/ben-parker-OhKElOkQ3RE-unsplash.jpg"),)
                  ],
                ),
              ),
              // reset==false ? Container():
              Column(
                children: [
                  cameraIcon(),
                  SizedBox(height: 20,),
                  galleryIcon()
                ],
              ),
              imageHistory.length==0 ? Container():gridView(imageHistory),
              SizedBox(height: 20,),
              _image==null ?

              Container() :
                  Image.file(_image!,height: 300

                    ,),
              SizedBox(height: 20,),
              output==null ? Container():
              resultTile(
                  "https://images.unsplash.com/photo-1586671267731-da2cf3ceeb80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=389&q=80",
                  output![0]['label'].toString().substring(2),
                  output![0]['confidence']),
              SizedBox(height: 20,),
              output==null ? Container():
                  GestureDetector(
                      onTap: (){
                        setState(() {
                          _image=null;
                          output=null;
                          reset=true;
                        });
                      },
                      child: BlackButton(text: "Done",))
            ],
          ),
        ),
      ),
    );
  }
  Widget gridView(List history){
    return Container(
      height: history.length/3*250,
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: history.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 4.0
      ), itemBuilder: (BuildContext context, int index) {
          return Expanded(child: GestureDetector(
              onTap: (){
                detectImage(history[index]);
              },
              child: Image.file(history[index])));
      },  ),
    );
  }
  Widget cameraIcon(){
    return GestureDetector(
      onTap: (){
        pickImage();
      },
      child: Container(
        height: 50,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle
        ),
        child: Icon(Icons.camera_alt,color: Colors.white,),
      ),
    );
  }
  Widget resultTile(String img,String name,double _percent){
    final percenatge = _percent*100;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        children: [
          Spacer(),
          name=="Golden retriever" ?
          Expanded(
              flex: 4,
              child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/Golden_Retriever_Dukedestiny01_drvd.jpg",
                        fit: BoxFit.fill,height: 75,)))):
          name=="Terrier" ?
          Expanded(
              flex: 4,
              child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/terrier.webp",fit: BoxFit.fill,height: 75,)))):
          Expanded(
            flex: 4,
              child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                  child: Image.network(img,fit: BoxFit.fill,height: 75,)))),
          Spacer(),
          Expanded(
            flex: 8,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name),
                SizedBox(height: 5,),
                Row(
                  children: [
                    LinearPercentIndicator(
                      fillColor: Colors.blueGrey[100]!,
                      width: percenatge,
                      lineHeight: 14.0,
                      percent:_percent ,
                      backgroundColor: Colors.black,
                      progressColor: Colors.black,
                    ),
                    Text(percenatge.toString().substring(0,4))
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: Image.asset("assets/icons/check.png",height: 25,)),
          Spacer()
        ],
      ),
    );
  }
  Widget galleryIcon(){
    return GestureDetector(
      onTap: (){
        pickGalleryImage();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black,
        ),
        height: 50,
        width: 75,
        child: Icon(Icons.photo,color: Colors.white,),
      ),
    );
  }
}
