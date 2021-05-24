import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'dart:convert';

Caption captionFromJson(String str) => Caption.fromJson(json.decode(str));

String captionToJson(Caption data) => json.encode(data.toJson());

class Caption {
  Caption({
    this.caption,
    this.error,
  });

  List<String> caption;
  int error;

  factory Caption.fromJson(Map<String, dynamic> json) => Caption(
        caption: List<String>.from(json["caption"].map((x) => x)),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "caption": List<dynamic>.from(caption.map((x) => x)),
        "error": error,
      };
}

class NewScanScreen extends StatefulWidget {
  @override
  _NewScanScreenState createState() => _NewScanScreenState();
}

class _NewScanScreenState extends State<NewScanScreen> {
  final firestoreInstance = FirebaseFirestore.instance;

  String url;

  Caption output;

  bool loading = false, isFeedbackGiven = false;

  TextEditingController _feedbackController = TextEditingController();

  Future uploadImageToFirebase() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("xray_" +
        FirebaseAuth.instance.currentUser.uid +
        "_" +
        DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);

    uploadTask.then((res) async {
      url = await res.ref.getDownloadURL();
      firestoreInstance.collection(FirebaseAuth.instance.currentUser.uid).add({
        "imageUrl": url,
        "timestamp": DateTime.now().toString(),
        "caption": output.caption.join(' '),
        "id": Random().nextInt(1000).toString(),
      });
    });
  }

  File _image;
  final picker = ImagePicker();

  var serverReceiverPath = "https://mic-be-2020.osc-fr1.scalingo.io/";

  Future<void> uploadImage(String filename) async {
    setState(() {
      loading = true;
    });
    var request = http.MultipartRequest('POST', Uri.parse(serverReceiverPath));
    request.files.add(await http.MultipartFile.fromPath('file', filename));
    http.Response response =
        await http.Response.fromStream(await request.send());
    print(response.body);
    output = captionFromJson(response.body);
    print(output.error);
    if (output.error == 0) {
      setState(() {
        output = captionFromJson(response.body);
        uploadImageToFirebase();
        loading = false;
      });
    } else {
      setState(() {
        output.caption = ['Invalid image'];
        loading = false;
      });
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blueGrey,
                width: 2,
              ),
            ),
            child: _image == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage(ImageSource.camera);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              'Camera',
                              style: TextStyle(
                                fontFamily: 'Raleway-Bold',
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              'Gallery',
                              style: TextStyle(
                                fontFamily: 'Raleway-Bold',
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Image.file(_image),
          ),
          if (_image != null) SizedBox(height: 15),
          if (_image != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                      output = null;
                      isFeedbackGiven = false;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.red,
                  child: Text(
                    'Remove Image',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (output != null && !isFeedbackGiven && output.error != 1)
                  FlatButton(
                    onPressed: () {
                      _feedbackController.text = "";
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          contentPadding: EdgeInsets.all(20),
                          content: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value.length > 0
                                  ? null
                                  : 'This field cannot be empty';
                            },
                            controller: _feedbackController,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'Correct Caption',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                print(url);
                                FirebaseFirestore.instance
                                    .collection('feedback')
                                    .add(
                                  {
                                    'imageUrl': url,
                                    'userGeneratedCaption':
                                        _feedbackController.text
                                  },
                                );
                                setState(() {
                                  isFeedbackGiven = true;
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Confirm'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.green,
                    child: Text(
                      'Give Feedback',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          if (_image != null) SizedBox(height: 15),
          if (_image == null) SizedBox(height: 30),
          FlatButton(
            onPressed: () {
              // uploadImageToFirebase();
              // _onPressed();
              uploadImage(_image.path);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            color: Colors.blueGrey,
            child: loading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Generate Caption',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
          ),
          SizedBox(height: 30),
          Text(
            output != null ? output.caption.join(' ') : '',
            style: TextStyle(fontFamily: 'Raleway-Medium'),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
