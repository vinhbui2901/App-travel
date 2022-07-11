// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app_chat/data/video.dart';

class Activities extends StatefulWidget {
  final Destination destination;
  final int id;
  const Activities({
    Key? key,
    required this.destination,
    required this.id,
  }) : super(key: key);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  late PageController _pageController;
  int activePage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.destination.province)),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey.withOpacity(0.5),
          ),
          GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 0.85,
              mainAxisSpacing: 15,
            ),
            itemCount: Activity.acty[widget.id].detail.length,
            itemBuilder: (BuildContext ctx, count) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    color: Colors.white,
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                              Activity.acty[widget.id].imageUrl[count]),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          Activity.acty[widget.id].nameActivities[count],
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        _buildRatingStars(
                            Activity.acty[widget.id].rating[count]),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child:
                                Text(Activity.acty[widget.id].detail[count])),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
