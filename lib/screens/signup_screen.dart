import 'package:be_project/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 200,
                  child: Text('LOGO'),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueGrey.withOpacity(.25),
                  ),
                  height: 50,
                  padding: EdgeInsets.fromLTRB(
                    15,
                    7.5,
                    15,
                    0,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                      isDense: true,
                      hintStyle: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 14,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueGrey.withOpacity(.25),
                  ),
                  height: 50,
                  padding: EdgeInsets.fromLTRB(
                    15,
                    7.5,
                    0,
                    0,
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 14,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Positioned(
                        right: 15,
                        top: 5,
                        child: Icon(Icons.remove_red_eye),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueGrey.withOpacity(.25),
                  ),
                  height: 50,
                  padding: EdgeInsets.fromLTRB(
                    15,
                    7.5,
                    0,
                    0,
                  ),
                  child: Stack(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          border: InputBorder.none,
                          isDense: true,
                          hintStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 14,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Positioned(
                        right: 15,
                        top: 5,
                        child: Icon(Icons.remove_red_eye),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.blueGrey,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 30),
                Text('Sign Up With'),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        color: Colors.blueGrey.withOpacity(.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 30,
                        onPressed: () {},
                        child: Image.asset(
                          'assets/icons/facebook.png',
                          height: 15,
                        ),
                      ),
                      FlatButton(
                        color: Colors.blueGrey.withOpacity(.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 30,
                        onPressed: () {},
                        child: Image.asset(
                          'assets/icons/google.png',
                          height: 15,
                        ),
                      ),
                      FlatButton(
                        color: Colors.blueGrey.withOpacity(.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 30,
                        onPressed: () {},
                        child: Image.asset(
                          'assets/icons/twitter.png',
                          height: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black.withOpacity(.35)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(' Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
