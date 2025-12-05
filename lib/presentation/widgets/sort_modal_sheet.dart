// import 'package:flutter/material.dart';
//
// class SortModalSheet extends StatefulWidget {
//   final int? selectedSpecializationId;
//   final int? selectedCityId;
//   //that's supposedly a callback function, right? what is its workflow? where should it be defined and where should it be called back upon?
//   final Function(int?, int?) onApply;
//
//   const SortModalSheet({
//     super.key,
//     this.selectedSpecializationId,
//     this.selectedCityId,
//     required this.onApply,
//   });
//
//   @override
//   State<SortModalSheet> createState() => _SortBottomSheetState();
// }
//
// class _SortBottomSheetState extends State<SortModalSheet> {
//   int? _selectedSpecializationId;
//   int? _selectedCityId;
//
//   @override
//   void initState() {
//     super.initState();
//     //okay but where is widget.selectedSpeciality and widget.selectedRating even initialised?
//     _selectedSpecializationId = widget.selectedSpecializationId;
//     _selectedCityId = widget.selectedCityId;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       padding: EdgeInsets.all(24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Title
//           Center(
//             child: Text(
//               'Sort By',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//
//           // Speciality Section
//           Text(
//             'Speciality',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 12),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 _buildSpecialityContainer('All', null),
//                 SizedBox(width: 10),
//                 _buildSpecialityContainer('General', 'General'),
//                 SizedBox(width: 10),
//                 _buildSpecialityContainer('Neurologic', 'Neurologist'),
//                 SizedBox(width: 10),
//                 _buildSpecialityContainer('Cardiologist', 'Cardiologist'),
//               ],
//             ),
//           ),
//           SizedBox(height: 30),
//
//           // Rating Section
//           Text(
//             'Rating',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 12),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 //okay but why does 3 and 4 both show all the 4.(digits)?
//                 _buildRatingContainer('All', null),
//                 SizedBox(width: 10),
//                 _buildRatingContainer('5', 5),
//                 SizedBox(width: 10),
//                 _buildRatingContainer('4', 4),
//                 SizedBox(width: 10),
//                 _buildRatingContainer('3', 3),
//               ],
//             ),
//           ),
//           SizedBox(height: 30),
//
//           // Done Button
//           SizedBox(
//             //we need a sizedBox wrapper in order to manipulate the ElevatedButton's dimensions.
//             width: double.infinity,
//             height: 54,
//             child: ElevatedButton(
//               onPressed: () {
//                 widget.onApply(_selectedSpeciality, _selectedRating);
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF2E59D9),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text(
//                 'Done',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSpecialityContainer(String label, String? value) {
//     //what does this line evaluate to? and what does it even do? does it initialise both _selectedSpeciality and isSelected?
//     final isSelected = _selectedSpeciality == value;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           //to be up to date with whatsoever selections the user presses, but does that rebuild the whole page or just this widget; _buildSpecialityContainer?
//           _selectedSpeciality = value;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Color(0xFF2E59D9) : Color(0xFFF5F5F5),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Color(0xFF9E9E9E),
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildRatingContainer(String label, int? value) {
//     final isSelected = _selectedRating == value;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedRating = value;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Color(0xFF2E59D9) : Color(0xFFF5F5F5),
//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Row(
//           //what does this property do; mainAxisSize?
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.star,
//               size: 18,
//               color: isSelected ? Colors.white : Color(0xFF9E9E9E),
//             ),
//             SizedBox(width: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Color(0xFF9E9E9E),
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_state.dart';
import '../../business_logic/state_management/doctor_information_bloc/doctor_information_event.dart';
import '../../data/models/doctor_model.dart';

class SortModalSheet extends StatefulWidget {
  final int? selectedSpecializationId;
  final int? selectedCityId;
  final Function(int?, int?) onApply;

  const SortModalSheet({
    super.key,
    this.selectedSpecializationId,
    this.selectedCityId,
    required this.onApply,
  });

  @override
  State<SortModalSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortModalSheet> {
  int? _selectedSpecializationId;
  int? _selectedCityId;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with values from parent
    _selectedSpecializationId = widget.selectedSpecializationId;
    _selectedCityId = widget.selectedCityId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorBloc, DoctorState>(
      listener: (context, state) {
        // Load filter data if not already loaded
        if (!_isInitialized) {
          // Check if filter data is already loaded or loading
          if (state is FilterDataLoaded || state is FilterDataLoading) {
            _isInitialized = true;
          } else {
            // Only load if not already loaded
            context.read<DoctorBloc>().add(LoadFilterData());
            _isInitialized = true;
          }
        }
      },
      child: BlocBuilder<DoctorBloc, DoctorState>(
        builder: (context, state) {
          print('SortModalSheet state: ${state.runtimeType}');

          // Check if filter data is already loaded
          if (state is FilterDataLoaded) {
            return _buildContent(state.specializations, state.cities);
          }

          // Check if filter data is being loaded
          if (state is FilterDataLoading) {
            return _buildLoading();
          }

          // Check if filter data failed to load
          if (state is FilterError) {
            return _buildError(state.message);
          }

          // If we have doctors list loaded but filter data not yet loaded,
          // check cache in bloc or trigger loading
          final doctorBloc = context.read<DoctorBloc>();

          // Try to access cached data if available
          if (doctorBloc.specializationsCache.isNotEmpty &&
              doctorBloc.citiesCache.isNotEmpty) {
            return _buildContent(
                doctorBloc.specializationsCache,
                doctorBloc.citiesCache
            );
          }

          // If we're in other states (like DoctorsListLoaded), show loading
          // and trigger filter data load
          if (!_isInitialized) {
            // Use Future.microtask to avoid setState during build
            Future.microtask(() {
              if (mounted && !_isInitialized) {
                context.read<DoctorBloc>().add(LoadFilterData());
                _isInitialized = true;
              }
            });
          }

          return _buildLoading();
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading filter options...'),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(24),
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Failed to load filter options',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<DoctorBloc>().add(LoadFilterData());
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<Specialization> specializations, List<City> cities) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Center(
            child: Text(
              'Filter By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 30),

          // Specialization Section
          Text(
            'Specialization',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // "All" option
                _buildSpecializationContainer('All', null),
                SizedBox(width: 10),
                // Dynamic specialization options
                ...specializations.map((spec) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: _buildSpecializationContainer(
                      spec.name,
                      spec.id,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 30),

          // City Section
          Text(
            'City',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // "All" option
                _buildCityContainer('All', null),
                SizedBox(width: 10),
                // Dynamic city options
                ...cities.map((city) {
                  return Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: _buildCityContainer(
                      city.name,
                      city.id,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          SizedBox(height: 30),

          // Action Buttons
          Row(
            children: [
              // Clear Button
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedSpecializationId = null;
                        _selectedCityId = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Color(0xFF2E59D9)),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: Color(0xFF2E59D9),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Apply Button
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_selectedSpecializationId, _selectedCityId);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E59D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSpecializationContainer(String label, int? value) {
    final isSelected = _selectedSpecializationId == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSpecializationId = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2E59D9) : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF9E9E9E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCityContainer(String label, int? value) {
    final isSelected = _selectedCityId == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCityId = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2E59D9) : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF9E9E9E),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}