// ignore_for_file: sized_box_for_whitespace

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/blocs/auth/auth_bloc.dart';
import 'package:flutter_app_chat/screen/main_screen.dart';
import 'package:flutter_app_chat/screen/signup_screen/signup_screen.dart';
import 'package:flutter_app_chat/screen/signup_screen/forgot_pass.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPass = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainScreen()));
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UnAuthenticated) {
              // Showing the sign in form if the user is not authenticated
              return Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffcb2b93),
                      Color(0xff9546c4),
                      Color(0xff5e61f4),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 160,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            TextFormField(
                              controller: _emailController,
                              enableSuggestions: true,
                              autocorrect: true,
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9)),
                              decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.9)),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.white70,
                                ),
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.9)),
                                filled: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                fillColor: Colors.white.withOpacity(0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return value != null &&
                                        !EmailValidator.validate(value)
                                    ? 'Enter a valid email'
                                    : null;
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Stack(
                              children: [
                                TextFormField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: !_showPass,
                                  enableSuggestions: true,
                                  autocorrect: true,
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9)),
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.key,
                                      color: Colors.white70,
                                    ),
                                    errorStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.9)),
                                    filled: true,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    fillColor: Colors.white.withOpacity(0.3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null && value.length < 6
                                        ? "Enter min 6 characters"
                                        : null;
                                  },
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, right: 5),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _showPass = !_showPass;
                                        });
                                      },
                                      icon: _showPass
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off),
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.height,
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90)),
                              child: ElevatedButton(
                                onPressed: () {
                                  _authenticateWithEmailAndPassword(context);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: const Text(
                                  'SIGN IN',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                style: ButtonStyle(
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return const Color(0xcc5bc4f7);
                                      } //<-- SEE HERE
                                      return null; // Defer to the widget's default.
                                    },
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                                child: const Text(
                                  'Forgot password',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ),
                            const Text(
                              'Or',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            Container(
                              height:
                                  (MediaQuery.of(context).size.height * 0.15),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: IconButton(
                                      onPressed: () {
                                        _authenticateWithGoogle(context);
                                      },
                                      icon: Image.asset(
                                        "assets/images/google.png",
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: IconButton(
                                      onPressed: () {
                                        _authenticateWithFacebook(context);
                                      },
                                      icon: Image.asset(
                                        "assets/images/facebook.png",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  const SignUp())));
                                    },
                                    child: const Text('SIGN UP',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                            color: Colors.greenAccent)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      // If email is valid adding new Event [SignInRequested].
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }

//
  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }

  void _authenticateWithFacebook(context) {
    BlocProvider.of<AuthBloc>(context).add(
      FacebookSignInRequested(),
    );
  }
}
