// settings page

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadweer_alkheer/l10n/l10n.dart';
import 'package:tadweer_alkheer/providers/locale_provider.dart';
import 'package:tadweer_alkheer/screens/aboutus_screen.dart';
import 'package:tadweer_alkheer/screens/support_center.dart';
import 'package:tadweer_alkheer/widgets/language_selection.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/tabs_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Locale _language;
  static const String _privacyPolicyUrl =
      "https://sa-fvs.com/tadweer_alkhir_privacy_policy.html";

  void _selectLanguage() {
    showDialog(
        context: context,
        builder: (_) => new Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 0.25,
                margin: const EdgeInsets.all(10),
                child: LanguageSelection(_select),
              ),
            ));
    // final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    // localeProvider.setLocale(_language);
  }

  void _select(Locale pickedLanguage) {
    setState(() {
      _language = pickedLanguage;
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);

      localeProvider.setLocale(_language);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => TabsScreen(0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale;
    //print(currentLocale.languageCode + "!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).settingsTabBar),
        ),
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            Column(
              children: [Text(AppLocalizations.of(context).settingsTabBar)],
            );
            if (userSnapshot.hasData) {
              return Container(
                child: Material(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListView(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      children: [
                        ListTile(
                          leading: Icon(Icons.language),
                          title:
                              Text(AppLocalizations.of(context).languageword),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              currentLocale == null
                                  ? 'assets/images/gb.png'
                                  : L10n.getFlag(currentLocale.languageCode),
                              //'assets/images/gb.png',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          onTap: _selectLanguage,
                        ),
                        ListTile(
                          leading: Icon(Icons.lock),
                          title: Text(AppLocalizations.of(context).privacy),
                          onTap: () {
                            _showPrivacyWebpage();
                          },
                        ),
                        /*
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text(AppLocalizations.of(context).aboutus),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              AboutUsScreen.routeName,
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.contact_support),
                          title:
                              Text(AppLocalizations.of(context).supportcenter),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              SupportCenter.routeName,
                            );
                          },
                        ),
                        */
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text(AppLocalizations.of(context).logout),
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text(AppLocalizations.of(context).languageword),
                    trailing: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        currentLocale == null
                            ? 'assets/images/gb.png'
                            : L10n.getFlag(currentLocale.languageCode),
                        //'assets/images/gb.png',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    onTap: _selectLanguage,
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text(AppLocalizations.of(context).privacy),
                    onTap: () {
                      _showPrivacyWebpage();
                    },
                  ),
                  /*
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(AppLocalizations.of(context).aboutus),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AboutUsScreen.routeName,
                      );
                    },
                  ),
                  */
                  /*
                  ListTile(
                    leading: Icon(Icons.contact_support),
                    title: Text(AppLocalizations.of(context).supportcenter),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        SupportCenter.routeName,
                      );
                    },
                  ),
                  */
                ],
              ),
            );
          },
        ));
  }

  void _showPrivacyWebpage() async {
    if (!await launch(_privacyPolicyUrl))
      throw 'Could not launch $_privacyPolicyUrl';
  }
}
