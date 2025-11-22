import 'package:dio/dio.dart';
import 'package:doctor_appointment_app/business_logic/repositaries_interfaces/auth_repo_interface.dart';
import 'package:doctor_appointment_app/business_logic/usecases/dr_info_usecases/get_dr_by_id_usecase.dart';
import 'package:doctor_appointment_app/data/repositories/doctor_repo.dart';
import 'package:get_it/get_it.dart';
import '../../business_logic/repositaries_interfaces/dr_repo_interface.dart';
import '../../business_logic/state_management/auth_bloc/authentication_bloc.dart';
import '../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../business_logic/usecases/auth_usecases/login_usecase.dart';
import '../../business_logic/usecases/auth_usecases/signup_usecase.dart';
import '../../data/repositories/auth_repo.dart';

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
  // Auth Repository
  sl.registerLazySingleton<AuthRepositoryInterface>(
    () => AuthRepositoryImpl(baseUrl: 'https://vcare.integration25.com/api'),
  );
  // Doctor Repository
  sl.registerLazySingleton<DoctorRepositoryInterface>(
    () => DoctorRepositoryImpl(baseUrl: 'https://vcare.integration25.com/api'),
  );
}

Future<void> setUpUseCases() async {
  // Auth Use Cases
  sl.registerLazySingleton(
    () => LoginUseCase(repository: sl<AuthRepositoryInterface>()),
  );
  sl.registerLazySingleton(
    () => SignUpUseCase(repository: sl<AuthRepositoryInterface>()),
  );
  // Doctor Use Case
  sl.registerLazySingleton(
    () => GetDoctorByIdUseCase(sl<DoctorRepositoryInterface>()),
  );
}

Future<void> setUpBlocs() async {
  // Doctor Information BLoC
  sl.registerFactory(
    () => DoctorBloc(repository: sl<DoctorRepositoryInterface>()),
  );
  // Auth BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      signUpUseCase: sl<SignUpUseCase>(),
    ),
  );
}
