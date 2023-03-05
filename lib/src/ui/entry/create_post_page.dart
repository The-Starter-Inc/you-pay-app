// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multi_stream_builder/multi_stream_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:platform_device_id/platform_device_id.dart';

import './../../blocs/post_bloc.dart';
import './../../blocs/provider_bloc.dart';
import './../../blocs/type_bloc.dart';
import './../../constants/app_constant.dart';
import './../../ui/widgets/dropdown_text.dart';
import './../../ui/widgets/input_text.dart';
import './../../models/post.dart';
import './../../theme/color_theme.dart';

class CreatePostPage extends StatefulWidget {
  final Post? post;
  const CreatePostPage({super.key, this.post});

  @override
  // ignore: library_private_types_in_public_api
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  LatLng? _currentPosition;
  late List<Provider> providers;

  TextEditingController typeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController providerController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  TextEditingController latLngController = TextEditingController();

  Error frmError = Error(null, null, null, null, null);

  bool isLoading = false;
  TypeBloc typeBloc = TypeBloc();
  ProviderBloc providerBloc = ProviderBloc();
  PostBloc postBloc = PostBloc();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Post Create Page");
    _getCurrentPosition();
    typeBloc.fetchPosts();
    providerBloc.fetchProviders();
    if (widget.post != null) {
      initData();
    }
  }

  void initData() {
    typeController.text = "${widget.post!.type!.id}";
    providerController.text = "${widget.post!.providers[0].id}";
    amountController.text = "${widget.post!.amount}";
    percentageController.text = "${widget.post!.percentage}";
    phoneController.text = widget.post!.phone;
    _currentPosition = widget.post!.latLng;
    _getAddressFromLatLng(_currentPosition!);
  }

  List<Provider> getSelectedProvider() {
    providers.retainWhere(
        (provider) => provider.id.toString() == providerController.text);
    return providers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post != null
            ? AppLocalizations.of(context)!.edit_post
            : AppLocalizations.of(context)!.add_new_post),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: MultiStreamBuilder(
              streams: [typeBloc.types, providerBloc.providers],
              builder: (context, dataList) {
                if (dataList[0] != null && dataList[1] != null) {
                  providers = dataList[1];
                  return ListView(
                    children: <Widget>[
                      DropDownText(
                        label: AppLocalizations.of(context)!.type,
                        placeholder: AppLocalizations.of(context)!.choose_type,
                        controller: typeController,
                        errorText: frmError.type,
                        items: dataList[0],
                      ),
                      DropDownText(
                        label: AppLocalizations.of(context)!.provider,
                        placeholder:
                            AppLocalizations.of(context)!.choose_provider,
                        controller: providerController,
                        errorText: frmError.provider,
                        items: dataList[1],
                      ),
                      InputText(
                          label: AppLocalizations.of(context)!.amount,
                          placeholder:
                              AppLocalizations.of(context)!.enter_amount,
                          errorText: frmError.amount,
                          controller: amountController,
                          keyboardType: TextInputType.number),
                      InputText(
                          label: AppLocalizations.of(context)!.percentage,
                          placeholder:
                              AppLocalizations.of(context)!.enter_percentage,
                          controller: percentageController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ]),
                      InputText(
                          label: AppLocalizations.of(context)!.phone,
                          placeholder:
                              AppLocalizations.of(context)!.enter_phone,
                          errorText: frmError.phone,
                          controller: phoneController,
                          keyboardType: TextInputType.phone),
                      InputText(
                        label: AppLocalizations.of(context)!.location,
                        placeholder:
                            AppLocalizations.of(context)!.enter_location,
                        readOnly: true,
                        errorText: frmError.latlng,
                        controller: latLngController,
                        suffixIcon: const Icon(Icons.location_pin,
                            size: 24, color: Colors.black45),
                        onTap: () {
                          if (_currentPosition != null) {
                            setState(() {
                              frmError.latlng = null;
                            });
                            _getAddressFromLatLng(_currentPosition!);
                          } else {
                            showErrorAlert(AppLocalizations.of(context)!
                                .not_found_location);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor: MaterialStateProperty.all(
                                        AppColor.secondaryColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ))),
                                child: Text(
                                    AppLocalizations.of(context)!.cancel,
                                    style: const TextStyle(
                                        color: AppColor.secondaryColor)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                            height: 50, // <-- SEE HERE
                          ),
                          Expanded(
                              child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () async {
                                clear();
                                bool hasError = false;
                                if (typeController.text.isEmpty) {
                                  hasError = true;
                                  frmError.type = AppLocalizations.of(context)!
                                      .pls_enter_type;
                                }

                                if (amountController.text.isEmpty) {
                                  hasError = true;
                                  frmError.amount =
                                      AppLocalizations.of(context)!
                                          .pls_enter_amount;
                                }

                                if (phoneController.text.isEmpty) {
                                  hasError = true;
                                  frmError.phone = AppLocalizations.of(context)!
                                      .pls_enter_phone;
                                }

                                if (providerController.text.isEmpty) {
                                  hasError = true;
                                  frmError.provider =
                                      AppLocalizations.of(context)!
                                          .pls_choose_provider;
                                }

                                if (latLngController.text.isEmpty) {
                                  hasError = true;
                                  frmError.latlng =
                                      AppLocalizations.of(context)!
                                          .pls_enter_location;
                                }
                                setState(() {});

                                if (!hasError) {
                                  try {
                                    await postBloc.createAdsPost(widget.post !=
                                            null
                                        ? {
                                            //Edit Record
                                            "id": widget.post!.id.toString(),
                                            "type_id": typeController.text,
                                            "amount": amountController.text,
                                            "percentage": percentageController
                                                    .text.isEmpty
                                                ? "0"
                                                : percentageController.text,
                                            "phone": phoneController.text,
                                            "providers": jsonEncode(
                                                Provider.toJsonArray(
                                                    getSelectedProvider())),
                                            "lat": _currentPosition!.latitude
                                                .toString(),
                                            "lng": _currentPosition!.longitude
                                                .toString(),
                                            "distance": "0",
                                            "ads_user_id":
                                                AppConstant.firebaseUser!.uid,
                                            "ads_device_id":
                                                await PlatformDeviceId
                                                    .getDeviceId,
                                          }
                                        : {
                                            //New Record
                                            "type_id": typeController.text,
                                            "amount": amountController.text,
                                            "percentage": percentageController
                                                    .text.isEmpty
                                                ? "0"
                                                : percentageController.text,
                                            "phone": phoneController.text,
                                            "providers": jsonEncode(
                                                Provider.toJsonArray(
                                                    getSelectedProvider())),
                                            "lat": _currentPosition!.latitude
                                                .toString(),
                                            "lng": _currentPosition!.longitude
                                                .toString(),
                                            "distance": "0",
                                            "ads_user_id":
                                                AppConstant.firebaseUser!.uid,
                                            "ads_device_id":
                                                await PlatformDeviceId
                                                    .getDeviceId,
                                          });

                                    await FirebaseAnalytics.instance.logEvent(
                                      name: widget.post != null
                                          ? "update_post"
                                          : "create_post",
                                      parameters: {},
                                    );
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context, "_createdPost");
                                  } catch (e) {
                                    print(e);
                                  }
                                } else {
                                  print("Have empty error");
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(isLoading
                                          ? Colors.black45
                                          : AppColor.secondaryColor),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(isLoading
                                          ? Colors.black45
                                          : AppColor.secondaryColor),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ))),
                              child: Text(AppLocalizations.of(context)!.save,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                          )),
                        ],
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              })),
    );
  }

  void clear() {
    setState(() {
      frmError.type = null;
      frmError.amount = null;
      frmError.phone = null;
      frmError.provider = null;
      frmError.latlng = null;
    });
  }

  Future<void> showErrorAlert(message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
        content: Text(message,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                )),
        title: Text(
          'Error',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
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
      _currentPosition = LatLng(position.latitude, position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    Placemark place = placemarks[0];
    latLngController.text =
        '${place.thoroughfare ?? place.street}, ${place.subAdministrativeArea}';
  }
}

class Error {
  late String? type;
  late String? amount;
  late String? phone;
  late String? provider;
  late String? latlng;

  Error(this.type, this.amount, this.phone, this.provider, this.latlng);
}
