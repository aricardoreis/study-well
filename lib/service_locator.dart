import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:study_well/services/study_record_service.dart';
import 'package:study_well/services/study_type_service.dart';
import 'package:study_well/viewmodels/subject/subject_cubit.dart';
import 'package:study_well/viewmodels/timer/timer_cubit.dart';

import 'services/subject_service.dart';
import 'viewmodels/study_record/study_record_cubit.dart';

GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // cubits
  sl.registerLazySingleton(() => SubjectCubit(service: sl()));
  sl.registerLazySingleton(() => StudyRecordCubit(service: sl()));
  sl.registerLazySingleton(() => TimerCubit());

  // services
  sl.registerLazySingleton<SubjectService>(() => SubjectServiceFirebaseImpl());
  // sl.registerLazySingleton<StudyRecordService>(() => StudyRecordServiceFirebaseImpl());
  sl.registerLazySingleton<StudyRecordService>(() => StudyRecordServiceFake());
  sl.registerLazySingleton<StudyTypeService>(
      () => StudyTypeServiceFirebaseImpl());
}
