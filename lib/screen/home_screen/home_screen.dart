// ignore_for_file: avoid_unnecessary_containers, must_call_super, unnecessary_new, prefer_const_constructors_in_immutables, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_chat/data/video.dart';
import 'package:flutter_app_chat/screen/home_screen/activities.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  PageController pageController = PageController(viewportFraction: 0.85);

  var _currentPageValue = 0.0;
  final double _scaleFactor = 0.8;
  final double _height = 220;
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      _currentPageValue = pageController.page!;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.grey.withOpacity(0.3),
        ),
        SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      10, MediaQuery.of(context).size.height * 0.06, 10, 20),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: _searchController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search_outlined),
                          hintText: "Search",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: Locator.locators.length,
                    itemBuilder: (context, position) {
                      return _buildpageItem(position);
                    },
                  ),
                ),
                new DotsIndicator(
                  dotsCount: Locator.locators.length,
                  position: _currentPageValue,
                  decorator: DotsDecorator(
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Destinations',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 220,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 1.2,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: Destination.discriptions.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Activities(
                                  destination: Destination.discriptions[index],
                                  id: index,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(14),
                                bottomRight: Radius.circular(14),
                              ),
                              color: Colors.white.withOpacity(0.7),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    SizedBox(
                                      height: 140,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.asset(
                                          Destination
                                              .discriptions[index].imageAsset,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, bottom: 5),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${Destination.discriptions[index].province}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on_sharp,
                                                    color: Colors.white
                                                        .withOpacity(0.7)),
                                                Text(
                                                  Destination
                                                      .discriptions[index]
                                                      .country,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      '${Destination.discriptions[index].activities} điểm du lịch',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      Destination
                                          .discriptions[index].discription,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Exclusive Homestay',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 180,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15),
                      itemCount: 5,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          alignment: Alignment.center,
                          child: Text('kj'),
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(15)),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildpageItem(int index) {
    Matrix4 matrix = new Matrix4.identity();
    if (index == _currentPageValue.floor()) {
      var currentScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currentTrans = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTrans, 0);
    } else if (index == _currentPageValue.floor() + 1) {
      var currentScale =
          _scaleFactor + (_currentPageValue - index + 1) * (1 - _scaleFactor);
      var currentTrans = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1);
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTrans, 0);
    } else if (index == _currentPageValue.floor() - 1) {
      var currentScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currentTrans = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1);
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTrans, 0);
    } else {
      var currentScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.amber,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: ExactAssetImage(Locator.locators[index].url),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 30),
              child: Text(
                Locator.locators[index].name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
