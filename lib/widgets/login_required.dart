import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tadweer_alkheer/screens/authn_screen.dart';

class LoginRequired extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/login_required.png'),
          SizedBox(height: 10),
          Text(AppLocalizations.of(context).loginRequired),
          SizedBox(height: 10),
          ElevatedButton(onPressed: (){
            Navigator.of(context).pushNamed(
              AuthnScreen.routeName,
              arguments: true,
            );
          }, child: Text(AppLocalizations.of(context).login))
        ],
      ),
    );
  }
}
