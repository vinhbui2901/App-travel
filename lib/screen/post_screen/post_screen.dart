// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_app_chat/data/video.dart';
import 'package:flutter_app_chat/screen/chat_screen/chat_home.dart';
import 'package:flutter_app_chat/screen/post_screen/video_title.dart';
import 'package:marquee/marquee.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

bool _isSelectedFollowing = true;
int _snappedPageIndex = 0;

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSelectedFollowing = true;
                  });
                },
                child: Text('Following',
                    style: TextStyle(
                        fontSize: _isSelectedFollowing ? 18 : 16,
                        color:
                            _isSelectedFollowing ? Colors.white : Colors.grey)),
              ),
              const Text(
                ' | ',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSelectedFollowing = false;
                  });
                },
                child: Text(
                  'For You',
                  style: TextStyle(
                      fontSize: !_isSelectedFollowing ? 18 : 16,
                      color:
                          !_isSelectedFollowing ? Colors.white : Colors.grey),
                ),
              ),
            ]),
      ),
      body: PageView.builder(
        onPageChanged: (int page) {
          setState(() {
            _snappedPageIndex = page;
          });
        },
        scrollDirection: Axis.vertical,
        itemCount: Video.videos.length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoTitle(
                video: Video.videos[index],
                currentIndex: index,
                snappedPageIndex: _snappedPageIndex,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Video.videos[index].name,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.music_note,
                                  size: 15,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 20,
                                  child: Marquee(
                                      text: " Review ",
                                      velocity: 10,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 13)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                child: Icon(Icons.thumb_up_alt,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 30)),
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.grey.withOpacity(0.3),
                              ),
                              child: Icon(Icons.heart_broken,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 30),
                            ),
                            Container(
                                width: 45,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey.withOpacity(0.23),
                                ),
                                child: Icon(Icons.message_rounded,
                                    color: Colors.white.withOpacity(0.8),
                                    size: 30)),
                          ]),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
