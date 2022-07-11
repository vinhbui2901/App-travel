// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_app_chat/blocs/auth/auth_bloc.dart';
import 'package:flutter_app_chat/screen/chat_screen/chat_home.dart';
import 'package:flutter_app_chat/screen/home_screen/home_screen.dart';
import 'package:flutter_app_chat/screen/map_screen.dart';
import 'package:flutter_app_chat/screen/post_screen/post_screen.dart';

import 'package:flutter_app_chat/screen/signin.dart';
import 'package:flutter_app_chat/screen/user_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final screen = [
    HomeScreen(),
    PostScreen(),
    MapScreen(),
    HomeChat(),
    UserScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignIn()),
              (route) => false,
            );
          }
        },
        child: screen[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.blue,
        // animationDuration: Duration(milliseconds: 300),
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],

        onTap: _onItemTapped,

        items: const [
          // Icon(Icons.home, color: Colors.black),
          // Icon(Icons.post_add_rounded, color: Colors.white),
          // Icon(Icons.map_outlined, color: Colors.white),
          // Icon(Icons.message, color: Colors.white),
          // Icon(Icons.person, color: Colors.white),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add_rounded),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}
