import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();

  @override
  List<Object?> get props => [];
}
class LoadDoctorDetails extends DoctorEvent {
  final String doctorId;

  const LoadDoctorDetails(this.doctorId);

  @override
  List<Object> get props => [doctorId];
}

class LoadDoctorsList extends DoctorEvent {}

class LoadFilterData extends DoctorEvent {
  const LoadFilterData();
}

class ApplyFilter extends DoctorEvent {
  final int? specializationId;
  final int? rating;
  final int? cityId;
  final bool isLocalFilter; // Whether to filter locally or call API

  const ApplyFilter({this.specializationId, this.rating, this.cityId, this.isLocalFilter = false});

  @override
  List<Object?> get props => [specializationId, rating, cityId, isLocalFilter];
}

class SearchDoctors extends DoctorEvent {
  // this is passed from the UI widget variable, so be it that I wanna be saving this value to a state variable eventually in the bloc file
  // e.g: emit(state.copyWith(selectedDate: event.date, selectedTime: event.time));
  // or that I wanna be using it to a apply some function in the bloc
  // e.g:    the search function in here:
  //         emit(currentState.copyWith(
  //         filteredDoctors: filtered,
  //         searchQuery: event.query, //passed from the UI
  //       ));
  final String query;
  final bool isLocalSearch; // Whether to search locally or call API

  const SearchDoctors(this.query, {this.isLocalSearch = false});

  @override
  List<Object> get props => [query, isLocalSearch];
}

class ClearFilters extends DoctorEvent {}