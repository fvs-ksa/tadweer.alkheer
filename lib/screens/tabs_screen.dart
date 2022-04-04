// Here is the first page with the bottom navigation bar.
// need to change the icons and the colors when tapped.
//flutter gen-l10n

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/models/points.dart';
import 'package:tadweer_alkheer/providers/donation_points_provider.dart';
import 'package:tadweer_alkheer/screens/driver_home_screen.dart';
import 'package:tadweer_alkheer/screens/more_screen.dart';
import 'package:tadweer_alkheer/screens/my_tasks_screen.dart';
import 'package:tadweer_alkheer/screens/myprofile_screen.dart';
import 'package:tadweer_alkheer/screens/points_map.dart';
import '../models/donation_point.dart';
import './home_screen.dart';
import './my_donations_screen.dart';
import './settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/users_provider.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as TKDUser;
import '../widgets/app_drawer.dart';
import 'package:share/share.dart';
import 'more_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';

  int index;

  TabsScreen(this.index);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages = [];
  TKDUser.User thisUser;

  void _selectPage(int index) async {
    setState(() {
      widget.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final donationsProvider = Provider.of<DonationPointsProvider>(context);

    _pages = [
      {
        'page': MyProfileScreen(),
        'title': AppLocalizations.of(context).profile
      },
      {
        'page': HomeScreen(),
        'title': thisUser != null
            ? (thisUser.type == "driver"
                ? AppLocalizations.of(context).mytasks
                : AppLocalizations.of(context).home)
            : AppLocalizations.of(context).home,
      },
      {'page': Morescreen(), 'title': AppLocalizations.of(context).more},
      /*
      {
        'page': MyProfileScreen(),
        'title': AppLocalizations.of(context).profile
      },
      */
      /*
      {
        'page': SettingsScreen(),
        'title': AppLocalizations.of(context).settings
      },
      */
      /*
      {'page': Morescreen(), 'title': AppLocalizations.of(context).more},
      */
    ];
    var userProvider = Provider.of<UsersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _pages[widget.index]['title'] as String,
          style: TextStyle(color: Theme.of(context).primaryColor),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            children: [
              Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(),
                  child: FirebaseAuth.instance.currentUser != null
                      ? StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('donationPoints')
                              .where('userId',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("");
                            }

                            var points = 0;
                            snapshot.data.docs.forEach((element) {
                              Map<String, dynamic> data =
                                  element.data() as Map<String, dynamic>;
                              print(
                                  "Osamaasssss ============ ${data["quantity"]}");
                              points += data["quantity"];
                            });

                            return Text(
                              "$points",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 20),
                            );
                          },
                        )
                      : SizedBox()),
              IconButton(
                icon: Icon(
                  Icons.share,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Share.share(
                      "حمل تطبيق تدوير الخير وأنشر الابتسامة للأسر المحتاجة \n https://play.google.com/store/apps/details?id=com.tadweer.alkheer");
                },
              ),
            ],
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      drawer: Drawer(
          child: FirebaseAuth.instance.currentUser != null
              ? FutureBuilder(
                  future: userProvider
                      .getUserById(FirebaseAuth.instance.currentUser.uid),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.hasData) {
                      thisUser = userSnapshot.data;
                      return AppDrawer(true);
                    } else {
                      return AppDrawer(false);
                    }
                  })
              : AppDrawer(false)),
      body: FirebaseAuth.instance.currentUser != null
          ? FutureBuilder(
              future: userProvider
                  .getUserById(FirebaseAuth.instance.currentUser.uid),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (userSnapshot.hasData) {
                  thisUser = userSnapshot.data;
                  if (thisUser.type == "donor") {
                    _pages = [

                      {
                        'page': HomeScreen(),
                        'title': AppLocalizations.of(context).home
                      },
                      {
                        'page': MyProfileScreen(),
                        'title': AppLocalizations.of(context).profile
                      },
                      {
                        'page': Morescreen(),
                        'title': AppLocalizations.of(context).more
                      },
                      /*
                        {
                          'page': MyDonationsScreen(),
                          'title': AppLocalizations.of(context).mydonations
                        },
                        */

                      /*
                        {
                          'page': PointsMapScreen(),
                          'title': AppLocalizations.of(context).markedPoint
                        },
                        */
                      /*
                        {
                          'page': MyProfileScreen(),
                          'title': AppLocalizations.of(context).profile
                        },
                        */
                      /*
                        {
                          'page': SettingsScreen(),
                          'title': AppLocalizations.of(context).settings
                        },
                        */
                    ];
                  } else if (thisUser.type == "driver") {
                    _pages = [
                      {
                        'page': DriverHomeScreen(),
                        'title': AppLocalizations.of(context).home
                      },
                      {'page': MyTasksScreen(), 'title': "My Tasks"},
                      {
                        'page': MyProfileScreen(),
                        'title': AppLocalizations.of(context).profile
                      },
                      {
                        'page': SettingsScreen(),
                        'title': AppLocalizations.of(context).settings
                      },
                    ];
                  }
                }
                return _pages[widget.index]['page'] as Widget;
              })
          : _pages[widget.index]['page'] as Widget,
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.green,
        items: [
          TabItem(
              icon: Icons.dashboard,
              title: AppLocalizations.of(context).profile),
          TabItem(icon: Icons.home, title: AppLocalizations.of(context).home),
          TabItem(
              icon: Icons.more_horiz, title: AppLocalizations.of(context).more),
        ],
        onTap: _selectPage,
        initialActiveIndex: 1,
        /*
        type: BottomNavigationBarType.fixed,
        
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        currentIndex: widget.index,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.dashboard,
              color: widget.index == 0
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            label: AppLocalizations.of(context).profile,
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.home,
              color: widget.index == 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            label: AppLocalizations.of(context).home,
          ),
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.more_horiz_sharp,
              color: widget.index == 2
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            label: AppLocalizations.of(context).more,
          ),
          /*
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.favorite,
              color: widget.index == 1
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            label: thisUser != null
                ? (thisUser.type == "driver"
                    ? AppLocalizations.of(context).tasks
                    : AppLocalizations.of(context).donations)
                : "${AppLocalizations.of(context).donations}",
          ),
          */
          /*
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.location_on,
              color: widget.index == 2
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            label: AppLocalizations.of(context).markedPoint,
          ),
          */

          /*
          BottomNavigationBarItem(
            //backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.settings,
              color: widget.index == 4
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            label: AppLocalizations.of(context).settings,
          ),
          */
        ],
        */
      ),
    );
  }
}
