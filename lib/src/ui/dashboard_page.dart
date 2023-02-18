import 'dart:ui' as ui;
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/models/bank.dart';
import 'package:p2p_pay/src/theme/color_theme.dart';
import 'package:p2p_pay/src/ui/chat_page.dart';
import 'package:p2p_pay/src/ui/notification_page.dart';
import '../models/Post.dart';
import '../utils/map_util.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> _markers = <Marker>[];
  List<Bank> banks = [
    Bank(icon: "assets/images/kbz-pay-circle.png", name: "KBZ Pay"),
    Bank(icon: "assets/images/cb-pay-circle.png", name: "CB Pay"),
    Bank(icon: "assets/images/wave-pay-circle.png", name: "Wave Pay"),
    Bank(icon: "assets/images/aya-pay-circle.png", name: "Aya Pay")
  ];
  List<Post> posts = [
    Post(
        icon: 'assets/images/aya-marker.png',
        phone: '0982342342342',
        latLng: const LatLng(27.6602292, 85.308027)),
    Post(
        icon: 'assets/images/cb-marker.png',
        phone: '0982342342342',
        latLng: const LatLng(27.6599592, 85.3102498)),
    Post(
        icon: 'assets/images/wave-marker.png',
        phone: '0982342342342',
        latLng: const LatLng(27.659470, 85.3077363)),
    Post(
        icon: 'assets/images/kbz-marker.png',
        phone: '0982342342342',
        latLng: const LatLng(27.65964100546146, 85.30831566390248))
  ];
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(27.6602292, 85.308027);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  loadData() async {
    for (int i = 0; i < posts.length; i++) {
      final Uint8List markIcons = await getImages(posts[i].icon, 200);
      // makers added according to index
      _markers.add(Marker(
          markerId: MarkerId(i.toString()),
          icon: BitmapDescriptor.fromBytes(markIcons),
          position: posts[i].latLng,
          onTap: () {
            _customInfoWindowController.addInfoWindow!(
              Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    _customInfoWindowController
                                        .hideInfoWindow!();
                                  },
                                  child: const Icon(Icons.close,
                                      size: 18, color: Colors.black45),
                                ),
                              ),
                              Center(
                                child: Image.asset('assets/images/kbz-pay.png',
                                    width: 50, height: 50),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Text(
                                  "KBZ Pay",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Service",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "Cash Pay",
                                    textAlign: TextAlign.right,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black45,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Amount",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "10,000,000 MMK",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black45,
                                        ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Percentage",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "3 %",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black45,
                                        ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Phone",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "09 767 947 154",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black45,
                                        ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Distance",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Text(
                                    "3 km",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                          color: Colors.black45,
                                        ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      MapUtils.openMap(posts[i].latLng.latitude,
                                          posts[i].latLng.longitude);
                                    },
                                    child: const Text('Direction'),
                                  ),
                                  const SizedBox(width: 16),
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.lightBlue),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blue),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage()),
                                      );
                                    },
                                    child: const Text('Contact Me',
                                        style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                  Triangle.isosceles(
                    edge: Edge.BOTTOM,
                    child: Container(
                      color: Colors.white,
                      width: 20.0,
                      height: 10.0,
                    ),
                  ),
                ],
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          onTap: (position) {
            _customInfoWindowController.hideInfoWindow!();
          },
          onCameraMove: (position) {
            _customInfoWindowController.onCameraMove!();
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (GoogleMapController controller) async {
            mapController = controller;
            _customInfoWindowController.googleMapController = controller;
          },
          markers: Set<Marker>.of(_markers),
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 18.0,
          ),
        ),
        CustomInfoWindow(
          controller: _customInfoWindowController,
          height: 340,
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
                        side:
                            const BorderSide(color: Colors.white24, width: 1)),
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
                            Row(
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
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  height: 32,
                                  width: 32,
                                  child: GestureDetector(
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
                    children: banks
                        .map((bank) => Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: AppColor.primaryColor, width: 1),
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                        backgroundImage: AssetImage(bank.icon)),
                                    const SizedBox(width: 5),
                                    Text(
                                      bank.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.black45,
                                          ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(Icons.check,
                                        size: 16, color: AppColor.primaryColor)
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  ListTile(
                                    title: Text(
                                      AppLocalizations.of(context)!.filter,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Colors.black45,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 0, 16, 32),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .service,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Colors.black45,
                                                  ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 80,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      side: const BorderSide(
                                                          color: AppColor
                                                              .primaryColor,
                                                          width: 1)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 32,
                                                          height: 32,
                                                          child: Image.asset(
                                                              "assets/images/cash-out.png"),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .cash_out,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(width: 8),
                                              Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      side: const BorderSide(
                                                          color: Colors.black45,
                                                          width: 1)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 32,
                                                          height: 32,
                                                          child: Image.asset(
                                                              "assets/images/exchange-money.png"),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .exchange_money,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .charge,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: Colors.black45,
                                                  ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 80,
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            clipBehavior: Clip.none,
                                            children: [
                                              Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      side: const BorderSide(
                                                          color: AppColor
                                                              .primaryColor,
                                                          width: 1)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.attach_money,
                                                            size: 32,
                                                            color:
                                                                Colors.black45),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .fixed_amount,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                              const SizedBox(width: 8),
                                              Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      side: const BorderSide(
                                                          color: Colors.black45,
                                                          width: 1)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.percent,
                                                            size: 32,
                                                            color:
                                                                Colors.black45),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .percentage,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.filter_alt_outlined,
                                size: 24, color: Colors.black87)),
                      ),
                    )
                  ],
                )
              ],
            )),
      ],
    ));
  }
}
