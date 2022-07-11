// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/blocs/auth/auth_bloc.dart';

import 'package:flutter_app_chat/screen/signin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UserScreen extends StatefulWidget {
  UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  TextEditingController _username = TextEditingController();

  TextEditingController _email = TextEditingController();

  TextEditingController _gioitinh = TextEditingController();

  TextEditingController _tuoi = TextEditingController();
  Stream documentStream =
      FirebaseFirestore.instance.collection('users').doc('url').snapshots();
  File? imageFile;
  var currentUser = FirebaseAuth.instance.currentUser!.uid;

  void getdata() {
    String imageUser = '';
    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: currentUser)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _email.text = doc['email'];
        _username.text = doc['username'];
        _gioitinh.text = doc['sex'];
        _tuoi.text = doc['age'];
        imageUser = doc['url'];
        print(documentStream);
      });
    });
  }

  Future updateUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .update({
      'username': _username.text,
      'email': _email.text,
      'sex': _gioitinh.text,
      'age': _tuoi.text,
    });
  }

  Future getFile({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);
    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();

    final ref = FirebaseStorage.instance
        .ref()
        .child('imagesUser')
        .child('$fileName.jpg');
    var uploadTask = await ref.putFile(imageFile!).catchError((error) {});

    String imageUrl = await uploadTask.ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .update({'url': imageUrl});
    print('url $imageUrl');
  }

  @override
  void initState() {
    getdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Container(
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is UnAuthenticated) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SignIn()),
                        (route) => false,
                      );
                    }
                  },
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1),
                          child: Container(
                            height: 150,
                            width: 150,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Image.network(
                                      data['url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    height: 42,
                                    width: 42,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                alignment: Alignment.center,
                                                actions: [
                                                  ElevatedButton(
                                                      child:
                                                          const Text('camera'),
                                                      onPressed: () {
                                                        getFile(
                                                            source: ImageSource
                                                                .camera);
                                                        Navigator.pop(context);
                                                      }),
                                                  ElevatedButton(
                                                    child:
                                                        const Text('Thư viện'),
                                                    onPressed: () {
                                                      getFile(
                                                          source: ImageSource
                                                              .gallery);
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ]);
                                          },
                                        );
                                      },
                                      icon:
                                          const Icon(Icons.camera_alt_outlined),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: TextField(
                            controller: _username,
                            decoration:
                                const InputDecoration(labelText: 'Username'),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                        Container(
                          child: TextField(
                            controller: _email,
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                        Container(
                          child: TextField(
                            controller: _gioitinh,
                            decoration:
                                const InputDecoration(labelText: 'Giới tính'),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                        Container(
                          child: TextField(
                            controller: _tuoi,
                            decoration:
                                const InputDecoration(labelText: 'Tuổi'),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            child: const Text('Cập nhập'),
                            onPressed: () {
                              updateUser();
                            },
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ElevatedButton(
                            child: const Text('Đăng xuất'),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          'Bạn chắc chắn muốn đăng xuất?'),
                                      actions: [
                                        ElevatedButton(
                                          child: const Text('Không'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ElevatedButton(
                                          child: const Text('Có'),
                                          onPressed: () {
                                            context
                                                .read<AuthBloc>()
                                                .add(SignOutRequested());
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
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
        });
  }
}

class TextfieldContaner extends StatelessWidget {
  const TextfieldContaner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
