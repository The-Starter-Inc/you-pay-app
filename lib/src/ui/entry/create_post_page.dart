import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:p2p_pay/src/ui/home_page.dart';
import 'dart:developer';
import 'dart:ui' as ui;

class CreatePostPage extends StatefulWidget {
  static const String routeName = '/post';

  const CreatePostPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // final _postBloc = PostBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class Error {
  late String type = "";
  late String amount = "";
  late String phone = "";
  late String provider = "";
  late String percentage = "";
  late String latlng = "";

  Error(this.type, this.amount, this.phone, this.provider, this.percentage,
      this.latlng);
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final List<Marker> _markers = <Marker>[];
  late GoogleMapController mapController;

  TextEditingController typeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController providerController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  TextEditingController latLngController = TextEditingController();

  Error frmError = Error("", "", "", "", "", "");

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Type",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),

            /// Drop Down
            DropdownButtonFormField(
              hint: const Text("Type"),
              autofocus: true,
              items:
                  <String>['ABCD', 'BDCEF', 'CDEF', 'DEFG'].map((String value) {
                return DropdownMenuItem(value: value, child: Text(value));
              }).toList(),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16, right: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(64),
                    ),
                  ),
                  label: Text("Chooose Type"),
                  floatingLabelBehavior: FloatingLabelBehavior.never),
              style: const TextStyle(color: Colors.black54),
              onChanged: (newValue) {
                typeController.text = newValue!;
                setState(() {
                  typeController.text = newValue;
                  frmError.type = "";
                });
              },
            ),
            Visibility(
              visible: frmError.type != "",
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  frmError.type,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Amount",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              autocorrect: false,
              controller: amountController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(64),
                  ),
                ),
                label: Text("Enter Amount"),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              style: const TextStyle(color: Colors.black54),
              onChanged: (newValue) {
                setState(() {
                  frmError.amount = "";
                });
              },
            ),
            Visibility(
              visible: frmError.amount != "",
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  frmError.amount,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Phone",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              autocorrect: false,
              autofocus: true,
              controller: phoneController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(64),
                  ),
                ),
                label: Text("Phone"),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              style: const TextStyle(color: Colors.black54),
              onChanged: (newValue) {
                setState(() {
                  frmError.phone = "";
                });
              },
            ),
            Visibility(
              visible: frmError.phone != "",
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  frmError.phone,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Provider",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),

            /// Drop Down
            DropdownButtonFormField(
              hint: const Text("Provider"),
              autofocus: true,
              items: <String>['Yoma', 'KBZ', 'AYA'].map((String value) {
                return DropdownMenuItem(
                  value: value,
                  // child: Text(value),
                  child: SizedBox(
                    width: 50,
                    child: Text(value),
                  ),
                );
              }).toList(),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16, right: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(64),
                    ),
                  ),
                  label: Text("Chooose Provider"),
                  floatingLabelBehavior: FloatingLabelBehavior.never),
              style: const TextStyle(color: Colors.black54),
              onChanged: (newValue) {
                providerController.text = newValue!;
                setState(() {
                  providerController.text = newValue;
                  frmError.provider = "";
                });
              },
            ),
            Visibility(
              visible: frmError.provider != "",
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  frmError.provider,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Percentage",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              autocorrect: false,
              autofocus: true,
              controller: percentageController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(64),
                  ),
                ),
                label: Text("Percentage"),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: const TextStyle(color: Colors.black54),
              onChanged: (newValue) {
                setState(() {
                  frmError.percentage = "";
                });
              },
            ),
            Visibility(
              visible: frmError.percentage != "",
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  frmError.percentage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Location",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              autocorrect: false,
              autofocus: true,
              controller: latLngController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(64),
                  ),
                ),
                label: Text("Location"),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              style: const TextStyle(color: Colors.black54),
              onChanged: (newValue) {
                setState(() {
                  frmError.latlng = "";
                });
              },
              onTap: () {
                _getCurrentPosition();
              },
            ),
            Visibility(
              visible: frmError.latlng != "",
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  frmError.latlng,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
              height: 50, // <-- SEE HERE
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor: MaterialStateProperty.all(Colors.blue),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.black)))),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 50, // <-- SEE HERE
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      clear();

                      if (typeController.text.isEmpty) {
                        setState(() {
                          frmError.type = "Please choose type";
                        });
                      }

                      if (amountController.text.isEmpty) {
                        setState(() {
                          frmError.amount = "Please enter amount";
                        });
                      }

                      if (phoneController.text.isEmpty) {
                        setState(() {
                          frmError.phone = "Please enter phone";
                        });
                      }

                      if (providerController.text.isEmpty) {
                        setState(() {
                          frmError.provider = "Please choose provider";
                        });
                      }

                      if (percentageController.text.isEmpty) {
                        setState(() {
                          frmError.percentage = "Please enter percentage";
                        });
                      }

                      if (latLngController.text.isEmpty) {
                        setState(() {
                          frmError.latlng =
                              "Please enter Latitude and Longtitude";
                        });
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        const BorderSide(color: Colors.blue)))),
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  void clear() {
    setState(() {
      frmError.type = "";
      frmError.amount = "";
      frmError.phone = "";
      frmError.provider = "";
      frmError.percentage = "";
      frmError.latlng = "";
    });
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
}
