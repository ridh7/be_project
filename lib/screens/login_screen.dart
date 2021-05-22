import 'package:be_project/authentication_service.dart';
import 'package:be_project/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController, _passwordController;
  bool _passwordHidden = true, _loading = false;

  String errorMessage;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _key,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 200,
                    child: Text('MEDICAL IMAGE CAPTIONING'),
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (emailValid)
                        return null;
                      else
                        return 'Invalid email address';
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value.length > 0
                          ? null
                          : 'This field cannot be empty';
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(!_passwordHidden
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordHidden = !_passwordHidden;
                            });
                          }),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _passwordHidden,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.blueGrey,
                      child: _loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                      onPressed: () {
                        if (_key.currentState.validate()) {
                          setState(() {
                            _loading = true;
                          });
                          context
                              .read<AuthenticationService>()
                              .signIn(
                                email: _emailController.text,
                                password: _passwordController.text,
                              )
                              .then((value) {
                            if (value != 'Signed In')
                              setState(() {
                                errorMessage = value;
                                _loading = false;
                              });
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    errorMessage ?? '',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 10),
                  // Text('Forgot Password?'),
                  // SizedBox(height: 30),
                  // Text(
                  //   'OR',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //   ),
                  // ),
                  // SizedBox(height: 30),
                  // Text('Sign In With'),
                  // SizedBox(
                  //   width: 300,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       FlatButton(
                  //         color: Colors.blueGrey.withOpacity(.1),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(5),
                  //         ),
                  //         height: 30,
                  //         onPressed: () {},
                  //         child: Image.asset(
                  //           'assets/icons/facebook.png',
                  //           height: 15,
                  //         ),
                  //       ),
                  //       FlatButton(
                  //         color: Colors.blueGrey.withOpacity(.1),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(5),
                  //         ),
                  //         height: 30,
                  //         onPressed: () {},
                  //         child: Image.asset(
                  //           'assets/icons/google.png',
                  //           height: 15,
                  //         ),
                  //       ),
                  //       FlatButton(
                  //         color: Colors.blueGrey.withOpacity(.1),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(5),
                  //         ),
                  //         height: 30,
                  //         onPressed: () {},
                  //         child: Image.asset(
                  //           'assets/icons/twitter.png',
                  //           height: 15,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.black.withOpacity(.35)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupScreen(),
                            ),
                          );
                        },
                        child: Text(' Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
