import 'package:doctor_appointment_app/presentation/widgets/sort_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/state_management/recommendation_doctor_bloc/recommendation_doctor_bloc.dart';
import '../../business_logic/state_management/recommendation_doctor_bloc/recommendation_doctor_event.dart';
import '../../business_logic/state_management/recommendation_doctor_bloc/recommendation_doctor_state.dart';
import '../widgets/doctor_card.dart';

//why do we have a separate RecommendationDoctor widget that only ever builds a context for a blocProvider to wrap the RecommendationDoctorView? can't we just wrap the blocProvider whilst navigating to the RecommendationDoctorView page?
class RecommendationDoctor extends StatelessWidget {
  const RecommendationDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //what does the two dots (..) operator do? and how are they different from the three dots (...) used in here (...List.generate(paymentMethods.length, (index) {)? what are each's use cases?
      create: (context) => DoctorFilterBloc()..add(LoadDoctors()),
      child: const RecommendationDoctorView(),
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
            BlocBuilder<DoctorFilterBloc, DoctorFilterState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 10,
                      child: SearchBar(
                        onChanged: (searchQuery) {
                          context.read<DoctorFilterBloc>().add(SearchDoctors(searchQuery));
                        },
                        leading: Image.asset("assets/images/recommendation_dr/search_normal.png", width: 24, height: 24,),
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
                        child: Image.asset("assets/images/recommendation_dr/sort.png", width: 30, height: 30,),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 16),

            // Doctor List
            Expanded(
              child: BlocBuilder<DoctorFilterBloc, DoctorFilterState>(
                builder: (context, state) {
                  if (state is DoctorFilterLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is DoctorFilterError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is DoctorFilterLoaded) {
                    if (state.filteredDoctors.isEmpty) {
                      return Center(
                        child: Text('No doctors found matching your criteria'),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = state.filteredDoctors[index];
                        return DoctorCard(
                          image: doctor.image,
                          name: doctor.name,
                          speciality: doctor.speciality,
                          rating: doctor.rating,
                          reviewsNumber: doctor.reviewsNumber,
                          university: doctor.university,
                        );
                      },
                    );
                  }
                  //shows nothing, I can also return an empty container.
                  return SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortModalSheet(BuildContext context, DoctorFilterState state) {
    //what does the (is!) operator mean?
    if (state is! DoctorFilterLoaded) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      //how does the builder here work? and is ((bottomSheetContext) => SortModalSheet()) a callback function? or is it an ordinary one? and what even is this passed (bottomSheetContext)?
      builder: (bottomSheetContext) => SortModalSheet(
        selectedSpeciality: state.selectedSpeciality,
        selectedRating: state.selectedRating,
        onApply: (speciality, rating) {
          context.read<DoctorFilterBloc>().add(
            ApplyFilter(speciality: speciality, rating: rating),
          );
        },
      ),
    );
  }
}