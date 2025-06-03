import 'dart:ui';

import 'package:get_it/get_it.dart';

import '../../../core/utils/helpers/local_storage_helper.dart';
import '../../../core/utils/helpers/localization_helper.dart';

class LocalizationModule {
  static Future<void> configure() async {
    final languageCode = await LocalStorageHelper.getLanguage();
    GetIt.I.registerLazySingleton(() => LocaleProvider()
      ..setLocale(Locale(languageCode)));
  }
}