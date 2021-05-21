import 'dart:io';
import 'package:be_project/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final firestoreInstance = FirebaseFirestore.instance;

  Future uploadImageToFirebase() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("xray" +
        FirebaseAuth.instance.currentUser.uid +
        DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image);
    uploadTask.then((res) async {
      String url = await res.ref.getDownloadURL();
      print(url);
    });
  }

  void _onPressed() {
    firestoreInstance.collection("users").add({
      "name": "johnny",
      "age": 50,
      "email": "example@example.com",
      "address": {"street": "street 24", "city": "new york"}
    }).then((value) {
      print(value.id);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  File _image;
  final picker = ImagePicker();

  File file;
  var serverReceiverPath = " https://mic-be-2020.osc-fr1.scalingo.io/";

  Future<String> uploadImage(String filename) async {
    var request = http.MultipartRequest('POST', Uri.parse(serverReceiverPath));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    print(res.statusCode);
    return res.reasonPhrase;
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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'New Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Previous Scans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: _selectedIndex == 0
              ? Padding(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _image = null;
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
                      if (_image != null) SizedBox(height: 15),
                      if (_image == null) SizedBox(height: 30),
                      FlatButton(
                        onPressed: () {
                          // uploadImageToFirebase();
                          _onPressed();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        color: Colors.blueGrey,
                        child: Text(
                          'Generate Caption',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        'Stable tortuosity of the thoracic aorta. The presence of an underlying aneurysm cannot be excluded. Clear lungs.',
                        style: TextStyle(fontFamily: 'Raleway-Medium'),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
              : _selectedIndex == 1
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.black.withOpacity(.5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.search),
                                Text('Search'),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) => Card(
                                color: Colors.blueGrey,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/chest-scan.jpeg'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  fontFamily: 'Raleway'),
                                              children: [
                                                TextSpan(
                                                  text: 'ID: ',
                                                  style: TextStyle(
                                                    fontFamily: 'Raleway-Bold',
                                                  ),
                                                ),
                                                TextSpan(text: '1234'),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  fontFamily: 'Raleway'),
                                              children: [
                                                TextSpan(
                                                  text: 'Date: ',
                                                  style: TextStyle(
                                                    fontFamily: 'Raleway-Bold',
                                                  ),
                                                ),
                                                TextSpan(
                                                    text: 'January 22, 2021'),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: TextStyle(
                                                  fontFamily: 'Raleway'),
                                              children: [
                                                TextSpan(
                                                  text: 'Time: ',
                                                  style: TextStyle(
                                                    fontFamily: 'Raleway-Bold',
                                                  ),
                                                ),
                                                TextSpan(text: '8:55 am'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 240,
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                    fontFamily: 'Raleway'),
                                                children: [
                                                  TextSpan(
                                                    text: 'Caption: ',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Raleway-Bold',
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text:
                                                          'Stable tortuosity of the thoracic aorta. The presence of an underlying aneurysm cannot be excluded. Clear lungs.'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Account Details',
                                        style: TextStyle(
                                          fontFamily: 'Raleway-Bold',
                                          fontSize: 20,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.blueGrey,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30),
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      fontFamily: 'Raleway-Bold',
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    'Ridhwik Kalgaonkar',
                                    style: TextStyle(
                                      fontFamily: 'Raleway-Medium',
                                      color: Colors.blueGrey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Contact Number',
                                    style: TextStyle(
                                      fontFamily: 'Raleway-Bold',
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '+91 9922337964',
                                    style: TextStyle(
                                      fontFamily: 'Raleway-Medium',
                                      color: Colors.blueGrey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Email Address',
                                    style: TextStyle(
                                      fontFamily: 'Raleway-Bold',
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    FirebaseAuth.instance.currentUser.email,
                                    style: TextStyle(
                                      fontFamily: 'Raleway-Medium',
                                      color: Colors.blueGrey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Old Password',
                                            isDense: true,
                                          ),
                                          obscureText: true,
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'New Password',
                                            isDense: true,
                                          ),
                                          obscureText: true,
                                        ),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Confirm New Password',
                                            isDense: true,
                                          ),
                                          obscureText: true,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {},
                                        child: Text('Save'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Colors.red,
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: FlatButton(
                              onPressed: () {
                                context.read<AuthenticationService>().signOut();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Colors.blueGrey,
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
