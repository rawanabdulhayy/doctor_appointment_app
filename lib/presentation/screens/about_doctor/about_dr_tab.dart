import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_bloc.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_event.dart';
import '../../../business_logic/state_management/doctor_information_bloc/doctor_information_state.dart';
import '../../../data/models/doctor_model.dart';

class AboutDoctorTab extends StatelessWidget {
  final String doctorId;

  const AboutDoctorTab({
    super.key,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is DoctorError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<DoctorBloc>().add(LoadDoctorDetails(doctorId));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is DoctorInfoLoaded) {
          return _buildDoctorDetails(state.doctor);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDoctorDetails(Doctor doctor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About me",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            doctor.aboutMe.isNotEmpty
                ? doctor.aboutMe
                : "Dr. ${doctor.name} is a ${doctor.speciality} specialist at ${doctor.university}.",
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Working Time",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            doctor.workingTime.isNotEmpty
                ? doctor.workingTime
                : "Monday - Friday, 08.00 AM - 20.00 PM",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "STR",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            doctor.str.isNotEmpty ? doctor.str : "N/A",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Pengalaman Praktik",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            doctor.practiceExperience.isNotEmpty
                ? doctor.practiceExperience
                : doctor.university,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            doctor.practiceYears.isNotEmpty
                ? doctor.practiceYears
                : "2017 - sekarang",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}