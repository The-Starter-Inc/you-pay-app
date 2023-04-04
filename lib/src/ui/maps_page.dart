import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/blocs/post_bloc.dart';
import 'package:p2p_pay/src/blocs/sponsor_bloc.dart';
import 'package:p2p_pay/src/models/notification_event.dart';
import 'package:p2p_pay/src/theme/color_theme.dart';
import 'package:p2p_pay/src/ui/notification_page.dart';
import 'package:p2p_pay/src/ui/search_page.dart';
import 'package:p2p_pay/src/ui/widgets/marker_window.dart';
import 'package:p2p_pay/src/ui/widgets/post_item.dart';
import 'package:event/event.dart';
import 'package:widget_marquee/widget_marquee.dart';
import '../blocs/provider_bloc.dart';
import '../constants/app_constant.dart';
import '../models/post.dart';

class MapsPage extends StatefulWidget {
  late Provider? you;
  late Provider? pay;
  MapsPage({super.key, this.you, this.pay});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final db = Localstore.instance;
  late List<String> filterProviders = [];
  late LatLng _center = const LatLng(16.79729673247046, 96.13215959983089);
  final Event notiEvent = Event<NotificationEvent>();
  final ProviderBloc providerBloc = ProviderBloc();
  final SponsorBloc sponsorBloc = SponsorBloc();
  final PostBloc postBloc = PostBloc();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  List<Provider> types = [];
  List<Post> posts = [];
  late GoogleMapController mapController;

  late Marker myLocation;

  bool mapsType = true;
  bool switching = false;
  bool hasNotification = false;
  int notificationCounts = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _getCurrentPosition();
    AppConstant.you = widget.you ?? AppConstant.you;
    AppConstant.pay = widget.pay ?? AppConstant.pay;
    providerBloc.fetchProviders();
    postBloc.fetchPosts(null, "status:equal:true");
    sponsorBloc.fetchSponsors("marquee");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Localstore.instance
          .collection('notifications')
          .doc(message.messageId)
          .set(message.toMap());
      setState(() {
        //AppConstant.hasNotification = true;
        if (message.data['type'] != 'message') {
          hasNotification = true;
          notificationCounts += 1;
        }
      });
    });
    // setState(() {
    //   hasNotification = AppConstant.hasNotification;
    // });
    final notifications = await db.collection('notifications').get();
    if (notifications != null &&
        notifications.keys
            .where((key) => notifications[key]['data']['type'] != 'message')
            .isNotEmpty) {
      setState(() {
        //AppConstant.hasNotification = true;
        hasNotification = true;
        notificationCounts = notifications.keys
            .where((key) => notifications[key]['data']['type'] != 'message')
            .length;
      });
    }
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    mapController.dispose();
    providerBloc.dispose();
    postBloc.dispose();
    notiEvent.unsubscribeAll();
    super.dispose();
  }

  Future<Set<Marker>> addMarkers() async {
    List<Marker> markers = [];
    myLocation = Marker(
        markerId: const MarkerId("my-location"),
        icon: BitmapDescriptor.fromBytes(
            await getImages("assets/images/my-location.png", 200)),
        position: _center);
    markers.add(myLocation);
    for (int i = 0; i < posts.length; i++) {
      // makers added according to index
      markers.add(Marker(
          markerId: MarkerId(posts[i].id.toString()),
          icon: BitmapDescriptor.fromBytes(await getBestterImage(
              posts[i].adsUserId != AppConstant.firebaseUser!.uid
                  ? posts[i].providers[1].name
                  : posts[i].providers[0].name,
              posts[i].adsUserId != AppConstant.firebaseUser!.uid
                  ? posts[i].providers[1].marker!.url
                  : posts[i].providers[0].marker!.url)),
          position: posts[i].latLng,
          consumeTapEvents: true,
          onTap: () {
            mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  zoom: 20,
                  target: posts[i].latLng,
                ),
              ),
            );
            _customInfoWindowController.addInfoWindow!(
              MarkerWindow(
                post: posts[i],
                infoWindowController: _customInfoWindowController,
              ),
              posts[i].latLng,
            );
          }));
    }

    return markers.toSet();
  }

  Future<Uint8List> getBestterImage(providerName, url) async {
    switch (providerName) {
      case "KBZ Pay":
        return await getImages("assets/images/kbz-marker.png", 200);
      case "Aya Pay":
        return await getImages("assets/images/aya-marker.png", 200);
      case "Wave Pay":
        return await getImages("assets/images/wave-marker.png", 200);
      case "CB Pay":
        return await getImages("assets/images/cb-marker.png", 200);
      default:
        return await getImageUrl(url, 200);
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

  Future<Uint8List> getImageUrl(String path, int width) async {
    final Uint8List data =
        (await NetworkAssetBundle(Uri.parse(path)).load(path))
            .buffer
            .asUint8List();
    ui.Codec codec = await ui.instantiateImageCodec(data, targetHeight: width);
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
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
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
    }).catchError((e) {});
  }

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
                        color: AppColor.secondaryColor),
                  )),
          ],
        ),
        body: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: postBloc.posts,
                builder: (context, AsyncSnapshot<List<Post>> snapshot) {
                  if (snapshot.hasData) {
                    posts = AppConstant.pay!.name != 'All Provider'
                        ? snapshot.data!
                            .where((post) =>
                                post.providers.length > 1 &&
                                widget.you != null &&
                                widget.pay != null &&
                                post.providers[1].name ==
                                    AppConstant.you!.name &&
                                post.providers[0].name == AppConstant.pay!.name)
                            .toList()
                        : snapshot.data!
                            .where((post) =>
                                post.providers.length > 1 &&
                                widget.you != null &&
                                post.providers[1].name == AppConstant.you!.name)
                            .toList();
                    addMarkers();
                    return _mapsOrList();
                  }
                  return Container();
                }),
            CustomInfoWindow(
              controller: _customInfoWindowController,
              height: 350,
              width: 250,
              offset: 50,
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 16.0),
                child: Column(
                  children: [
                    // Search Toolbar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                              side: const BorderSide(
                                  color: Colors.white24, width: 1)),
                          child: InkWell(
                              onTap: () async {
                                List<dynamic> result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SearchPage(isPop: true)));

                                AppConstant.you = result[0];
                                AppConstant.pay = result[1];
                                postBloc.fetchPosts(null, "status:equal:true");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                width: double.infinity,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 5, 10, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.search,
                                            size: 24,
                                            color: Colors.black45,
                                          ),
                                          const SizedBox(width: 16),
                                          if (widget.you != null)
                                            Text(
                                              "${AppConstant.you!.name}, ${AppConstant.pay!.name}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontFamily: 'Pyidaungsu'),
                                            )
                                          else
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .tap_search,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                      color: Colors.black45,
                                                      fontFamily: 'Pyidaungsu'),
                                            )
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            height: 32,
                                            width: 32,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  notificationCounts = 0;
                                                  hasNotification = false;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const NotificationPage()));
                                              },
                                              child: const Icon(
                                                  Icons.notifications,
                                                  size: 24,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ))),
                    ),
                    const SizedBox(height: 8),
                    // Provider List
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(119, 23, 52, 64),
                      ),
                      height: 40,
                      child: StreamBuilder(
                          stream: sponsorBloc.sponsors,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              int durations = snapshot.data!
                                  .fold(0, (a, b) => a + b.timeout);
                              List<Widget> sponsors = snapshot.data!
                                  .map((e) => Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              "assets/images/marketing.png",
                                              width: 24),
                                          const SizedBox(width: 16),
                                          Text(e.title!)
                                        ],
                                      )))
                                  .toList();

                              return Marquee(
                                gap: 24,
                                loopDuration: Duration(milliseconds: durations),
                                child: Row(
                                  children: sponsors,
                                ),
                              );
                            }
                            return Container();
                          }),
                    ),
                  ],
                )),
            if (hasNotification && notificationCounts > 0)
              Positioned(
                  top: 50,
                  right: 24,
                  width: 24,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        hasNotification = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage()));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        padding:
                            const EdgeInsets.only(left: 2, right: 2, bottom: 1),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text("$notificationCounts",
                            style: const TextStyle(color: Colors.white))),
                  ))
          ],
        ));
  }

  Widget _mapsOrList() {
    return (switching)
        ? Center(child: Image.asset("assets/images/loading.gif", width: 100))
        : mapsType
            ? FutureBuilder(
                future: addMarkers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GoogleMap(
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove!();
                      },
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (GoogleMapController controller) async {
                        mapController = controller;
                        _customInfoWindowController.googleMapController =
                            controller;
                      },
                      markers: snapshot.data!,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 17.5,
                      ),
                    );
                  }
                  return Center(
                      child:
                          Image.asset("assets/images/loading.gif", width: 100));
                })
            : Container(
                margin: const EdgeInsets.only(top: 172),
                clipBehavior: Clip.none,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  // clipBehavior: Clip.none,
                  children: [...posts.map((post) => PostItem(post: post))],
                ),
              );
  }
}
