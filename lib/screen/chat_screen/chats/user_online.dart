// ignore_for_file: avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/theme/colors.dart';
import 'package:line_icons/line_icons.dart';

class UserOnline extends StatelessWidget {
  UserOnline({Key? key}) : super(key: key);
  var currentUser = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .where("uid", isNotEqualTo: currentUser)
          .snapshots(),
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          return Text('error');
        }

        if (snapshots.hasData) {
          return Row(
            children: [
              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 5),
              //       child: SizedBox(
              //         width: 70,
              //         child: Container(
              //           width: 55,
              //           height: 55,
              //           decoration: const BoxDecoration(
              //               shape: BoxShape.circle, color: grey),
              //           child: const Center(
              //             child: Icon(
              //               LineIcons.plus,
              //               size: 25,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 10,
              //     ),
              //     const SizedBox(
              //       child: Padding(
              //         padding: EdgeInsets.only(left: 5),
              //         child: Align(
              //             child: Text(
              //           'Group',
              //           overflow: TextOverflow.visible,
              //         )),
              //       ),
              //     )
              //   ],
              // ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => Card(
                    child: Center(child: Text('Dummy Card Text')),
                  ),
                ),
              ),

              // Expanded(
              //   child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: 1,
              //       itemBuilder: (context, index) {
              //         DocumentSnapshot documentSnapshot =
              //             snapshots.data!.docs[index];
              //         return Column(
              //           children: [
              //             Container(
              //               width: 15,
              //               height: 15,
              //               // decoration: BoxDecoration(
              //               //     shape: BoxShape.circle,
              //               //     image: DecorationImage(
              //               //         // image: NetworkImage(documentSnapshot['url']),
              //               //         fit: BoxFit.cover)),
              //               child: Text(documentSnapshot['username']),
              //             ),
              //           ],
              //         );
              //       }),
              // ),
            ],
          );
          // return SingleChildScrollView(
          //   // scrollDirection: Axis.horizontal,
          //   child: Row(
          //     children: [
          //       Column(
          //         children: <Widget>[
          //           Padding(
          //             padding: const EdgeInsets.only(left: 5),
          //             child: SizedBox(
          //               width: 70,
          //               child: Container(
          //                 width: 55,
          //                 height: 55,
          //                 decoration: const BoxDecoration(
          //                     shape: BoxShape.circle, color: grey),
          //                 child: const Center(
          //                   child: Icon(
          //                     LineIcons.plus,
          //                     size: 25,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //
          //         ],
          //       ),

        }
        return Container();
      },
    );
  }
}

//  SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: <Widget>[

//           Row(
//             children: List.generate(
//               userStories.length,
//               (index) {
//                 return Column(
//                   children: <Widget>[
//                     Stack(
//                       children: <Widget>[
//                         SizedBox(
//                           width: 55,
//                           child: Container(
//                             width: 55,
//                             height: 55,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                     image:
//                                         NetworkImage(userStories[index]['img']),
//                                     fit: BoxFit.cover)),
//                           ),
//                         ),
//                         userStories[index]['online']
//                             ? Positioned(
//                                 top: 40,
//                                 left: 42,
//                                 child: Container(
//                                   width: 15,
//                                   height: 15,
//                                   decoration: BoxDecoration(
//                                       color: online,
//                                       shape: BoxShape.circle,
//                                       border:
//                                           Border.all(color: white, width: 3)),
//                                 ),
//                               )
//                             : Container()
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     SizedBox(
//                       width: 65,
//                       child: Align(
//                         child: Text(
//                           userStories[index]['name'],
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     )
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
