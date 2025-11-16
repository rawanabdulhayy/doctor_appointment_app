import 'package:equatable/equatable.dart';

abstract class DoctorFilterEvent extends Equatable {
  const DoctorFilterEvent();

  @override
  List<Object?> get props => [];
}

class LoadDoctors extends DoctorFilterEvent {}

class ApplyFilter extends DoctorFilterEvent {
  final String? speciality;
  final int? rating;

  const ApplyFilter({this.speciality, this.rating});

  @override
  List<Object?> get props => [speciality, rating];
}

class SearchDoctors extends DoctorFilterEvent {
  // this is passed from the UI widget variable, so be it that I wanna be saving this value to a state variable eventually in the bloc file
  // e.g: emit(state.copyWith(selectedDate: event.date, selectedTime: event.time));
  // or that I wanna be using it to a apply some function in the bloc
  // e.g:    the search function in here:
  //         emit(currentState.copyWith(
  //         filteredDoctors: filtered,
  //         searchQuery: event.query, //passed from the UI
  //       ));
  final String query;

  const SearchDoctors(this.query);

  @override
  List<Object> get props => [query];
}

class ClearFilters extends DoctorFilterEvent {}