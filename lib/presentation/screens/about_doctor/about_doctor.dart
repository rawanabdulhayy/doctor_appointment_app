// import 'package:flutter/material.dart';
//
// import '../../../core/app_colors/app_colors.dart';
// import 'about_dr_tab.dart';
//
// class AboutDoctor extends StatelessWidget {
//   final String image;
//   final String name;
//   final String speciality;
//   final double rating;
//   final int reviewsNumber;
//   final String university;
//
//   const AboutDoctor({
//     super.key,
//     required this.image,
//     required this.name,
//     required this.speciality,
//     required this.rating,
//     required this.reviewsNumber,
//     required this.university,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Text(
//             name,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           centerTitle: true,
//           actions: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey[100]!),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
//             ),
//           ],
//         ),
//
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //  Doctor info section
//               Row(
//                 children: [
//                   Flexible(
//                     flex: 74,
//                     child: Image.asset(image, width: 74, height: 74),
//                   ),
//                   SizedBox(width: 10),
//                   Flexible(
//                     flex: 216,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                         Text(
//                           '$speciality | $university',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.star, color: Colors.amber, size: 16),
//                             SizedBox(width: 4),
//                             Text(
//                               rating.toStringAsFixed(1),
//                               style: TextStyle(fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(width: 4),
//                             Text(
//                               '($reviewsNumber reviews)',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey[600],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(width: 15),
//                   Flexible(
//                     flex: 24,
//                     child: Image.asset(
//                       "assets/images/about_doctor/message_text.png",
//                       width: 24,
//                       height: 24,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               //  TabBar definition
//               //so tabBar is the actual bar (tabs List), and the tabBarView is the content shown in each tab (children List).
//               TabBar(
//                 indicatorColor: Colors.blue,
//                 indicatorSize:
//                     TabBarIndicatorSize.tab, // indicator matches text width
//                 labelColor: AppColors.boldPrimaryColor,
//                 labelStyle: TextStyle(fontWeight: FontWeight.w700),
//                 unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
//                 unselectedLabelColor: Color.fromRGBO(158, 158, 158, 1),
//                 dividerColor: Color.fromRGBO(237, 237, 237, 2),
//                 //is there a divider width?
//                 //what does a controller do? and what happens if there isn't one defined?
//                 //can I have access to change the width of the indicator line under the selected tab?
//                 tabs: [
//                   Tab(text: "About"),
//                   Tab(text: "Location"),
//                   Tab(text: "Reviews"),
//                 ],
//               ),
//               SizedBox(height: 10),
//               //  Tab content
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     AboutDoctorTab(doctorId: doctorId),
//                     Center(child: Text("Location content")),
//                     Center(child: Text("Reviews content")),
//                   ],
//                 ),
//               ),
//
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor: AppColors.boldPrimaryColor,
//                     // minimumSize: Size.fromWidth(MediaQuery.of(context).size.width,),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: Text("Make an Appointment"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_event.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_state.dart';
import '../../../core/app_colors/app_colors.dart';
import '../../../core/dependency_injection/injection_container.dart';
import '../../../data/models/doctor_model.dart';
import '../../widgets/screen_wrapper/three_page_booking_appointment.dart';
import 'about_dr_tab.dart';

class AboutDoctor extends StatelessWidget {
  final String doctorId;

  const AboutDoctor({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // create: (context) => DoctorBloc(
      //   repository: DoctorRepository(baseUrl: 'your_base_url_here'),
      // )..add(LoadDoctorDetails(doctorId)),
      create: (context) => sl<DoctorBloc>()..add(LoadDoctorDetails(doctorId)),
      child: _AboutDoctorContent(doctorId: doctorId),
    );
  }
}

class _AboutDoctorContent extends StatelessWidget {
  final String doctorId;

  const _AboutDoctorContent({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoading) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.white),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is DoctorError) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.white),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DoctorBloc>().add(
                        LoadDoctorDetails(doctorId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is DoctorInfoLoaded) {
          final doctor = state.doctor;
          return _buildDoctorScreen(doctor, context);
        }

        return Scaffold(
          appBar: AppBar(backgroundColor: Colors.white),
          body: const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildDoctorScreen(Doctor doctor, BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            doctor.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[100]!),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor info section
              Row(
                children: [
                  Flexible(
                    flex: 74,
                    child: CircleAvatar(
                      radius: 37,
                      backgroundImage: NetworkImage(doctor.photo),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    flex: 216,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${doctor.specialization.name} | ${doctor.university}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              doctor.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${doctor.reviewsNumber} reviews)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    flex: 24,
                    child: Image.asset(
                      "assets/images/about_doctor/message_text.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // TabBar definition
              TabBar(
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.boldPrimaryColor,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelColor: const Color.fromRGBO(158, 158, 158, 1),
                dividerColor: const Color.fromRGBO(237, 237, 237, 2),
                tabs: const [
                  Tab(text: "About"),
                  Tab(text: "Location"),
                  Tab(text: "Reviews"),
                ],
              ),
              const SizedBox(height: 10),
              // Tab content
              Expanded(
                child: TabBarView(
                  children: [
                    AboutDoctorTab(doctorId: doctorId),
                    Center(child: Text("Location: ${doctor.address}")),
                    const Center(child: Text("Reviews content")),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.boldPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ThreePageBookingAppointment(doctor: doctor),
                      ),
                    );
                  },
                  child: Text("Make an Appointment - \$${doctor.appointPrice}"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
