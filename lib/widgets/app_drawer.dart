import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadweer_alkheer/screens/aboutus_screen.dart';
import 'package:tadweer_alkheer/screens/authn_screen.dart';
import '../widgets/language_selection.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../screens/tabs_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tadweer_alkheer/l10n/l10n.dart';

class AppDrawer extends StatefulWidget {
  final bool isLoggedin;
  AppDrawer(this.isLoggedin);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Locale _language;

  void _selectLanguage() {
    showDialog(
        context: context,
        builder: (_) => new Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.height * 1.25,
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
      localeProvider.setLocale(pickedLanguage);

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => TabsScreen(0)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale;

    return Drawer(
      //elevation: 100,
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(AppLocalizations.of(context).appname),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(AppLocalizations.of(context).languageword,
                style: Theme.of(context).textTheme.bodyText2),
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                currentLocale.languageCode == 'ar'
                    ? L10n.getFlag('en')
                    : L10n.getFlag('ar'),
                //'assets/images/gb.png',
                fit: BoxFit.scaleDown,
              ),
            ),
            onTap: () => _select(currentLocale.languageCode == 'en'
                ? Locale('ar')
                : Locale('en')),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(AppLocalizations.of(context).aboutus,
                style: Theme.of(context).textTheme.bodyText2),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(
                AboutUsScreen.routeName,
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text(
              widget.isLoggedin
                  ? AppLocalizations.of(context).logout
                  : AppLocalizations.of(context).loginasdonor,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onTap: () {
              if (widget.isLoggedin) {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamed(
                  TabsScreen.routeName,
                );
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  AuthnScreen.routeName,
                  arguments: true,
                );
              }
            },
          ),
          Divider(),
          /*
          if (!widget.isLoggedin)
            SizedBox(
              height: 250,
            ),
          if (!widget.isLoggedin) Divider(),
          if (!widget.isLoggedin)
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                  widget.isLoggedin
                      ? AppLocalizations.of(context).logout
                      : AppLocalizations.of(context).loginasdriver,
                  style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  AuthnScreen.routeName,
                  arguments: false,
                );
              },
            ),
          */
        ],
      ),
    );
  }
}
