import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_well/viewmodels/matter/matter_cubit.dart';
import 'package:study_well/viewmodels/timer/timer_cubit.dart';

import 'services/matter_service.dart';

GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // cubits
  sl.registerLazySingleton(() => MatterCubit(service: sl()));
  sl.registerLazySingleton(() => TimerCubit());

  // services
  //sl.registerLazySingleton<MatterService>(() => MatterServiceSharedPrefImpl(sharedPreferences: sl()));
  sl.registerLazySingleton<MatterService>(() => MatterServiceFirebaseImpl());
}
