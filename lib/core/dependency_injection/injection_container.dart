import 'package:dio/dio.dart';
import 'package:doctor_appointment_app/business_logic/usecases/get_dr_by_id_usecase.dart';
import 'package:doctor_appointment_app/data/repositories/doctor_repo.dart';
import 'package:get_it/get_it.dart';
import '../../business_logic/repositaries_interfaces/dr_repo_interface.dart';
import '../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';

final sl = GetIt.instance;
// What it does: GetIt is a service locator that acts as a central registry for all your dependencies. sl is the singleton instance you'll use throughout your app to access registered dependencies
// Analogy: Think of it as a "phone book" for your app's services - you register services with names/keys, then look them up when needed

Future<void> init() async {
  // Order matters: Services → Repositories → Use Cases → BLoCs (dependencies flow downward)
  await setUpServices();
  await setUpRepositories();
  await setUpUseCases();
  await setUpBlocs();
}

Future<void> setUpServices() async {
  // registerLazySingleton: Creates the instance only when it's first requested, then reuses the same instance
  sl.registerLazySingleton<Dio>(() => Dio());
}

Future<void> setUpRepositories() async {
  // Dependency Injection: The repository gets its dependencies (Dio) automatically from GetIt
  // Clean Architecture: BLoC depends on interface, not implementation

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
  // Loose Coupling: BLoC doesn't know about the concrete implementation

  // registerFactory: Creates a NEW instance every time it's requested
  // Why Factory for BLoCs:
  //
  // BLoCs are typically short-lived (per screen/widget)
  // Each screen needs its own BLoC instance
  // Prevents state conflicts between different screens

  // Doctor Feature BLoC
  sl.registerFactory(() => DoctorBloc(repository: sl<DoctorRepositoryInterface>()));
}