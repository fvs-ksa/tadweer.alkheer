import 'package:get_it/get_it.dart';
import 'package:tadweer_alkheer/providers/donation_points_provider.dart';
import 'package:tadweer_alkheer/providers/gallery_image_provider.dart';
import 'package:tadweer_alkheer/providers/gallery_video_provider.dart';
import 'package:tadweer_alkheer/providers/partners_provider.dart';
import './providers/tasks_provider.dart';
import './providers/donations_provider.dart';

import './services/crud_model.dart';

import './providers/users_provider.dart';
import './providers/categories_provider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => CRUDModel());
  locator.registerLazySingleton(() => UsersProvider());
  locator.registerLazySingleton(() => DonationsProvider());
  locator.registerLazySingleton(() => CategoriesProvider());
  locator.registerLazySingleton(() => TasksProvider());
  locator.registerLazySingleton(() => DonationPointsProvider());
  locator.registerLazySingleton(() => GalleryImagesProvider());
  locator.registerLazySingleton(() => GalleryVideosProvider());
  locator.registerLazySingleton(() => PartnersProvider());
  locator.registerLazySingleton(() => RatingProvider());
  locator.registerLazySingleton(() =>  TODonationPointsProvider());

}