//support screen center

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadweer_alkheer/models/supports.dart';
import 'package:contactus/contactus.dart';

class SupportCenter extends StatelessWidget {
  static const routeName = '/support-center';
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<dynamic> supports;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(AppLocalizations.of(context).supportcenter),
      ),
      body: Column(
        children: [
          ContactUs(
            dividerColor: Colors.grey[50],
            companyColor: Colors.green,
            companyFontWeight: FontWeight.bold,
            textColor: Colors.green,
            cardColor: Colors.green[100],
            emailText: "البريد الالكتروني",
            phoneNumberText: "رقم الهاتف",
            email: "tadewralkaer@gmail.com",
            phoneNumber: "+966535381868",
            companyName: '',
            taglineColor: null,
          ),
          Image.asset(
            'assets/images/logodown.png',
            width: 300,
          ),
        ],
      ),

      /*StreamBuilder(
        stream: _db.collection('supports').snapshots(),
        builder: (ctx, supportsSnapshot) {
          if (supportsSnapshot.hasData) {
            supports = supportsSnapshot.data.docs
                .map((doc) => Support.fromMap(doc.data(), doc.id))
                .toList();
            print(supports);

            return Container(
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    //Text(AppLocalizations.of(context).supportcentercontent, style: TextStyle( fontSize: 18),),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Image.asset('assets/images/splash_1.png'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: supports.length,
                          itemBuilder: (ctx, index) {
                            return ListTile(
                              leading: supports[index].type.trim() == "Email"
                                  ? Icon(Icons.email)
                                  : (supports[index].type == "Phone Number"
                                      ? Icon(Icons.phone)
                                      : (supports[index].type == "Address"
                                          ? Icon(Icons.place)
                                          : Icon(Icons.contact_support))),
                              title: Text(
                                supports[index].value,
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          }),
                    )
                  ],
                )

                // Text(AppLocalizations.of(context).supportcentercontent),
                );
          }
          return CircularProgressIndicator();
        },
      ),
      */
    );
  }
}
