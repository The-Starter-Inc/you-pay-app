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
import 'package:p2p_pay/src/models/post_event.dart';
import 'package:p2p_pay/src/ui/success_page.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../models/dropdown.dart';
import '../../theme/text_size.dart';
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

  TextEditingController typeController = TextEditingController(text: "");
  TextEditingController providerYouController = TextEditingController(text: "");
  TextEditingController providerPayController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController phoneController =
      TextEditingController(text: AppConstant.currentUser!.phone);
  TextEditingController chargesTypeController =
      TextEditingController(text: "percentage");
  TextEditingController percentageController = TextEditingController();
  TextEditingController fixAmountController = TextEditingController();
  TextEditingController exchangeRateController = TextEditingController();
  TextEditingController latLngController = TextEditingController();

  late bool checkFormError = false;
  Error frmError = Error(null, null, null, null, null, null);

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
    providerYouController.addListener(() {
      validationError();
      providerPayController.text = "";
      setState(() {});
    });
    chargesTypeController.addListener(() {
      validationError();
      setState(() {});
    });
    if (widget.post != null) {
      initData();
    }
  }

  void initData() {
    typeController.text = "${widget.post!.type!.id}";
    providerYouController.text = "${widget.post!.providers[0].id}";
    providerPayController.text =
        "${widget.post!.providers.length > 1 ? widget.post!.providers[1].id : ''}";
    amountController.text = "${widget.post!.amount}";
    chargesTypeController.text = widget.post!.chargesType;
    percentageController.text = "${widget.post!.percentage}";
    fixAmountController.text = "${widget.post!.fees}";
    exchangeRateController.text = "${widget.post!.exchangeRate}";
    phoneController.text = widget.post!.phone;
    _currentPosition = widget.post!.latLng;
    _getAddressFromLatLng(_currentPosition!);
  }

  List<Provider> getSelectedProviderYouPay() {
    var originProvidersYou = providers
        .where(
            (provider) => provider.id.toString() == providerYouController.text)
        .toList();
    var originProvidersPay = providers
        .where(
            (provider) => provider.id.toString() == providerPayController.text)
        .toList();
    List<Provider> selectedProviders = originProvidersYou + originProvidersPay;
    return selectedProviders;
  }

  bool validationError() {
    bool hasError = false;
    if (checkFormError) {
      clear();
      if (providerYouController.text.isEmpty) {
        hasError = true;
        frmError.you = AppLocalizations.of(context)!.pls_choose_you;
      }

      if (providerPayController.text.isEmpty) {
        hasError = true;
        frmError.pay = AppLocalizations.of(context)!.pls_choose_pay;
      }

      if (amountController.text.isEmpty) {
        hasError = true;
        frmError.amount = AppLocalizations.of(context)!.pls_enter_amount;
      }

      if (chargesTypeController.text.isEmpty) {
        hasError = true;
        frmError.chargesType = AppLocalizations.of(context)!.pls_choose_charge;
      }

      if (phoneController.text.isEmpty) {
        hasError = true;
        frmError.phone = AppLocalizations.of(context)!.pls_enter_contact_phone;
      }

      if (latLngController.text.isEmpty) {
        hasError = true;
        frmError.latlng = AppLocalizations.of(context)!.pls_enter_location;
      }
      setState(() {});
    }
    return hasError;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.post != null
                ? AppLocalizations.of(context)!.edit_post
                : AppLocalizations.of(context)!.add_new_post),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: MultiStreamBuilder(
              streams: [typeBloc.types, providerBloc.providers],
              builder: (context, dataList) {
                if (dataList[0] != null && dataList[1] != null) {
                  providers = dataList[1];
                  return SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      // DropDownText(
                      //   label: AppLocalizations.of(context)!.type,
                      //   placeholder: AppLocalizations.of(context)!.choose_type,
                      //   controller: typeController,
                      //   errorText: frmError.type,
                      //   items: dataList[0],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                              child: DropDownText(
                            label: AppLocalizations.of(context)!.you,
                            placeholder:
                                AppLocalizations.of(context)!.choose_you,
                            controller: providerYouController,
                            errorText: frmError.you,
                            items: dataList[1],
                          )),
                          const SizedBox(width: 16),
                          Flexible(
                              child: DropDownText(
                                  label: AppLocalizations.of(context)!.pay,
                                  placeholder:
                                      AppLocalizations.of(context)!.choose_pay,
                                  controller: providerPayController,
                                  errorText: frmError.pay,
                                  items: dataList[1]))
                        ],
                      ),
                      InputText(
                        label: AppLocalizations.of(context)!.amount,
                        placeholder: AppLocalizations.of(context)!.enter_amount,
                        errorText: frmError.amount,
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                      Row(children: [
                        Flexible(
                            child: DropDownText(
                          label: AppLocalizations.of(context)!.charge,
                          placeholder:
                              AppLocalizations.of(context)!.choose_charge,
                          controller: chargesTypeController,
                          errorText: frmError.chargesType,
                          items: [
                            DropDown("percentage",
                                AppLocalizations.of(context)!.percentage, null),
                            DropDown(
                                "fix_amount",
                                AppLocalizations.of(context)!.fixed_amount,
                                null),
                            DropDown(
                                "exchange_rate",
                                AppLocalizations.of(context)!.exchange_rate,
                                null),
                          ],
                        )),
                        const SizedBox(width: 16),
                        if (chargesTypeController.text == 'percentage')
                          Flexible(
                              child: InputText(
                                  label:
                                      AppLocalizations.of(context)!.percentage,
                                  placeholder: AppLocalizations.of(context)!
                                      .enter_percentage,
                                  controller: percentageController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ]))
                        else if (chargesTypeController.text == 'fix_amount')
                          Flexible(
                              child: InputText(
                                  label: AppLocalizations.of(context)!
                                      .fixed_amount,
                                  placeholder: AppLocalizations.of(context)!
                                      .enter_fixed_amount,
                                  controller: fixAmountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ]))
                        else
                          Flexible(
                              child: InputText(
                                  label: AppLocalizations.of(context)!
                                      .exchange_rate,
                                  placeholder: AppLocalizations.of(context)!
                                      .enter_exchange_rate,
                                  controller: exchangeRateController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ]))
                      ]),

                      InputText(
                          label: AppLocalizations.of(context)!.contact_phone,
                          placeholder:
                              AppLocalizations.of(context)!.enter_contact_phone,
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
                            size: 24),
                        onTap: () {
                          if (_currentPosition != null) {
                            setState(() {
                              validationError();
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
                                checkFormError = true;
                                if (!validationError()) {
                                  try {
                                    Post post = await postBloc
                                        .createAdsPost(widget.post != null
                                            ? {
                                                //Edit Record
                                                "id":
                                                    widget.post!.id.toString(),
                                                "type_id": "2",
                                                "amount": amountController.text,
                                                "charges_type":
                                                    chargesTypeController.text,
                                                "percentage":
                                                    percentageController
                                                            .text.isEmpty
                                                        ? "0"
                                                        : percentageController
                                                            .text,
                                                "fees": fixAmountController
                                                        .text.isEmpty
                                                    ? "0"
                                                    : fixAmountController.text,
                                                "exchange_rate":
                                                    exchangeRateController
                                                            .text.isEmpty
                                                        ? "0"
                                                        : exchangeRateController
                                                            .text,
                                                "phone": phoneController.text,
                                                "providers": jsonEncode(
                                                    Provider.toJsonArray(
                                                        getSelectedProviderYouPay())),
                                                "lat": _currentPosition!
                                                    .latitude
                                                    .toString(),
                                                "lng": _currentPosition!
                                                    .longitude
                                                    .toString(),
                                                "distance": "0",
                                                "ads_user_id": AppConstant
                                                    .firebaseUser!.uid,
                                                "ads_device_id":
                                                    await PlatformDeviceId
                                                        .getDeviceId,
                                                "ads_user": jsonEncode(
                                                    AppConstant.currentUser!
                                                        .toJson()),
                                                "status":
                                                    "${widget.post!.status}"
                                              }
                                            : {
                                                //New Record
                                                "type_id": "2",
                                                "amount": amountController.text,
                                                "charges_type":
                                                    chargesTypeController.text,
                                                "percentage":
                                                    percentageController
                                                            .text.isEmpty
                                                        ? "0"
                                                        : percentageController
                                                            .text,
                                                "fees": fixAmountController
                                                        .text.isEmpty
                                                    ? "0"
                                                    : fixAmountController.text,
                                                "exchange_rate":
                                                    exchangeRateController
                                                            .text.isEmpty
                                                        ? "0"
                                                        : exchangeRateController
                                                            .text,
                                                "phone": phoneController.text,
                                                "providers": jsonEncode(
                                                    Provider.toJsonArray(
                                                        getSelectedProviderYouPay())),
                                                "lat": _currentPosition!
                                                    .latitude
                                                    .toString(),
                                                "lng": _currentPosition!
                                                    .longitude
                                                    .toString(),
                                                "distance": "0",
                                                "ads_user_id": AppConstant
                                                    .firebaseUser!.uid,
                                                "ads_device_id":
                                                    await PlatformDeviceId
                                                        .getDeviceId,
                                                "ads_user": jsonEncode(
                                                    AppConstant.currentUser!
                                                        .toJson()),
                                                "status": 'true'
                                              });

                                    await FirebaseAnalytics.instance.logEvent(
                                      name: widget.post != null
                                          ? "update_post"
                                          : "create_post",
                                      parameters: {},
                                    );
                                    AppConstant.postCreated
                                        .broadcast(PostEvent(post));
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SuccessPage()));
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
                      const SizedBox(height: 24),
                    ],
                  ));
                }
                return const Center(child: CircularProgressIndicator());
              })),
    );
  }

  void clear() {
    setState(() {
      frmError.you = null;
      frmError.pay = null;
      frmError.amount = null;
      frmError.phone = null;
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
            style: TextSize.size14),
        title: Text(
          'Error',
          style: TextSize.size18,
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
  late String? you;
  late String? pay;
  late String? amount;
  late String? phone;
  late String? latlng;
  late String? chargesType;

  Error(this.you, this.pay, this.amount, this.phone, this.latlng,
      this.chargesType);
}
