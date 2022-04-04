import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/models/category.dart';
import 'package:tadweer_alkheer/providers/categories_provider.dart';
import 'package:tadweer_alkheer/screens/add_donation_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  List<dynamic> categories = [];
  String userID;

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = Provider.of<CategoriesProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale;
  //  userID = FirebaseAuth.instance.currentUser.uid;
    return Scaffold(
      body: StreamBuilder(
              stream: categoriesProvider.fetchAllCategoriesAsStream(),
              builder: (ctx, categoriesSnapshot) {
                if (categoriesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (categoriesSnapshot.hasData) {
                  categories = categoriesSnapshot.data.docs
                      .map((doc) => Category.fromMap(doc.data(), doc.id))
                      .toList();
                }
                return Container(
                  child: Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        elevation: 4,
                        margin: EdgeInsets.all(12),
                        //The green box..

                        child: Container(
                          //color: Theme.of(context).primaryColor,
                          width: MediaQuery.of(context).size.width * 0.9,
                          padding: EdgeInsetsDirectional.only(
                              bottom: 10, top: 10, start: 17, end: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).primaryColor),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context).help,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
    //The space between the green box and the two row
    ConstrainedBox(
    constraints: BoxConstraints(
    maxHeight: 110.0 * categories.length,
    ),
    child: Row(
    children: [
    Expanded(
    child: GridView.builder(
    padding: EdgeInsets.all(12),
    gridDelegate:
    SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 0.9,
    crossAxisSpacing: 10,
    mainAxisSpacing: 20,
    ),
    itemCount: categories.length,
    itemBuilder: (ctx, index) => Container(
    decoration: BoxDecoration(
    border: Border.all(
    width: 1, color: Colors.grey),
    borderRadius: BorderRadius.circular(12)),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: GridTile(
    child: GestureDetector(
    onTap: () {
    Navigator.of(context).pushNamed(
    AddDonationScreen.routeName,
    arguments: currentLocale
        .languageCode ==
    'ar'
    ? categories[index].arabicName
        : categories[index].name,
    );
    },
    child: FadeInImage(
    //placeholder appears for afew minutes while the image loads
    placeholder: AssetImage(
    'assets/images/placeholder.png'),
    image: categories[index].imageUrl !=
    null
    ? NetworkImage(
    categories[index].imageUrl)
        : AssetImage(
    'assets/images/placeholder.png'),
    fit: BoxFit.cover,
    imageErrorBuilder:
    (context, error, stackTrace) {
    return Image.asset(
    "assets/images/placeholder.png",
    height: 260,
    width: 260,
    );
    },
    ),
    ),
    footer: GridTileBar(
    backgroundColor: Colors.black54,
    title: Text(
    currentLocale.languageCode == 'ar'
    ? categories[index].arabicName
        : categories[index].name,
    textAlign: TextAlign.center,
    style: TextStyle(
    fontFamily: 'ElMessiri',
    fontWeight: FontWeight.w500,
    fontSize: 16),
    ),
    ),
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    ),

    //First Row...
    /*
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ImageGalleryScreen.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Theme.of(context).colorScheme.primary),
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.all(16),
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 32,
                              child: Column(

                                children: [
                                  Icon(Icons.collections,
                                      color: Colors.white, size: 50.0),
                                  SizedBox(height: 12),
                                  Text(
                                    AppLocalizations.of(context).imageGallery,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(VideoGalleryScreen.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Theme.of(context).colorScheme.primary),
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.all(16),
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 32,
                              child: Column(
                                children: [
                                  Icon(Icons.video_library,
                                      color: Colors.white, size: 50.0),
                                  SizedBox(height: 12),
                                  Text(
                                    AppLocalizations.of(context).videoGallery,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      */
    // Second row..
    /*
                      Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed(PartnersScreen.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: Theme.of(context).colorScheme.primary
                              ),
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.all(16),
                              width: (MediaQuery.of(context).size.width / 2) - 32,
                              child: Column(
                                children: [
                                  Image.asset("assets/images/partners.png"),
                                  SizedBox(height: 12),
                                  Text(AppLocalizations.of(context).partners,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).pushNamed(AboutUsScreen.routeName);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: Theme.of(context).colorScheme.primary
                              ),
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.all(16),
                              width: (MediaQuery.of(context).size.width / 2) - 32,
                              child: Column(
                                children: [
                                  Image.asset("assets/images/logo_white.png"),
                                  SizedBox(height: 12),
                                  Text(AppLocalizations.of(context).aboutus,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                      */

    ],
    ),
    );
    })


  );
}
}
