// ignore_for_file: prefer_typing_uninitialized_variables, no_logic_in_create_state, avoid_unnecessary_containers, prefer_final_fields, unnecessary_new
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/theme/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:uuid/uuid.dart';

class ChatDetail extends StatefulWidget {
  final friendUid;
  final friendName;
  const ChatDetail({Key? key, this.friendUid, this.friendName})
      : super(key: key);

  @override
  State<ChatDetail> createState() => _ChatDetailState(friendUid, friendName);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection("chats");
  final friendUid;
  final friendName;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  var chatDocId;
  File? imageFlie;
  _ChatDetailState(this.friendUid, this.friendName);
  TextEditingController _sendMessageController = TextEditingController();
//  token='006fb48eaadc88a4aa0a13172b0d9b22c49IACWB9wnP3MRfO40rmVCHBBHX/884IMQJ6x4Tt5iaWxoX9zDPrsAAAAAEABVqCrXrKu+YgEAAQCrq75i';
//  id = 'fb48eaadc88a4aa0a13172b0d9b22c49'
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {friendUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.docs.isNotEmpty) {
            setState(() {
              chatDocId = querySnapshot.docs.single.id;
            });
          } else {
            await chats.add({
              'users': {currentUserId: null, friendUid: null},
              'username': {
                currentUserId: FirebaseAuth.instance.currentUser!.uid,
                friendUid: friendName
              }
            }).then((value) => {chatDocId = value});
          }
        })
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'uid': currentUserId,
      'msg': msg,
      'type': "text",
      'createOn': FieldValue.serverTimestamp(),
    }).then((value) {
      _sendMessageController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  Future getImage(ImageSource source) async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: source).then((xFile) {
      if (xFile != null) {
        setState(() {
          imageFlie = File(xFile.path);
        });
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;
    await chats.doc(chatDocId).collection('messages').doc(fileName).set({
      'uid': currentUserId,
      'msg': "",
      'type': "img",
      'createOn': FieldValue.serverTimestamp(),
    });
    final ref =
        FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
    var uploadTask = await ref.putFile(imageFlie!).catchError((error) async {
      await chats.doc(chatDocId).collection('messages').doc(fileName).delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await chats
          .doc(chatDocId)
          .collection('messages')
          .doc(fileName)
          .update({'msg': imageUrl});
      print(imageUrl);
    }
  }

//orderBy('createOn',descending: true) sap xep message
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('error list message'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          var data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: grey.withOpacity(0.2),
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: primary,
                  )),
              title: Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://images.unsplash.com/photo-1531427186611-ecfd6d936c79?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Tyler Nix",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "Active now",
                        style: TextStyle(
                            color: black.withOpacity(0.4), fontSize: 14),
                      )
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                const Icon(
                  LineIcons.phone,
                  color: primary,
                  size: 28,
                ),
                const SizedBox(
                  width: 15,
                ),
                const Icon(
                  LineIcons.video,
                  color: primary,
                  size: 28,
                ),
                const SizedBox(
                  width: 8,
                ),
                Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                      color: online,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white38)),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const ScrollPhysics(),
                      reverse: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        data = document.data();
                        return data['type'].toString() == 'text'
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                child: Align(
                                    alignment:
                                        getAlignment(data['uid'].toString()),
                                    child: Flexible(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              isSender(data['uid'].toString())
                                                  ? const Color.fromARGB(
                                                      255, 33, 133, 254)
                                                  : const Color(0xffE7E7ED),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12,
                                              right: 12,
                                              top: 6,
                                              bottom: 6),
                                          child: Text(
                                            data['msg'].toString(),
                                            style: TextStyle(
                                                color: isSender(
                                                        data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    )),
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                alignment: getAlignment(data['uid'].toString()),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2.5,
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                  ),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    alignment: data['msg'] != ""
                                        ? null
                                        : Alignment.center,
                                    child: data['msg'] != ""
                                        ? Image.network(
                                            data['msg'],
                                            fit: BoxFit.cover,
                                          )
                                        : const CircularProgressIndicator(),
                                  ),
                                ),
                              );
                      }).toList(),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(color: grey.withOpacity(0.2)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Container(
                              // width: (MediaQuery.of(context).size.width - 80) / 2,
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: () {
                                      getImage(ImageSource.camera);
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      size: 25,
                                      color: primary,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      getImage(ImageSource.gallery);
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      size: 25,
                                      color: primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Row(
                              children: <Widget>[
                                // (MediaQuery.of(context).size.width) / 2,

                                Flexible(
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: grey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: new ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 300,
                                        minHeight: 40,
                                      ),
                                      child: new Scrollbar(
                                        child: new SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          reverse: true,
                                          child: new TextFormField(
                                            keyboardType: TextInputType.text,
                                            maxLines: null,
                                            cursorColor: black,
                                            controller: _sendMessageController,
                                            decoration: const InputDecoration(
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintText: "Aa",
                                              suffixIcon: Icon(
                                                Icons.face,
                                                color: primary,
                                                size: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                IconButton(
                                    onPressed: () {
                                      sendMessage(_sendMessageController.text);
                                      _sendMessageController.clear();
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: primary,
                                      size: 25,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}


// child: ChatBubble(
                          //   clipper: ChatBubbleClipper6(
                          //     type: isSender(data['uid'].toString())
                          //         ? BubbleType.sendBubble
                          //         : BubbleType.receiverBubble,
                          //   ),
                          //   alignment: getAlignment(data['uid'].toString()),
                          //   margin: const EdgeInsets.only(top: 5),
                          //   backGroundColor: isSender(data['uid'].toString())
                          //       ? const Color.fromARGB(255, 8, 48, 193)
                          //       : const Color(0xffE7E7ED),
                          //   child: Container(
                          //     // constraints: BoxConstraints(
                          //     //   maxWidth: MediaQuery.of(context).size.width * 0.7,
                          //     // ),
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.only(
                          //             topRight: Radius.circular(30),
                          //             bottomRight: Radius.circular(5),
                          //             topLeft: Radius.circular(30),
                          //             bottomLeft: Radius.circular(30))),
                          //     child: Column(
                          //       children: [
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.start,
                          //           children: [
                          //             Text(data['msg'].toString(),
                          //                 style: TextStyle(
                          //                     color: isSender(
                          //                             data['uid'].toString())
                          //                         ? Colors.white
                          //                         : Colors.black),
                          //                 maxLines: 100,
                          //                 overflow: TextOverflow.ellipsis)
                          //           ],
                          //         ),
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           children: [
                          //             Text(
                          //               data['createdOn'] == null
                          //                   ? DateTime.now().toString()
                          //                   : data['createdOn']
                          //                       .toDate()
                          //                       .toString(),
                          //               style: TextStyle(
                          //                   fontSize: 10,
                          //                   color:
                          //                       isSender(data['uid'].toString())
                          //                           ? Colors.white
                          //                           : Colors.black),
                          //             )
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),