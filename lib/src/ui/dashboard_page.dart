import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/theme/color_theme.dart';
import 'package:p2p_pay/src/ui/notification_page.dart';
import 'package:p2p_pay/src/ui/search_page.dart';
import 'package:p2p_pay/src/ui/widgets/float_button.dart';
import 'package:p2p_pay/src/ui/widgets/marker_window.dart';
import 'package:p2p_pay/src/ui/widgets/post_item.dart';
import '../models/post.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final LatLng _center = const LatLng(16.79729673247046, 96.13215959983089);
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> _markers = <Marker>[];
  List<Provider> types = [
    Provider(
        id: 1,
        image: ImageUrl(url: "assets/images/kbz-pay.png"),
        icon: ImageUrl(url: "assets/images/kbz-pay-circle.png"),
        marker: ImageUrl(url: "assets/images/kbz-marker.png"),
        name: "KBZ Pay"),
    Provider(
        id: 2,
        image: ImageUrl(url: "assets/images/cb-pay.png"),
        icon: ImageUrl(url: "assets/images/cb-pay-circle.png"),
        marker: ImageUrl(url: "assets/images/cb-marker.png"),
        name: "CB Pay"),
    Provider(
        id: 3,
        image: ImageUrl(url: "assets/images/wave-pay.png"),
        icon: ImageUrl(url: "assets/images/wave-pay-circle.png"),
        marker: ImageUrl(url: "assets/images/wave-marker.png"),
        name: "Wave Pay"),
    Provider(
        id: 4,
        image: ImageUrl(url: "assets/images/aya-pay.png"),
        icon: ImageUrl(url: "assets/images/aya-pay-circle.png"),
        marker: ImageUrl(url: "assets/images/aya-marker.png"),
        name: "Aya Pay")
  ];
  List<Post> posts = [
    Post(
        id: 1,
        type: Type(id: 1, name: 'Cash Out'),
        provider: Provider(
            id: 1,
            name: 'KBZ Pay',
            icon: ImageUrl(url: 'assets/images/kbz-pay-circle.png'),
            marker: ImageUrl(url: "assets/images/kbz-marker.png"),
            image: ImageUrl(url: 'assets/images/kbz-pay.png')),
        amount: 1000000,
        percentage: 3,
        phone: '09767947154',
        latLng: const LatLng(16.79729673247046, 96.13215959983089),
        distance: 3),
    Post(
        id: 1,
        type: Type(id: 1, name: 'Cash Out'),
        provider: Provider(
            id: 1,
            name: 'Aya Pay',
            icon: ImageUrl(url: 'assets/images/aya-pay-circle.png'),
            marker: ImageUrl(url: "assets/images/aya-marker.png"),
            image: ImageUrl(url: 'assets/images/aya-pay.png')),
        amount: 1000000,
        percentage: 3,
        phone: '09767947154',
        latLng: const LatLng(16.793922748028915, 96.13219677131646),
        distance: 3),
    Post(
        id: 1,
        type: Type(id: 1, name: 'Cash Out'),
        provider: Provider(
            id: 1,
            name: 'Wave Pay',
            icon: ImageUrl(url: 'assets/images/wave-pay-circle.png'),
            marker: ImageUrl(url: "assets/images/wave-marker.png"),
            image: ImageUrl(url: 'assets/images/wave-pay.png')),
        amount: 1000000,
        percentage: 3,
        phone: '09767947154',
        latLng: const LatLng(16.800179334591768, 96.13606352271559),
        distance: 3),
    Post(
        id: 1,
        type: Type(id: 1, name: 'Cash Out'),
        provider: Provider(
            id: 1,
            name: 'CB Pay',
            icon: ImageUrl(url: 'assets/images/cb-pay-circle.png'),
            marker: ImageUrl(url: "assets/images/cb-marker.png"),
            image: ImageUrl(url: 'assets/images/cb-pay.png')),
        amount: 1000000,
        percentage: 3,
        phone: '09767947154',
        latLng: const LatLng(16.79962246841343, 96.13262424796903),
        distance: 3),
  ];
  late GoogleMapController mapController;

  late Marker myLocation;

  bool mapsType = true;
  bool switching = false;

  @override
  void initState() {
    super.initState();
    loadData();
    _getCurrentPosition();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  loadData() async {
    myLocation = Marker(
        markerId: const MarkerId("my-location"),
        icon: BitmapDescriptor.fromBytes(
            await getImages("assets/images/my-location.png", 200)),
        position: _center);
    _markers.add(myLocation);
    for (int i = 0; i < posts.length; i++) {
      final Uint8List markIcons =
          await getImages(posts[i].provider.marker.url, 200);
      // makers added according to index
      _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.fromBytes(markIcons),
          position: posts[i].latLng,
          consumeTapEvents: true,
          onTap: () {
            Post post = posts[i];
            _customInfoWindowController.addInfoWindow!(
              MarkerWindow(
                  post: posts[i],
                  infoWindowController: _customInfoWindowController),
              posts[i].latLng,
            );
          }));
      setState(() {});
    }
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _markers[0] = Marker(
          markerId: const MarkerId("my-location"),
          icon: BitmapDescriptor.fromBytes(
              await getImages("assets/images/my-location.png", 200)),
          position: LatLng(position.latitude, position.longitude));
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 18,
            target: LatLng(
              position.latitude,
              position.longitude,
            ),
          ),
        ),
      );
    }).catchError((e) {
      debugPrint(e);
    });
  }

  // Future<void> _getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(position.latitude, position.longitude)
  //       .then((List<Placemark> placemarks) {
  //     Placemark place = placemarks[0];
  //     setState(() {
  //       //  _currentAddress =
  //       //      '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
  //     });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            if (mapsType && !switching)
              Container(
                  margin: const EdgeInsets.all(10),
                  child: FloatingActionButton(
                    onPressed: () {
                      _getCurrentPosition();
                    },
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.my_location,
                        color: AppColor.primaryColor),
                  )),
            Container(
                margin: const EdgeInsets.all(10),
                child: FloatingActionButton(
                  onPressed: () async {
                    _customInfoWindowController.hideInfoWindow!();
                    if (!switching) {
                      setState(() {
                        switching = true;
                      });
                      await Future.delayed(const Duration(milliseconds: 1000));
                      setState(() {
                        switching = false;
                        mapsType = mapsType ? false : true;
                      });
                    }
                  },
                  backgroundColor: AppColor.primaryColor,
                  child: Icon(mapsType ? Icons.list : Icons.map,
                      color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: <Widget>[
            _mapsOrList(),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 370,
              width: 250,
              offset: 50,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 16.0),
                child: Column(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                            side: const BorderSide(
                                color: Colors.white24, width: 1)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 5, 10, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SearchPage()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.search,
                                        size: 24,
                                        color: Colors.black45,
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        AppLocalizations.of(context)!.search,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: Colors.black45,
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      height: 32,
                                      width: 32,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const NotificationPage()));
                                        },
                                        child: const Icon(Icons.notifications,
                                            size: 24, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 46,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        children: types
                            .map((type) => FloatButton(
                                  title: type.name,
                                  icon: type.icon.url,
                                  onSelected: (selected) {},
                                ))
                            .toList(),
                      ),
                    )
                  ],
                )),
          ],
        ));
  }

  Widget _mapsOrList() {
    return (switching)
        ? const Center(child: CircularProgressIndicator())
        : mapsType
            ? GoogleMap(
                onTap: (position) {
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position) {
                  _customInfoWindowController.onCameraMove!();
                },
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) async {
                  mapController = controller;
                  _customInfoWindowController.googleMapController = controller;
                },
                markers: Set<Marker>.of(_markers),
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 18.0,
                ),
              )
            : Container(
                margin: const EdgeInsets.only(top: 172),
                clipBehavior: Clip.none,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  clipBehavior: Clip.none,
                  children: [...posts.map((post) => PostItem(post: post))],
                ),
              );
  }
}
