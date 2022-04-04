import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/providers/partners_provider.dart';
import 'package:tadweer_alkheer/widgets/empty_list.dart';
import 'package:tadweer_alkheer/widgets/partner_item.dart';

class PartnersScreen extends StatelessWidget {
  static const routeName = '/partners';
  List<dynamic> partners;

  @override
  Widget build(BuildContext context) {
    final partnersProvider = Provider.of<PartnersProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('شركاؤنا'),),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: FutureBuilder(
          future: partnersProvider.fetchPartners(),
          builder: (ctx, partnersSnapshot) {
            if (partnersSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (partnersSnapshot.hasData) {
              partners = partnersSnapshot.data;

              print(partners);

              return partners.isEmpty
                  ? EmptyList(true)
                  : ListView.builder(
                itemCount: partners.length,
                itemBuilder: (buildContext, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PartnerItem(partners[index]),
                  );
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

 }

