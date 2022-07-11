// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/constant/data.dart';
import 'package:flutter_app_chat/theme/colors.dart';
import 'package:line_icons/line_icons.dart';

class AddFrend extends StatelessWidget {
  AddFrend({Key? key}) : super(key: key);
  final TextEditingController _searchController = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 15, left: 15),
          child: Container(
            width: double.infinity,
            height: 30,
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
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey.withOpacity(0.5),
          ),
          Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("uid", isNotEqualTo: currentUser)
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.hasError) {
                        return const Center(
                          child: Text('error'),
                        );
                      }
                      if (snapshots.hasData) {
                        return ListView.builder(
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshots.data!.docs[index];
                            return SingleChildScrollView(
                              physics: const ScrollPhysics(),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  height: 100,
                                  color: Colors.white.withOpacity(0.8),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Container(
                                          width: 55,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    userMessages[index]['img']),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            documentSnapshot['username'],
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 30,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.4,
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              child: const Text('Thêm bạn bè',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.blue)),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  const Color(0xffd1e4ff),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return Container();
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
