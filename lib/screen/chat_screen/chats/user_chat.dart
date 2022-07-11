// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/constant/data.dart';
import 'package:flutter_app_chat/screen/chat_screen/chat_detail.dart';

import 'package:flutter_app_chat/theme/colors.dart';

class UserChat extends StatelessWidget {
  UserChat({Key? key}) : super(key: key);
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  void callChatDetailScreen(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatDetail(
                  friendName: name,
                  friendUid: uid,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
            if (snapshots.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshots.hasData) {
              return ListView.builder(
                itemCount: snapshots.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data!.docs[index];
                  return InkWell(
                    onTap: () {
                      callChatDetailScreen(
                          context,
                          documentSnapshot['username'],
                          documentSnapshot['uid']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 15),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(documentSnapshot['url']),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                documentSnapshot['username'],
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          }),
    );
  }
}
// Padding(
//         padding: const EdgeInsets.only(left: 10),
//         child: Column(
//           children: List.generate(userMessages.length, (index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (_) => ChatDetailPage()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 15),
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 55,
//                       height: 55,
//                       child: Stack(
//                         children: <Widget>[
//                           Container(
//                             width: 55,
//                             height: 55,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                     image: NetworkImage(
//                                         userMessages[index]['img']),
//                                     fit: BoxFit.cover)),
//                           ),
//                           userMessages[index]['online']
//                               ? Positioned(
//                                   top: 40,
//                                   left: 42,
//                                   child: Container(
//                                     width: 15,
//                                     height: 15,
//                                     decoration: BoxDecoration(
//                                         color: online,
//                                         shape: BoxShape.circle,
//                                         border:
//                                             Border.all(color: white, width: 3)),
//                                   ),
//                                 )
//                               : Container()
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           userMessages[index]['name'],
//                           style: const TextStyle(
//                               fontSize: 17, fontWeight: FontWeight.w500),
//                         ),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width - 135,
//                           child: Text(
//                             userMessages[index]['message'] +
//                                 " - " +
//                                 userMessages[index]['created_at'],
//                             style: TextStyle(
//                                 fontSize: 15, color: black.withOpacity(0.8)),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             );
//           }),
//         ));
  