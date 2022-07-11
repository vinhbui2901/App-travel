// ignore_for_file: use_key_in_widget_constructors, unnecessary_new, sized_box_for_whitespace, non_constant_identifier_names, unused_element
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/data/video.dart';
import 'package:flutter_app_chat/screen/chat_screen/add_frend.dart';

import 'package:flutter_app_chat/screen/chat_screen/chats/user_chat.dart';
import 'package:flutter_app_chat/screen/chat_screen/chats/user_online.dart';
import 'package:flutter_app_chat/screen/chat_screen/chats/user_online.dart';
import 'package:flutter_app_chat/screen/chat_screen/chats/user_online.dart';
import 'package:flutter_app_chat/theme/colors.dart';
import 'package:line_icons/line_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeChat extends StatefulWidget {
  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  String name = '';
  final TextEditingController _searchController = new TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/homeChat'),
      builder: (context) => HomeChat(),
    );
  }

  Future<String> getFollowingUidList() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('chats')
        .where('username', isNotEqualTo: currentUser)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    String followingList = '';
    documents.forEach((snapshot) {
      followingList = snapshot[currentUser];
    });
    print(followingList);
    return followingList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(context),
      body: Body(context),
    );
  }

  AppBar BuildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: GestureDetector(
          onTap: () {},
          child: User(),
        ),
      ),
      leadingWidth: 50,
      centerTitle: true,
      title: const Text(
        'Chats',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => AddFrend())));
          },
          icon: const Icon(Icons.person_add),
          color: Colors.black,
        ),
      ],
    );
  }

  Column Body(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: 40,
                decoration: BoxDecoration(
                    color: grey, borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  cursorColor: black,
                  controller: _searchController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        LineIcons.search,
                        color: black.withOpacity(0.5),
                      ),
                      hintText: "Search",
                      border: InputBorder.none),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.search)),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        // UserOnline(),
        const SizedBox(
          height: 20,
        ),
        UserChat(),
      ],
    );
  }
}

class User extends StatelessWidget {
  User({Key? key}) : super(key: key);
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection("users").doc(currentUser).get(),
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          return const Center(
            child: Text('error'),
          );
        }
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshots.hasData) {
          Map<String, dynamic> data =
              snapshots.data!.data() as Map<String, dynamic>;
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(data['url']), fit: BoxFit.cover),
            ),
          );
        }
        return Container();
      },
    );
  }
}
