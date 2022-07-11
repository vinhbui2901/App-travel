// ignore_for_file: unnecessary_new, unused_local_variable, unused_field

import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<Marker> _markers = <Marker>[];
  final TextEditingController _searchController = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _googleMapController;
  final bool _loacation = false;
  LocationData? currentLocation;
  Location? location;
  LocationData? destinationLocation;
  final bool _mapType = false;
  final List<LatLng> _latLngs = const [
    LatLng(20.84303, 104.57620),
    LatLng(20.81751966872778, 104.59106529013322),
    LatLng(20.83422147051739, 104.62589864373231),
    LatLng(20.87314127412042, 104.71120862916781),
    LatLng(20.89742125505492, 104.65298672305028),
    LatLng(20.851192530367182, 104.63924335465342),
    LatLng(20.88551521757313, 104.58202096720503),
  ];

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    setState(() {
      // getLocation();
      _currentLocation();
      loadData();
    });
  }

  loadData() {
    for (int i = 0; i < _latLngs.length; i++) {
      _markers.add(
        Marker(
            markerId: MarkerId(i.toString()),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            position: _latLngs[i],
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        height: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://res.klook.com/image/upload/q_85/c_fill,w_1360/v1631702904/blog/iq8hqkqdw8fkoen0zmbm.webp'),
                            fit: BoxFit.fitWidth,
                            filterQuality: FilterQuality.high,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _latLngs[i],
              );
            }),
      );
      setState(() {});
    }
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData? currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(16.285707, 106.288550),
              zoom: 5.8,
            ),
            zoomControlsEnabled: false,
            markers: Set<Marker>.of(_markers),
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindowController.googleMapController = controller;
            },
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 200,
            width: 300,
            offset: 1,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, size.height * 0.06, 10, 0),
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                cursorColor: Colors.blue,
                controller: _searchController,
                decoration: InputDecoration(
                    prefixIcon: new Image.asset(
                      'assets/icons/map01.png',
                    ),
                    hintText: "Search",
                    border: InputBorder.none),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 70,
              width: 70,
              padding: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                heroTag: 'recenterr',
                onPressed: () {},
                child: Icon(
                  Icons.my_location,
                  color: Colors.black.withOpacity(0.7),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: const BorderSide(color: Color(0xFFECEDF1))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
