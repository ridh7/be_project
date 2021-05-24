import 'package:be_project/authentication_service.dart';
import 'package:be_project/screens/new_scan_screen.dart';
import 'package:be_project/screens/previous_scans_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      context.read<AuthenticationService>().signOut();
      return;
    }
    setState(() {
      _selectedIndex = index;
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
            icon: Icon(Icons.logout),
            label: 'Log Out',
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
              ? NewScanScreen()
              : _selectedIndex == 1
                  ? PreviousScans()
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
                                    FirebaseAuth
                                            .instance.currentUser.displayName ??
                                        'null',
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
