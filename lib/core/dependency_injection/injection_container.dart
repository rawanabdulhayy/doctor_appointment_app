import 'package:dio/dio.dart';
import 'package:doctor_appointment_app/business_logic/usecases/get_dr_by_id_usecase.dart';
import 'package:doctor_appointment_app/data/repositories/doctor_repo.dart';
import 'package:get_it/get_it.dart';
import '../../business_logic/repositaries_interfaces/dr_repo_interface.dart';
import '../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await setUpServices();
  await setUpRepositories();
  await setUpUseCases();
  await setUpBlocs();
}

Future<void> setUpServices() async {
  //backend handler
  sl.registerLazySingleton<Dio>(() => Dio());
}

Future<void> setUpRepositories() async {
  // Doctor Repository
  sl.registerLazySingleton<DoctorRepositoryInterface>(
        () => DoctorRepositoryImpl(
      baseUrl: 'https://vcare.integration25.com/api',
    ),
  );
}

Future<void> setUpUseCases() async {
  sl.registerLazySingleton(() => GetDoctorByIdUseCase(sl<DoctorRepositoryInterface>()));
}

Future<void> setUpBlocs() async {
  // Doctor Feature BLoC
  sl.registerFactory(() => DoctorBloc(repository: sl<DoctorRepositoryInterface>()));
}