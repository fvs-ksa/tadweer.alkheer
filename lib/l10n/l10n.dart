import 'package:flutter/cupertino.dart';

class L10n {
  static final all = [const Locale('en'), const Locale('ar')];

  static String getFlag(String code) {
    switch (code) {
      case 'ar':
        return 'assets/images/ae.png';
      case 'en':
      default:
        return 'assets/images/gb.png';
    }
  }

  static String getName(String code) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'ُEnglish';
    }
  }
}
