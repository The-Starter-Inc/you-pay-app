// ignore_for_file: must_be_immutable

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/theme/color_theme.dart';
import 'package:widget_marquee/widget_marquee.dart';
import 'package:p2p_pay/src/blocs/post_bloc.dart';
import 'package:p2p_pay/src/models/notification_event.dart';
import 'package:p2p_pay/src/ui/notification_page.dart';
import 'package:p2p_pay/src/ui/search_page.dart';
import 'package:p2p_pay/src/ui/widgets/post_item.dart';
import 'package:event/event.dart';
import '../blocs/sponsor_bloc.dart';
import '../constants/app_constant.dart';
import '../models/post.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final db = Localstore.instance;
  late List<String> filterProviders = [];
  final Event notiEvent = Event<NotificationEvent>();
  // final ProviderBloc providerBloc = ProviderBloc();
  final PostBloc postBloc = PostBloc();
  final SponsorBloc sponsorBloc = SponsorBloc();
  List<Provider> types = [];
  List<Post> posts = [];
  late GoogleMapController mapController;

  late Marker myLocation;

  bool mapsType = false;
  bool switching = false;
  bool hasNotification = false;
  int notificationCounts = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    //providerBloc.fetchProviders();
    postBloc.fetchPosts(null, "status:equal:true");
    sponsorBloc.fetchSponsors("marquee");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Localstore.instance
          .collection('notifications')
          .doc(message.messageId)
          .set(message.toMap());
      if (message.data['type'] != 'message') {
        setState(() {
          hasNotification = true;
          notificationCounts += 1;
        });
      }
    });
    final notifications = await db.collection('notifications').get();
    if (notifications != null &&
        notifications.keys
            .where((key) => notifications[key]['data']['type'] != 'message')
            .isNotEmpty) {
      setState(() {
        //AppConstant.hasNotification = true;
        hasNotification = true;
        notificationCounts = notifications.keys
            .where((key) => notifications[key]['data']['type'] == 'message')
            .length;
      });
    }
  }

  @override
  void dispose() {
    // providerBloc.dispose();
    postBloc.dispose();
    notiEvent.unsubscribeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        StreamBuilder(
            stream: postBloc.posts,
            builder: (context, AsyncSnapshot<List<Post>> snapshot) {
              if (snapshot.hasData) {
                if (AppConstant.you != null) {
                  if (AppConstant.you!.name != 'All Provider' &&
                      AppConstant.pay!.name != 'All Provider') {
                    posts = snapshot.data!
                        .where((post) =>
                            post.providers.length > 1 &&
                            post.adsUser != null &&
                            post.providers[1].name == AppConstant.you!.name &&
                            post.providers[0].name == AppConstant.pay!.name)
                        .toList();
                  } else if (AppConstant.you!.name == 'All Provider' &&
                      AppConstant.pay!.name != 'All Provider') {
                    posts = snapshot.data!
                        .where((post) =>
                            post.providers.length > 1 &&
                            post.adsUser != null &&
                            post.providers[0].name == AppConstant.pay!.name)
                        .toList();
                  } else if (AppConstant.you!.name != 'All Provider' &&
                      AppConstant.pay!.name == 'All Provider') {
                    posts = snapshot.data!
                        .where((post) =>
                            post.providers.length > 1 &&
                            post.adsUser != null &&
                            post.providers[1].name == AppConstant.you!.name)
                        .toList();
                  } else {
                    posts = snapshot.data!
                        .where((post) =>
                            post.providers.length > 1 && post.adsUser != null)
                        .toList();
                  }
                } else {
                  posts = snapshot.data!
                      .where((post) =>
                          post.providers.length > 1 && post.adsUser != null)
                      .toList();
                }

                return _buildList();
              }
              return Container();
            }),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Search Toolbar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            setState(() {
                              AppConstant.you = result[0];
                              AppConstant.pay = result[1];
                            });

                            postBloc.fetchPosts(null, "status:equal:true");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 5, 10, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      if (AppConstant.you != null)
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
                                          child: const Icon(Icons.notifications,
                                              size: 24, color: Colors.black),
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
                          int durations =
                              snapshot.data!.fold(0, (a, b) => a + b.timeout);
                          List<Widget> sponsors = snapshot.data!
                              .map((e) => Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/marketing.png",
                                          width: 24),
                                      const SizedBox(width: 16),
                                      Text(e.title!,
                                          style: const TextStyle(
                                              color: AppColor.secondaryColor,
                                              fontFamily: 'Pyidaungsu'))
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

  Widget _buildList() {
    return Container(
      margin: const EdgeInsets.only(top: 150),
      clipBehavior: Clip.none,
      child: posts.isNotEmpty
          ? ListView(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              // clipBehavior: Clip.none,
              children: [...posts.map((post) => PostItem(post: post))],
            )
          : Center(
              child: Text(AppLocalizations.of(context)!.no_data,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black45)),
            ),
    );
  }
}
