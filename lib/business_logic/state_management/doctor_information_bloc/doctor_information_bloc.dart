import 'package:dio/dio.dart';
import 'package:doctor_appointment_app/business_logic/repositaries_interfaces/dr_repo_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/doctor_model.dart';
import 'doctor_information_event.dart';
import 'doctor_information_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  //todo: for clean architecture, have the bloc deal with the useCase (which implicitly deals with the interface) not the repo interface.
  final DoctorRepositoryInterface repository;

  List<Specialization> _specializationsCache = [];
  List<City> _citiesCache = [];
  List<Doctor> _allDoctorsCache = [];
  bool _filterDataLoaded = false;

  List<Specialization> get specializationsCache => _specializationsCache;
  List<City> get citiesCache => _citiesCache;
  bool get filterDataLoaded => _filterDataLoaded;

  DoctorBloc({required this.repository}) : super(DoctorFilterInitial()) {
    on<LoadDoctorDetails>(_onLoadDoctorDetails);
    on<LoadDoctorsList>(_onLoadDoctors);

    on<ApplyFilter>(_onApplyFilter);
    on<SearchDoctors>(_onSearchDoctors);
    on<ClearFilters>(_onClearFilters);

    on<LoadFilterData>(_onLoadFilterData);
  }

  Future<void> _onLoadDoctorDetails(LoadDoctorDetails event, Emitter<DoctorState> emit,) async {
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
      final doctors = await repository.getDoctors();
      _allDoctorsCache = doctors;

      if (doctors.isEmpty) {
        emit(DoctorsListLoaded(
          allDoctors: [],
          filteredDoctors: [],
          selectedSpecializationId: null,
          selectedRating: null,
          selectedCityId: null,
          searchQuery: '',
        ));
      } else {
        emit(DoctorsListLoaded(
          allDoctors: doctors,
          filteredDoctors: doctors,
          selectedSpecializationId: null,
          selectedRating: null,
          selectedCityId: null,
          searchQuery: '',
        ));
      }
    } catch (e) {
      // More detailed error information
      final errorMessage = e.toString();

      // Check if it's a DioError for more details
      if (e is DioException) {
        if (e.response != null) {
          emit(DoctorError('HTTP ${e.response!.statusCode}: ${e.response!.statusMessage}'));
        } else {
          emit(DoctorError('Network error: ${e.message}'));
        }
      } else {
        emit(DoctorError('Failed to load doctors: $errorMessage'));
      }
    }
  }

  // Future<void> _onLoadFilterData(
  //     LoadFilterData event,
  //     Emitter<DoctorState> emit,
  //     ) async {
  //   // Check if already loaded
  //   if (_filterDataLoaded && _specializationsCache.isNotEmpty && _citiesCache.isNotEmpty) {
  //     debugPrint('Filter data already cached, skipping reload');
  //     emit(FilterDataLoaded(
  //       specializations: _specializationsCache,
  //       cities: _citiesCache,
  //     ));
  //     return;
  //   }
  //   debugPrint('Loading filter data...');
  //   emit(FilterDataLoading());
  //
  //   try {
  //     ///is future.wait the same as await?
  //     final results = await Future.wait([
  //       repository.getSpecializations(),
  //       repository.getCities(),
  //     ]);
  //
  //     ///why does one start with index 0 and the other with 1? and why am I storing the first elements alone in a list?
  //     _specializationsCache = results[0] as List<Specialization>;
  //     _citiesCache = results[1] as List<City>;
  //     _filterDataLoaded = true;
  //
  //     debugPrint('Filter data loaded: ${_specializationsCache.length} specializations, ${_citiesCache.length} cities');
  //     emit(FilterDataLoaded(
  //       specializations: _specializationsCache,
  //       cities: _citiesCache,
  //     ));
  //   } catch (e) {
  //     emit(FilterError('Failed to load filter data: ${e.toString()}'));
  //   }
  // }
  Future<void> _onLoadFilterData(
      LoadFilterData event,
      Emitter<DoctorState> emit,
      ) async {
    // Check if already loaded
    if (_filterDataLoaded && _specializationsCache.isNotEmpty && _citiesCache.isNotEmpty) {
      debugPrint('Filter data already cached, skipping reload');
      return; // Just return, don't emit anything
    }

    debugPrint('Loading filter data silently in background...');

    // DON'T emit any loading state
    // Just load the data in the background

    try {
      final results = await Future.wait([
        repository.getSpecializations(),
        repository.getCities(),
      ]);

      _specializationsCache = results[0] as List<Specialization>;
      _citiesCache = results[1] as List<City>;
      _filterDataLoaded = true;

      debugPrint('Filter data loaded: ${_specializationsCache.length} specializations, ${_citiesCache.length} cities');

      // DON'T emit any state - filter data is now available in the bloc
      // The UI doesn't need to know about this

    } catch (e) {
      debugPrint(' Error loading filter data: $e');
      // Silently fail - we can retry when user opens the filter modal
    }
  }

  //todo: do i need to handle the rest of the functions here in my repo?
  // void _onApplyFilter(ApplyFilter event, Emitter<DoctorState> emit) {
  //   if (state is DoctorsListLoaded) {
  //     final currentState = state as DoctorsListLoaded;
  //
  //     final filtered = _applyFilters(
  //       currentState.allDoctors,
  //       speciality: event.speciality,
  //       rating: event.rating,
  //       searchQuery: currentState.searchQuery,
  //     );
  //
  //     emit(currentState.copyWith(
  //       filteredDoctors: filtered,
  //       selectedSpeciality: event.speciality,
  //       selectedRating: event.rating,
  //       clearSpeciality: event.speciality == null,
  //       clearRating: event.rating == null,
  //     ));
  //   }
  // }
  Future<void> _onApplyFilter(
      ApplyFilter event,
      Emitter<DoctorState> emit,
      ) async {
    if (event.isLocalFilter) {
      // Local filtering
      _applyLocalFilter(event, emit);
    } else {
      // API filtering
      await _applyApiFilter(event, emit);
    }
  }
  void _applyLocalFilter(
      ApplyFilter event,
      Emitter<DoctorState> emit,
      ) {
    // Determine current list of doctors to filter
    List<Doctor> doctorsToFilter;
    String currentSearchQuery = '';

    // Get the current state to work with
    if (state is DoctorsListLoaded) {
      final currentState = state as DoctorsListLoaded;
      doctorsToFilter = currentState.allDoctors;
      currentSearchQuery = currentState.searchQuery;
    } else if (state is DoctorsSearched) {
      final currentState = state as DoctorsSearched;
      doctorsToFilter = currentState.searchResults;
      currentSearchQuery = currentState.searchQuery;
    } else if (state is DoctorsFiltered) {
      final currentState = state as DoctorsFiltered;
      doctorsToFilter = _allDoctorsCache;
      currentSearchQuery = currentState.searchQuery;
    } else {
      return; // Can't filter from current state
    }

    // Apply local filters
    final filtered = _applyLocalFilters(
      doctorsToFilter,
      specializationId: event.specializationId,
      cityId: event.cityId,
      searchQuery: currentSearchQuery,
    );

    // Emit filtered state
    if (state is DoctorsSearched) {
      final currentState = state as DoctorsSearched;
      emit(DoctorsFiltered(
        filteredDoctors: filtered,
        selectedSpecializationId: event.specializationId,
        selectedCityId: event.cityId,
        searchQuery: currentState.searchQuery,
      ));
    } else {
      emit(DoctorsFiltered(
        filteredDoctors: filtered,
        selectedSpecializationId: event.specializationId,
        selectedCityId: event.cityId,
        searchQuery: currentSearchQuery,
      ));
    }
  }
  List<Doctor> _applyLocalFilters(
      List<Doctor> doctors, {
        int? specializationId,
        int? cityId,
        String searchQuery = '',
      }) {
    return doctors.where((doctor) {
      // Specialization filter
      final matchesSpecialization = specializationId == null ||
          doctor.specialization.id == specializationId;

      // City filter
      final matchesCity = cityId == null ||
          doctor.city.id == cityId;

      // Search filter
      final matchesSearch = searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          doctor.speciality.toLowerCase().contains(searchQuery.toLowerCase()) ||
          doctor.university.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesSpecialization && matchesCity && matchesSearch;
    }).toList();
  }

  Future<void> _applyApiFilter(
      ApplyFilter event,
      Emitter<DoctorState> emit,
      ) async {
    emit(DoctorFilterLoading());

    try {
      // Determine current search query
      String currentSearchQuery = '';
      if (state is DoctorsListLoaded) {
        currentSearchQuery = (state as DoctorsListLoaded).searchQuery;
      } else if (state is DoctorsSearched) {
        currentSearchQuery = (state as DoctorsSearched).searchQuery;
      } else if (state is DoctorsFiltered) {
        currentSearchQuery = (state as DoctorsFiltered).searchQuery;
      }

      // Call API with filters

      ///this function is supposed to handle both endpoints the searching and filtering, could this even be achieved within the same function?
      final filteredDoctors = await repository.getFilteredDoctors(
        searchQuery: currentSearchQuery,
        specializationId: event.specializationId,
        cityId: event.cityId,
      );

      emit(DoctorsFiltered(
        filteredDoctors: filteredDoctors,
        selectedSpecializationId: event.specializationId,
        selectedCityId: event.cityId,
        searchQuery: currentSearchQuery,
      ));
    } catch (e) {
      emit(DoctorError('Filtering failed: ${e.toString()}'));
      // Revert to previous state
      if (state is DoctorsListLoaded) {
        emit(state as DoctorsListLoaded);
      } else if (state is DoctorsSearched) {
        emit(state as DoctorsSearched);
      } else if (state is DoctorsFiltered) {
        emit(state as DoctorsFiltered);
      }
    }
  }
  // void _onSearchDoctors(SearchDoctors event, Emitter<DoctorState> emit) {
  //   if (state is DoctorsListLoaded) {
  //     final currentState = state as DoctorsListLoaded;
  //
  //     final filtered = _applyFilters(
  //       currentState.allDoctors,
  //       speciality: currentState.selectedSpeciality,
  //       rating: currentState.selectedRating,
  //       searchQuery: event.query,
  //     );
  //
  //     emit(currentState.copyWith(
  //       filteredDoctors: filtered,
  //       searchQuery: event.query, //passed from the UI
  //     ));
  //   }
  // }
  Future<void> _onSearchDoctors(
      SearchDoctors event,
      Emitter<DoctorState> emit,
      ) async {
    if (event.isLocalSearch) {
      // Local search
      _applyLocalSearch(event, emit);
    } else {
      // API search
      await _applyApiSearch(event, emit);
    }
  }

  void _applyLocalSearch(
      SearchDoctors event,
      Emitter<DoctorState> emit,
      ) {
    // Determine current state and apply search
    if (state is DoctorsListLoaded) {
      final currentState = state as DoctorsListLoaded;

      final filtered = _applyLocalFilters(
        currentState.allDoctors,
        specializationId: currentState.selectedSpecializationId,
        cityId: currentState.selectedCityId,
        searchQuery: event.query,
      );

      // If we have active filters, emit DoctorsFiltered
      if (currentState.selectedSpecializationId != null ||
          currentState.selectedCityId != null) {
        emit(DoctorsFiltered(
          filteredDoctors: filtered,
          selectedSpecializationId: currentState.selectedSpecializationId,
          selectedCityId: currentState.selectedCityId,
          searchQuery: event.query,
        ));
      } else {
        // Otherwise emit DoctorsSearched
        emit(DoctorsSearched(
          searchResults: filtered,
          searchQuery: event.query,
        ));
      }
    } else if (state is DoctorsFiltered) {
      final currentState = state as DoctorsFiltered;

      final filtered = _applyLocalFilters(
        _allDoctorsCache,
        specializationId: currentState.selectedSpecializationId,
        cityId: currentState.selectedCityId,
        searchQuery: event.query,
      );

      emit(DoctorsFiltered(
        filteredDoctors: filtered,
        selectedSpecializationId: currentState.selectedSpecializationId,
        selectedCityId: currentState.selectedCityId,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _applyApiSearch(
      SearchDoctors event,
      Emitter<DoctorState> emit,
      ) async {
    emit(DoctorFilterLoading());

    try {
      // Determine current filter values
      int? currentSpecializationId;
      int? currentCityId;

      if (state is DoctorsListLoaded) {
        final currentState = state as DoctorsListLoaded;
        currentSpecializationId = currentState.selectedSpecializationId;
        currentCityId = currentState.selectedCityId;
      } else if (state is DoctorsFiltered) {
        final currentState = state as DoctorsFiltered;
        currentSpecializationId = currentState.selectedSpecializationId;
        currentCityId = currentState.selectedCityId;
      }

      // Call API with search query and current filters
      final searchResults = await repository.getFilteredDoctors(
        searchQuery: event.query,
        specializationId: currentSpecializationId,
        cityId: currentCityId,
      );

      // If we have active filters, emit DoctorsFiltered
      if (currentSpecializationId != null || currentCityId != null) {
        emit(DoctorsFiltered(
          filteredDoctors: searchResults,
          selectedSpecializationId: currentSpecializationId,
          selectedCityId: currentCityId,
          searchQuery: event.query,
        ));
      } else {
        // Otherwise emit DoctorsSearched
        emit(DoctorsSearched(
          searchResults: searchResults,
          searchQuery: event.query,
        ));
      }
    } catch (e) {
      emit(DoctorError('Search failed: ${e.toString()}'));
      // Revert to previous state
      if (state is DoctorsListLoaded) {
        emit(state as DoctorsListLoaded);
      } else if (state is DoctorsFiltered) {
        emit(state as DoctorsFiltered);
      }
    }
  }

  // void _onClearFilters(ClearFilters event, Emitter<DoctorState> emit) {
  //   if (state is DoctorsListLoaded) {
  //     final currentState = state as DoctorsListLoaded;
  //
  //     emit(currentState.copyWith(
  //       filteredDoctors: currentState.allDoctors,
  //       searchQuery: '',
  //       clearSpeciality: true,
  //       clearRating: true,
  //     ));
  //   }
  // }
  void _onClearFilters(
      ClearFilters event,
      Emitter<DoctorState> emit,
      ) {
    // Clear all filters and show all doctors
    if (_allDoctorsCache.isNotEmpty) {
      emit(DoctorsListLoaded(
        allDoctors: _allDoctorsCache,
        filteredDoctors: _allDoctorsCache,
        selectedSpecializationId: null,
        selectedCityId: null,
        searchQuery: '',
      ));
    } else {
      // Reload if cache is empty
      add(LoadDoctorsList());
    }
  }
}

  ///Local approach to applying filters - searching and filtering.
  // List<Doctor> _applyFilters(List<Doctor> doctors, {String? speciality, int? rating, String searchQuery = '',
  // }) {
  //   return doctors.where((doctor) {
  //     // Speciality filter
  //     final matchesSpeciality = speciality == null ||
  //         doctor.speciality == speciality;
  //
  //     // Rating filter
  //     final matchesRating = rating == null || doctor.rating.floor() >= rating;
  //
  //     // Search filter
  //     final matchesSearch = searchQuery.isEmpty ||
  //         doctor.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
  //         doctor.speciality.toLowerCase().contains(searchQuery.toLowerCase()) ||
  //         doctor.university.toLowerCase().contains(searchQuery.toLowerCase());
  //
  //     return matchesSpeciality && matchesRating && matchesSearch;
  //   }).toList();
  // }

  ///Mock Doctors List
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
//}