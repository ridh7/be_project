import 'package:be_project/authentication_service.dart';
import 'package:be_project/screens/home_screen.dart';
import 'package:be_project/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController _emailController,
      _passwordController,
      _confirmPasswordController;

  bool _passwordHidden = true, _confirmPasswordHidden = true;

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
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
                      String pattern =
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                      RegExp regExp = new RegExp(pattern);
                      return value.length >= 8
                          ? regExp.hasMatch(value)
                              ? null
                              : 'The password needs to include:\n- Uppercase & lowercase alphabets\n- 1 number\n- 1 special symbol'
                          : 'Length should be more than 8 characters';
                    },
                    controller: _passwordController,
                    decoration: InputDecoration(
                      errorMaxLines: 10,
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
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return _passwordController.text == value
                          ? null
                          : 'Passwords do not match';
                    },
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: IconButton(
                          icon: Icon(!_confirmPasswordHidden
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _confirmPasswordHidden = !_confirmPasswordHidden;
                            });
                          }),
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _confirmPasswordHidden,
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
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (_key.currentState.validate()) {
                          context.read<AuthenticationService>().signUp(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        }
                      },
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
                          Navigator.pop(context);
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
      ),
    );
  }
}
