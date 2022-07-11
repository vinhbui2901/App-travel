import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/blocs/auth/auth_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Reset Password')),
      body: Container(
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
                20, MediaQuery.of(context).size.height * 0.08, 20, 0),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_rounded)),
                    ),
                    ClipRRect(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 160,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    TextFormField(
                      controller: _emailController,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
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
                        return value != null && !EmailValidator.validate(value)
                            ? 'Enter a valid email'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90)),
                      child: ElevatedButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();

                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content:
                                        const Text('Password Reset Successful'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            _forgotPassword(context);
                                          },
                                          child: const Text('Ok'))
                                    ],
                                  ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void _forgotPassword(context) {
    if (_formKey.currentState!.validate()) {
      // If email is valid adding new Event [SignInRequested].
      BlocProvider.of<AuthBloc>(context).add(
        ResetPasswordRequested(_emailController.text),
      );
      Navigator.pop(context);
    }
  }
}
