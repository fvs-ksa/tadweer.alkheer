import 'package:flutter/material.dart';
import '../L10n/l10n.dart'; 

class LanguageSelection extends StatelessWidget {
  final Function onSelectLanguage;
  LanguageSelection(this.onSelectLanguage);

  Locale _locale;

  @override
  Widget build(BuildContext context) {
    List<Locale> locales = L10n.all;
    //final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Container(
        height: 200,
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: locales.length,
          itemBuilder: (ctx, index) {
            return Column(children: [
              ListTile(
                leading: Image.asset(L10n.getFlag(locales[index].languageCode)),
                title: Text(
                  L10n.getName(locales[index].languageCode),
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                onTap: () {


                  //localeProvider.setLocale(_locale);
                  Navigator.of(context).pop();

                  _locale = locales[index];
                  onSelectLanguage(_locale);
                },
              ),
              Divider()
            ]);
          },
        ));
  }
}
