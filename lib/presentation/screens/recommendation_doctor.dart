import 'package:doctor_appointment_app/data/repositories/doctor_repo.dart';
import 'package:doctor_appointment_app/presentation/widgets/sort_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../business_logic/state_management/doctor_information_bloc/doctor_information_event.dart';
import '../../business_logic/state_management/doctor_information_bloc/doctor_information_state.dart';
import '../../core/dependency_injection/injection_container.dart';
import '../../data/models/doctor_model.dart';
import '../widgets/doctor_card.dart';
import 'about_doctor/about_doctor.dart';

//why do we have a separate RecommendationDoctor widget that only ever builds a context for a blocProvider to wrap the RecommendationDoctorView? can't we just wrap the blocProvider whilst navigating to the RecommendationDoctorView page?
class RecommendationDoctor extends StatelessWidget {
  const RecommendationDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //what does the two dots (..) operator do? and how are they different from the three dots (...) used in here (...List.generate(paymentMethods.length, (index) {)? what are each's use cases?

      //that would have been the way without having created an injection container:
      // create: (context) => DoctorBloc(repository: DoctorRepository(baseUrl: baseUrl))..add(LoadDoctorsList()),

      create: (context) {
        final bloc = sl<DoctorBloc>();
        bloc.add(LoadFilterData());
        bloc.add(LoadDoctorsList());
        return bloc;
      },      child: const RecommendationDoctorView(),
    );
  }
}

class RecommendationDoctorView extends StatelessWidget {
  const RecommendationDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Recommendation Doctor',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[100]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Sort Row
            BlocBuilder<DoctorBloc, DoctorState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 10,
                      child: SearchBar(
                        onChanged: (searchQuery) {
                          if (searchQuery.isEmpty) {
                            // When search is cleared, show all doctors
                            context.read<DoctorBloc>().add(LoadDoctorsList());
                          } else {
                            context.read<DoctorBloc>().add(
                              SearchDoctors(searchQuery),
                            );
                          }
                        },
                        leading: Image.asset(
                          "assets/images/recommendation_dr/search_normal.png",
                          width: 24,
                          height: 24,
                        ),
                        hintText: 'Search',
                        hintStyle: WidgetStatePropertyAll(
                          TextStyle(color: Color.fromRGBO(194, 194, 194, 1)),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Color.fromRGBO(245, 245, 245, 1),
                        ),
                        elevation: WidgetStatePropertyAll(0),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      flex: 1,
                      child: GestureDetector(
                        //showing a modal sheet needs its own context?
                        onTap: () => _showSortModalSheet(context, state),
                        child: Image.asset(
                          "assets/images/recommendation_dr/sort.png",
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),

  //           // Doctor List
  //           Expanded(
  //             child: BlocBuilder<DoctorBloc, DoctorState>(
  //               builder: (context, state) {
  //                 if (state is DoctorFilterLoading) {
  //                   return Center(child: CircularProgressIndicator());
  //                 }
  //
  //                 if (state is DoctorError) {
  //                   return Center(child: Text(state.message));
  //                 }
  //
  //                 if (state is DoctorsListLoaded) {
  //                   if (state.filteredDoctors.isEmpty) {
  //                     return Center(
  //                       child: Text('No doctors found matching your criteria'),
  //                     );
  //                   }
  //
  //                   return ListView.builder(
  //                     itemCount: state.filteredDoctors.length,
  //                     itemBuilder: (context, index) {
  //                       final doctor = state.filteredDoctors[index];
  //                       return GestureDetector(
  //                         onTap: () {
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (_) {
  //                                 return AboutDoctor(
  //                                   doctorId: doctor.id
  //                                       .toString(),
  //                                 );
  //                               },
  //                             ),
  //                           );
  //                         },
  //                         child: DoctorCard(
  //                           image: doctor.photo,
  //                           name: doctor.name,
  //                           speciality: doctor.speciality,
  //                           rating: doctor.rating,
  //                           reviewsNumber: doctor.reviewsNumber,
  //                           university: doctor.university,
  //                         ),
  //                       );
  //                     },
  //                   );
  //                 }
  //                 //shows nothing, I can also return an empty container.
  //                 return SizedBox.shrink();
  //               },
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // void _showSortModalSheet(BuildContext context, DoctorState state) {
  //   //what does the (is!) operator mean?
  //   if (state is! DoctorsListLoaded) return;
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     //how does the builder here work? and is ((bottomSheetContext) => SortModalSheet()) a callback function? or is it an ordinary one? and what even is this passed (bottomSheetContext)?
  //     builder: (bottomSheetContext) => SortModalSheet(
  //       selectedSpecializationId: state.selectedSpecializationId,
  //       selectedCityId: state.selectedCityId,
  //       onApply: (specializationId, cityId) {
  //         context.read<DoctorBloc>().add(
  //           ApplyFilter(specializationId: specializationId, cityId: cityId,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
            Expanded(
              child: BlocBuilder<DoctorBloc, DoctorState>(
                builder: (context, state) {
                  print('Current state: ${state.runtimeType}');

                  if (state is DoctorLoading || state is DoctorFilterLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is DoctorError) {
                    return Center(child: Text(state.message));
                  }

                  // Handle all possible states that contain doctors
                  List<Doctor> doctorsToShow = [];
                  String? searchQuery = '';
                  bool isSearching = false;

                  if (state is DoctorsListLoaded) {
                    doctorsToShow = state.filteredDoctors;
                    searchQuery = state.searchQuery;
                    print('DoctorsListLoaded: ${doctorsToShow.length} doctors');
                  } else if (state is DoctorsSearched) {
                    doctorsToShow = state.searchResults;
                    searchQuery = state.searchQuery;
                    isSearching = true;
                    print('DoctorsSearched: ${doctorsToShow.length} results');
                  } else if (state is DoctorsFiltered) {
                    doctorsToShow = state.filteredDoctors;
                    searchQuery = state.searchQuery;
                    print('DoctorsFiltered: ${doctorsToShow.length} results');
                  } else if (state is FilterDataLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DoctorInfoInitial) {
                    return Center(child: Text('Loading doctors...'));
                  }

                  // Show appropriate message if no doctors
                  if (doctorsToShow.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSearching ? Icons.search_off : Icons.people_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            isSearching && searchQuery?.isNotEmpty == true
                                ? 'No doctors found for "$searchQuery"'
                                : 'No doctors available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  // Show the doctors list
                  return ListView.builder(
                    itemCount: doctorsToShow.length,
                    itemBuilder: (context, index) {
                      final doctor = doctorsToShow[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                return AboutDoctor(
                                  doctorId: doctor.id.toString(),
                                );
                              },
                            ),
                          );
                        },
                        child: DoctorCard(
                          image: doctor.photo,
                          name: doctor.name,
                          speciality: doctor.speciality,
                          rating: doctor.rating,
                          reviewsNumber: doctor.reviewsNumber,
                          university: doctor.university,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortModalSheet(BuildContext context, DoctorState state) {
    // Get current filter values based on state type
    int? selectedSpecializationId;
    int? selectedCityId;

    if (state is DoctorsListLoaded) {
      selectedSpecializationId = state.selectedSpecializationId;
      selectedCityId = state.selectedCityId;
    } else if (state is DoctorsFiltered) {
      selectedSpecializationId = state.selectedSpecializationId;
      selectedCityId = state.selectedCityId;
    } else if (state is DoctorsSearched) {
      // If searching, get filters from bloc state
      final doctorBloc = context.read<DoctorBloc>();
      if (!doctorBloc.filterDataLoaded) {
        doctorBloc.add(LoadFilterData());
        // Show loading indicator in modal or wait
      }
      final blocState = doctorBloc.state;
      if (blocState is DoctorsFiltered) {
        selectedSpecializationId = blocState.selectedSpecializationId;
        selectedCityId = blocState.selectedCityId;
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: context.read<DoctorBloc>(),
        child: SortModalSheet(
          selectedSpecializationId: selectedSpecializationId,
          selectedCityId: selectedCityId,
          onApply: (specializationId, cityId) {
            context.read<DoctorBloc>().add(
              ApplyFilter(
                specializationId: specializationId,
                cityId: cityId,
              ),
            );
          },
        ),
      ),
    );
  }
}
