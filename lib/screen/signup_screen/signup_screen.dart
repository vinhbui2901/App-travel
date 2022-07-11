// ignore_for_file: sized_box_for_whitespace

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/blocs/auth/auth_bloc.dart';

import 'package:flutter_app_chat/screen/main_screen.dart';
import 'package:flutter_app_chat/screen/signin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _userNamController = TextEditingController();

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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            );
          }
          if (state is AuthError) {
            // Displaying the error message if the user is not authenticated
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            // Displaying the loading indicator while the user is signing up
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UnAuthenticated) {
            // Displaying the sign up form if the user is not authenticated
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
                          controller: _userNamController,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.text,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            errorStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white70,
                            ),
                            labelText: 'UserName',
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value != null && value.length < 3
                                ? "Enter min 3 characters"
                                : null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _emailController,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            errorStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white70,
                            ),
                            labelText: 'Email',
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              _createAccountWithEmailAndPassword(context);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: const Text(
                              'SIGN UP',
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
                                  if (states.contains(MaterialState.pressed)) {
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const SignIn())));
                              },
                              child: const Text('SIGN IN',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      color: Colors.greenAccent)),
                            ),
                          ],
                        ),
                        const Text("Or"),
                        Container(
                          height: (MediaQuery.of(context).size.height * 0.15),
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
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  void _createAccountWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      // If email is valid adding new event [SignUpRequested].
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(_userNamController.text, _emailController.text,
            _passwordController.text),
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
