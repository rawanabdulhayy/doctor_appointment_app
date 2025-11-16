import 'package:doctor_appointment_app/business_logic/state_management/recommendation_doctor_bloc/recommendation_doctor_event.dart';
import 'package:doctor_appointment_app/business_logic/state_management/recommendation_doctor_bloc/recommendation_doctor_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/doctor.dart';

class DoctorFilterBloc extends Bloc<DoctorFilterEvent, DoctorFilterState> {
  DoctorFilterBloc() : super(DoctorFilterInitial()) {
    on<LoadDoctors>(_onLoadDoctors);
    on<ApplyFilter>(_onApplyFilter);
    on<SearchDoctors>(_onSearchDoctors);
    on<ClearFilters>(_onClearFilters);
  }

  void _onLoadDoctors(LoadDoctors event, Emitter<DoctorFilterState> emit) async {
    emit(DoctorFilterLoading());

    try {
      // In a real app, you'd fetch from API or database
      final doctors = _getMockDoctors();

      emit(DoctorFilterLoaded(
        allDoctors: doctors,
        filteredDoctors: doctors,
      ));
    } catch (e) {
      emit(DoctorFilterError('Failed to load doctors: ${e.toString()}'));
    }
  }

  void _onApplyFilter(ApplyFilter event, Emitter<DoctorFilterState> emit) {
    if (state is DoctorFilterLoaded) {
      final currentState = state as DoctorFilterLoaded;

      final filtered = _applyFilters(
        currentState.allDoctors,
        speciality: event.speciality,
        rating: event.rating,
        searchQuery: currentState.searchQuery,
      );

      emit(currentState.copyWith(
        filteredDoctors: filtered,
        selectedSpeciality: event.speciality,
        selectedRating: event.rating,
        clearSpeciality: event.speciality == null,
        clearRating: event.rating == null,
      ));
    }
  }

  void _onSearchDoctors(SearchDoctors event, Emitter<DoctorFilterState> emit) {
    if (state is DoctorFilterLoaded) {
      final currentState = state as DoctorFilterLoaded;

      final filtered = _applyFilters(
        currentState.allDoctors,
        speciality: currentState.selectedSpeciality,
        rating: currentState.selectedRating,
        searchQuery: event.query,
      );

      emit(currentState.copyWith(
        filteredDoctors: filtered,
        searchQuery: event.query, //passed from the UI
      ));
    }
  }

  void _onClearFilters(ClearFilters event, Emitter<DoctorFilterState> emit) {
    if (state is DoctorFilterLoaded) {
      final currentState = state as DoctorFilterLoaded;

      emit(currentState.copyWith(
        filteredDoctors: currentState.allDoctors,
        searchQuery: '',
        clearSpeciality: true,
        clearRating: true,
      ));
    }
  }

  List<Doctor> _applyFilters(
      List<Doctor> doctors, {
        String? speciality,
        int? rating,
        String searchQuery = '',
      }) {
    return doctors.where((doctor) {
      // Speciality filter
      final matchesSpeciality = speciality == null || doctor.speciality == speciality;

      // Rating filter
      final matchesRating = rating == null || doctor.rating.floor() >= rating;

      // Search filter
      final matchesSearch = searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          doctor.speciality.toLowerCase().contains(searchQuery.toLowerCase()) ||
          doctor.university.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesSpeciality && matchesRating && matchesSearch;
    }).toList();
  }

  List<Doctor> _getMockDoctors() {
    return [
      Doctor(
        id: '1',
        image: "assets/images/home_page/dr1.png",
        name: "Dr. Sarah Johnson",
        speciality: "Cardiologist",
        rating: 4.8,
        reviewsNumber: 128,
        university: "Harvard Medical School",
      ),
      Doctor(
        id: '2',
        image: "assets/images/home_page/dr2.png",
        name: "Dr. Omar Khaled",
        speciality: "Neurologist",
        rating: 4.6,
        reviewsNumber: 98,
        university: "Stanford University",
      ),
      Doctor(
        id: '3',
        image: "assets/images/home_page/dr1.png",
        name: "Dr. Sarah Johnson",
        speciality: "Cardiologist",
        rating: 4.8,
        reviewsNumber: 128,
        university: "Harvard Medical School",
      ),
      Doctor(
        id: '4',
        image: "assets/images/home_page/dr2.png",
        name: "Dr. Omar Khaled",
        speciality: "Neurologist",
        rating: 4.6,
        reviewsNumber: 98,
        university: "Stanford University",
      ),
    ];
  }
}
