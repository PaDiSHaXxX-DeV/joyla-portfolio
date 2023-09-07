import 'package:get_it/get_it.dart';
import 'package:joyla/data/network/open_api_service.dart';
import 'package:joyla/data/network/secure_api_service.dart';

final getIt = GetIt.instance;

 getSetup() {
  getIt.registerLazySingleton(() => OpenApiService());
  getIt.registerLazySingleton(() => SecureApiService());


}
