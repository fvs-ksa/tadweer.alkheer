//language page
import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/widgets/language_selection.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/tabs_screen.dart';
import '../providers/locale_provider.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  Locale _language;

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
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Text('Tadweer Al Khair')),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/logo_1.png',
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.scaleDown,

                    //fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  child: Text('English'),
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.5, 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    _select(Locale('en'));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('عربي'),
                  style: ElevatedButton.styleFrom(
                    fixedSize:
                        Size(MediaQuery.of(context).size.width * 0.5, 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    _select(Locale('ar'));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
