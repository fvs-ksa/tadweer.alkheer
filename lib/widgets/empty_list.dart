import 'package:flutter/material.dart';
import '../providers/locale_provider.dart';
import 'package:provider/provider.dart';

class EmptyList extends StatelessWidget {
  bool isDonation;
  EmptyList(this.isDonation);
  // final String message;
  //EmptyList(this.message);
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale;

    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        width: constraints.maxWidth,
        child: Container(
          height: constraints.maxHeight * 0.7,
          child:  Image.asset(
             currentLocale == null
                    ? 'assets/images/empty.png'
                    : ( currentLocale.languageCode == 'en' ? 'assets/images/empty.png' : (isDonation ?'assets/images/empty_ar.png' : 'assets/images/empty_ar_task.png')),

            fit: BoxFit.cover,
          ),
        ),
      );
    });
  }
}
