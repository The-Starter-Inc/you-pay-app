import 'package:flutter/material.dart';
import 'package:p2p_pay/src/ui/entry/create_post_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/color_theme.dart';
import 'profile_page.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  final List<Widget> screens = [const DashboardPage(), const ProfilePage()];

  void _onItemTapped(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: screens.elementAt(currentTab)),
        floatingActionButton: SizedBox(
          height: 64,
          width: 64,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostPage()),
              );
            },
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: const Icon(
              Icons.add,
              size: 32,
              color: AppColor.primaryColor,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: currentTab == 0
                      ? Container(
                          width: 64,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(124, 255, 255, 255),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(Icons.dashboard,
                              color: Colors.black, size: 24),
                        )
                      : const Icon(Icons.dashboard,
                          color: Color.fromARGB(198, 0, 0, 0)),
                  label: AppLocalizations.of(context)!.home),
              BottomNavigationBarItem(
                  icon: currentTab == 1
                      ? Container(
                          width: 64,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(124, 255, 255, 255),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.black, size: 24),
                        )
                      : const Icon(Icons.person,
                          color: Color.fromARGB(198, 0, 0, 0)),
                  label: AppLocalizations.of(context)!.profile)
            ],
            backgroundColor: AppColor.primaryColor,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentTab,
            selectedItemColor: Colors.black,
            iconSize: 30,
            onTap: _onItemTapped,
            elevation: 5));
  }
}
