import 'package:equatable/equatable.dart';

import '../../../data/models/doctor_model.dart';

abstract class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object?> get props => [];
}

class DoctorInfoInitial extends DoctorState {}

class DoctorFilterInitial extends DoctorState {}

class DoctorLoading extends DoctorState {}

class DoctorFilterLoading extends DoctorState {}

//this works for both, showing the list of raw fetched drs data, and the list of filtered or searched-for drs.
class DoctorsListLoaded extends DoctorState {
  //when is it that I know I should be declaring a variable inside a state and when should be declared inside the event?

  //   BLOC USAGE:
  //   emit(state.copyWith(selectedDate: event.date, selectedTime: event.time));

  //   UI USAGE:
  //   if (pickedDate != null) {
  //   context.read<BookingBloc>().add(
  //   UpdateDateTimeEvent(
  //   pickedDate,
  //   state.selectedTime ?? '',
  //   ),
  //   );
  //   }

  //like I know something,which is whenever I access stored values, I access those from the state variable, and whenever I wanna save a widget var value, I save that to the event's
  //but I need more on that topic and usage
  final List<Doctor> allDoctors;
  final List<Doctor> filteredDoctors;

  ///this too should be a selected id?
  final int? selectedSpecializationId;
  final int? selectedCityId;
  final int? selectedRating;
  final String searchQuery;

  const DoctorsListLoaded({
    required this.allDoctors,
    required this.filteredDoctors,
    this.selectedSpecializationId,
    this.selectedRating,
    this.selectedCityId,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    allDoctors,
    filteredDoctors,
    selectedSpecializationId,
    selectedRating,
    selectedCityId,
    searchQuery,
  ];

  //why should we use a copyWith whilst defining our state classes?
  //when do we know we need to define one in a given state class?
  DoctorsListLoaded copyWith({
    List<Doctor>? allDoctors,
    List<Doctor>? filteredDoctors,
    int? selectedSpecializationId,
    int? selectedRating,
    String? searchQuery,
    int? selectedCityId,
    bool clearSpeciality = false,
    bool clearRating = false,
    bool clearCity = false,
  }) {
    return DoctorsListLoaded(
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      selectedSpecializationId: clearSpeciality
          ? null
          : (selectedSpecializationId ?? this.selectedSpecializationId),
      selectedRating: clearRating
          ? null
          : (selectedRating ?? this.selectedRating),
      selectedCityId: clearCity
          ? null
          : (selectedCityId ?? this.selectedCityId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DoctorInfoLoaded extends DoctorState {
  final Doctor doctor;

  const DoctorInfoLoaded(this.doctor);

  @override
  List<Object> get props => [doctor];
}

class DoctorError extends DoctorState {
  final String message;

  const DoctorError(this.message);

  @override
  List<Object> get props => [message];
}

class FilterError extends DoctorState {
  final String message;

  const FilterError(this.message);

  @override
  List<Object> get props => [message];
}

// For loading filter data (specializations, cities)
class FilterDataLoading extends DoctorState {}

class FilterDataLoaded extends DoctorState {
  final List<Specialization> specializations;
  final List<City> cities;

  const FilterDataLoaded({required this.specializations, required this.cities});

  @override
  List<Object?> get props => [specializations, cities];
}

// For when filters are being applied (API call)
class DoctorsFiltering extends DoctorState {}

class DoctorsFiltered extends DoctorState {
  final List<Doctor> filteredDoctors;
  final int? selectedSpecializationId;
  final int? selectedRating;
  final int? selectedCityId;
  final String searchQuery;

  const DoctorsFiltered({
    required this.filteredDoctors,
    this.selectedSpecializationId,
    this.selectedRating,
    this.selectedCityId,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    filteredDoctors,
    selectedSpecializationId,
    selectedRating,
    selectedCityId,
    searchQuery,
  ];
}

// For when search is being performed (API call)
class DoctorsSearching extends DoctorState {}

class DoctorsSearched extends DoctorState {
  final List<Doctor> searchResults;
  final String searchQuery;

  const DoctorsSearched({
    required this.searchResults,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [searchResults, searchQuery];
}
