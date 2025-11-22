import 'package:doctor_appointment_app/business_logic/repositaries_interfaces/dr_repo_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/doctor_model.dart';
import 'doctor_information_event.dart';
import 'doctor_information_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  //todo: for clean architecture, have the bloc deal with the useCase (which implicitly deals with the interface) not the repo interface.
  final DoctorRepositoryInterface repository;

  DoctorBloc({required this.repository}) : super(DoctorFilterInitial()) {
    on<LoadDoctorDetails>(_onLoadDoctorDetails);
    on<LoadDoctorsList>(_onLoadDoctors);
    on<ApplyFilter>(_onApplyFilter);
    on<SearchDoctors>(_onSearchDoctors);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadDoctorDetails(LoadDoctorDetails event,
      Emitter<DoctorState> emit,) async {
    emit(DoctorLoading());

    try {
      final doctor = await repository.getDoctorById(event.doctorId);
      emit(DoctorInfoLoaded(doctor));
    } catch (e) {
      emit(DoctorError(e.toString()));
    }
  }

  void _onLoadDoctors(LoadDoctorsList event, Emitter<DoctorState> emit) async {
    emit(DoctorFilterLoading());

    try {
      // final doctors = _getMockDoctors();
      final doctors = await repository.getDoctors();

      if (doctors.isEmpty) {
        emit(DoctorsListLoaded(
          allDoctors: [],
          filteredDoctors: [],
        ));
      } else {
        emit(DoctorsListLoaded(
          allDoctors: doctors,
          filteredDoctors: doctors,
        ));
      }
    } catch (e) {
      emit(DoctorError('Failed to load doctors: ${e.toString()}'));
    }
  }

  //todo: do i need to handle the rest of the functions here in my repo?
  void _onApplyFilter(ApplyFilter event, Emitter<DoctorState> emit) {
    if (state is DoctorsListLoaded) {
      final currentState = state as DoctorsListLoaded;

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

  void _onSearchDoctors(SearchDoctors event, Emitter<DoctorState> emit) {
    if (state is DoctorsListLoaded) {
      final currentState = state as DoctorsListLoaded;

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

  void _onClearFilters(ClearFilters event, Emitter<DoctorState> emit) {
    if (state is DoctorsListLoaded) {
      final currentState = state as DoctorsListLoaded;

      emit(currentState.copyWith(
        filteredDoctors: currentState.allDoctors,
        searchQuery: '',
        clearSpeciality: true,
        clearRating: true,
      ));
    }
  }

  List<Doctor> _applyFilters(List<Doctor> doctors, {
    String? speciality,
    int? rating,
    String searchQuery = '',
  }) {
    return doctors.where((doctor) {
      // Speciality filter
      final matchesSpeciality = speciality == null ||
          doctor.speciality == speciality;

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

  // List<Doctor> _getMockDoctors() {
  //   return [
  //     Doctor(
  //       id: 1,
  //       name: "Dr. Sarah Johnson",
  //       email: "sarah.johnson@example.net",
  //       phone: "+1.555.123.4567",
  //       photo: "assets/images/home_page/dr1.png",
  //       // <-- changed
  //       gender: "female",
  //       address: "123 Medical Center Drive Suite 101\nBoston, MA 02115",
  //       description: "Experienced cardiologist with over 10 years of practice in heart diseases and treatments.",
  //       degree: "Consultant Cardiologist",
  //       specialization: Specialization(id: 1, name: "Cardiology"),
  //       city: City(
  //         id: 1,
  //         name: "Boston",
  //         governrate: Governrate(id: 1, name: "Massachusetts"),
  //       ),
  //       appointPrice: 300.0,
  //       startTime: "09:00:00 AM",
  //       endTime: "17:00:00 PM",
  //     ),
  //     Doctor(
  //       id: 2,
  //       name: "Dr. Omar Khaled",
  //       email: "omar.khaled@example.net",
  //       phone: "+1.555.987.6543",
  //       photo: "assets/images/home_page/dr2.png",
  //       // <-- changed
  //       gender: "male",
  //       address: "456 Neurology Lane Suite 205\nStanford, CA 94305",
  //       description: "Specialized in neurological disorders with extensive research background.",
  //       degree: "Senior Neurologist",
  //       specialization: Specialization(id: 2, name: "Neurology"),
  //       city: City(
  //         id: 2,
  //         name: "Stanford",
  //         governrate: Governrate(id: 2, name: "California"),
  //       ),
  //       appointPrice: 350.0,
  //       startTime: "08:00:00 AM",
  //       endTime: "16:00:00 PM",
  //     ),
  //     Doctor(
  //       id: 3,
  //       name: "Dr. Maria Garcia",
  //       email: "maria.garcia@example.net",
  //       phone: "+1.555.456.7890",
  //       photo: "assets/images/home_page/dr1.png",
  //       // <-- changed
  //       gender: "female",
  //       address: "789 Pediatric Avenue Suite 150\nNew York, NY 10001",
  //       description: "Dedicated pediatrician with focus on child healthcare and development.",
  //       degree: "Pediatric Specialist",
  //       specialization: Specialization(id: 3, name: "Pediatrics"),
  //       city: City(
  //         id: 3,
  //         name: "New York",
  //         governrate: Governrate(id: 3, name: "New York"),
  //       ),
  //       appointPrice: 250.0,
  //       startTime: "10:00:00 AM",
  //       endTime: "18:00:00 PM",
  //     ),
  //     Doctor(
  //       id: 4,
  //       name: "Dr. James Wilson",
  //       email: "james.wilson@example.net",
  //       phone: "+1.555.234.5678",
  //       photo: "assets/images/home_page/dr2.png",
  //       // <-- changed
  //       gender: "male",
  //       address: "321 Orthopedic Road Suite 300\nChicago, IL 60601",
  //       description: "Orthopedic surgeon specializing in sports injuries and joint replacements.",
  //       degree: "Orthopedic Surgeon",
  //       specialization: Specialization(id: 4, name: "Orthopedics"),
  //       city: City(
  //         id: 4,
  //         name: "Chicago",
  //         governrate: Governrate(id: 4, name: "Illinois"),
  //       ),
  //       appointPrice: 400.0,
  //       startTime: "07:00:00 AM",
  //       endTime: "15:00:00 PM",
  //     ),
  //     Doctor(
  //       id: 5,
  //       name: "Dr. Lisa Chen",
  //       email: "lisa.chen@example.net",
  //       phone: "+1.555.345.6789",
  //       photo: "assets/images/home_page/dr1.png",
  //       // <-- changed
  //       gender: "female",
  //       address: "654 Dermatology Street Suite 120\nLos Angeles, CA 90001",
  //       description: "Dermatologist with expertise in skin diseases and cosmetic procedures.",
  //       degree: "Dermatology Consultant",
  //       specialization: Specialization(id: 5, name: "Dermatology"),
  //       city: City(
  //         id: 5,
  //         name: "Los Angeles",
  //         governrate: Governrate(id: 2, name: "California"),
  //       ),
  //       appointPrice: 275.0,
  //       startTime: "11:00:00 AM",
  //       endTime: "19:00:00 PM",
  //     ),
  //   ];
  // }
}