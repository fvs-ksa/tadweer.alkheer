//flutter gen-l10n


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadweer_alkheer/l10n/l10n.dart';
import 'package:tadweer_alkheer/providers/donation_points_provider.dart';
import 'package:tadweer_alkheer/providers/gallery_image_provider.dart';
import 'package:tadweer_alkheer/providers/gallery_video_provider.dart';
import 'package:tadweer_alkheer/providers/partners_provider.dart';
import 'package:tadweer_alkheer/screens/add_donation_screen.dart';
import 'package:tadweer_alkheer/screens/image_gallery_screen.dart';
import 'package:tadweer_alkheer/screens/partners_screen.dart';
import 'package:tadweer_alkheer/screens/spp_screen.dart';
import 'package:tadweer_alkheer/screens/support_center.dart';
import 'package:tadweer_alkheer/screens/video_gallery_screen.dart';
import '../screens/tabs_screen.dart';
import './locator.dart';
import './providers/users_provider.dart';
import './screens/splash_screen.dart';
import './providers/donations_provider.dart';
import './providers/categories_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './providers/locale_provider.dart';
import './screens/aboutus_screen.dart';
import './screens/authn_screen.dart';
import './providers/tasks_provider.dart';
import './palette.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => locator<UsersProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<TODonationPointsProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<RatingProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<DonationsProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<CategoriesProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<TasksProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<PartnersProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<DonationPointsProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<GalleryImagesProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => locator<GalleryVideosProvider>(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LocaleProvider(),
        ),
      ],
      builder: (context, child) {
        var localeProvider = Provider.of<LocaleProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "تدوير الخير",
          theme: ThemeData(
            primarySwatch: Palette.kToDark,
            accentColor: Colors.white,
            fontFamily: 'ElMessiri',
          ),
          home: SplashScreen(),
          locale: localeProvider.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          routes: {
            AddDonationScreen.routeName: (ctx) => AddDonationScreen(),
            AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
            ImageGalleryScreen.routeName: (ctx) => ImageGalleryScreen(),
            VideoGalleryScreen.routeName: (ctx) => VideoGalleryScreen(),
            SupportCenter.routeName: (ctx) => SupportCenter(),
            AuthnScreen.routeName: (ctx) => AuthnScreen(),
            PartnersScreen.routeName: (ctx) => PartnersScreen(),
            //i changed it from 0 to 1
            TabsScreen.routeName: (ctx) => TabsScreen(0),
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (userSnapshot.hasData) {
          return TabsScreen(0);
        }
        return TabsScreen(1);
      },
    );
  }
}
