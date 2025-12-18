// import 'package:doctor_appointment_app/business_logic/state_management/booking_appointment_bloc/booking_appointment_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
// import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
// import '../../../core/app_colors/app_colors.dart';
// import '../../widgets/date_and_time_page/booking_appointment_progress_bar.dart';
// import '../../widgets/doctor_card.dart';
//
// class Summary extends StatelessWidget {
//   const Summary({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: BlocBuilder<BookingBloc, BookingState>(
//           builder: (context, state) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const BookingAppointmentProgressBar(),
//                         const SizedBox(height: 20),
//                         const Text(
//                           "Booking Information",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         _buildDateAndTimeSection(state),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Divider(
//                             color: Colors.grey[200],
//                             thickness: 1,
//                             height: 10,
//                           ),
//                         ),
//                         _buildAppointmentTypeSection(state),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Divider(
//                             color: Colors.grey[200],
//                             thickness: 1,
//                             height: 10,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         const Text(
//                           "Doctor Information",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         //todo: this needs to be replaced with the actual bloc that saves the info of the doctor appointment being booked and reflected in such a card.
//                         DoctorCard(
//                           image: "assets/images/home_page/dr1.png",
//                           name: "Dr. Sarah Johnson",
//                           speciality: "Cardiologist",
//                           rating: 4.8,
//                           reviewsNumber: 128,
//                           university: "Harvard Medical School",
//                         ),
//                         const Text(
//                           "Payment Information",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         _buildPaymentInfoSection(context, state),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ),
//                 _buildPaymentSummary(context),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------
//   // 🧩 Sub-widgets
//   // ---------------------------
//
//   Widget _buildDateAndTimeSection(BookingState state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
//       child: Row(
//         children: [
//           _iconBox("assets/images/summary/date_time.png"),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Date & Time",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 state.selectedDate != null
//                     ? DateFormat(
//                         'EEEE, dd MMMM yyyy',
//                       ).format(state.selectedDate!)
//                     : "Not selected",
//                 style: const TextStyle(color: Colors.grey),
//               ),
//               Text(
//                 state.selectedTime ?? "Not selected",
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAppointmentTypeSection(BookingState state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
//       child: Row(
//         children: [
//           _iconBox("assets/images/summary/appointment_type.png"),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Appointment Type",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 state.appointmentType ?? 'Not selected',
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPaymentInfoSection(BuildContext context, BookingState state) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
//       child: Row(
//         children: [
//           _iconBox(
//             state.paymentMethod == 'Credit Card'
//                 ? "assets/images/payment_options/mastercard.png"
//                 : state.paymentMethod == 'Bank Transfer'
//                 ? "assets/images/summary/bank_transfer.png"
//                 : "assets/images/summary/paypal.png",
//           ),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 state.paymentMethod ?? "Not Selected",
//                 style: const TextStyle(fontWeight: FontWeight.w600),
//               ),
//               Text(
//                 state.paymentMethod ?? 'Not selected',
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//           const Spacer(),
//           GestureDetector(
//             onTap: () {
//               context.read<BookingBloc>().add(PreviousPageEvent());
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(48),
//                 border: Border.all(color: AppColors.faintPrimaryColor),
//               ),
//               padding: const EdgeInsets.symmetric(
//                 vertical: 8.0,
//                 horizontal: 16.0,
//               ),
//               child: Text(
//                 'Change',
//                 style: TextStyle(color: AppColors.faintPrimaryColor),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------------
//   // 💳 Sticky Bottom Summary
//   // ---------------------------
//   Widget _buildPaymentSummary(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 12,
//             offset: const Offset(0, -4),
//           ),
//         ],
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       padding: const EdgeInsets.all(20),
//       child: SafeArea(
//         top: false,
//         child: Column(
//           // mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: Text(
//                 'Payment Info',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildPriceRow('Subtotal', '\$4694'),
//             const SizedBox(height: 8),
//             _buildPriceRow('Tax', '\$250'),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1),
//               child: Divider(color: Colors.grey[200], thickness: 1, height: 10),
//             ),
//             _buildPriceRow('Payment Total', '\$4944', isBold: true),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               height: 56,
//               child: ElevatedButton(
//                 onPressed: () {
//                   context.read<BookingBloc>().add(SubmitBookingEvent());
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF2196F3),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: const Text(
//                   'Book Now',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ---------------------------
//   // 🧱 Helpers
//   // ---------------------------
//   Widget _iconBox(String assetPath) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: const Color.fromRGBO(255, 238, 239, 1),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Image.asset(assetPath),
//     );
//   }
//
//   Widget _buildPriceRow(String label, String amount, {bool isBold = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         Text(
//           amount,
//           style: TextStyle(
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:doctor_appointment_app/business_logic/state_management/booking_appointment_bloc/booking_appointment_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import '../../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';
import '../../../core/app_colors/app_colors.dart';
import '../../widgets/date_and_time_page/booking_appointment_progress_bar.dart';
import '../../widgets/doctor_card.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  double _calculateSubtotal(BookingState state) {
    return state.doctor.appointPrice;
  }

  double _calculateTax(BookingState state) {
    return _calculateSubtotal(state) * 0.05; // 5% tax
  }

  double _calculateTotal(BookingState state) {
    return _calculateSubtotal(state) + _calculateTax(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state.isSubmitted) {
              // Show success dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  title: Center(child: Text('Booking Confirmed!')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 64),
                      SizedBox(height: 16),
                      Text(
                        'Your appointment has been booked successfully.',
                        textAlign: TextAlign.center,
                      ),
                      if (state.bookingId != null) ...[
                        SizedBox(height: 8),
                        Text(
                          'Booking ID: ${state.bookingId}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Close booking flow
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }

            if (state.errorMessage != null && !state.isSubmitting) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BookingAppointmentProgressBar(),
                        const SizedBox(height: 20),
                        const Text(
                          "Booking Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDateAndTimeSection(state),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Divider(
                            color: Colors.grey[200],
                            thickness: 1,
                            height: 10,
                          ),
                        ),
                        _buildAppointmentTypeSection(state),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Divider(
                            color: Colors.grey[200],
                            thickness: 1,
                            height: 10,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Doctor Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Now using actual doctor data from state
                        DoctorCard(
                          image: state.doctor.photo,
                          name: state.doctor.name,
                          speciality: state.doctor.speciality,
                          rating: state.doctor.rating,
                          reviewsNumber: state.doctor.reviewsNumber,
                          university: state.doctor.university,
                        ),
                        const Text(
                          "Payment Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildPaymentInfoSection(context, state),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                _buildPaymentSummary(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateAndTimeSection(BookingState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        children: [
          _iconBox("assets/images/summary/date_time.png"),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Date & Time",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                state.selectedDate != null
                    ? DateFormat('EEEE, dd MMMM yyyy').format(state.selectedDate!)
                    : "Not selected",
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                state.selectedTime ?? "Not selected",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentTypeSection(BookingState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        children: [
          _iconBox("assets/images/summary/appointment_type.png"),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Appointment Type",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                state.appointmentType ?? 'Not selected',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoSection(BuildContext context, BookingState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        children: [
          _iconBox(
            state.paymentMethod == 'Credit Card'
                ? "assets/images/payment_options/mastercard.png"
                : state.paymentMethod == 'Bank Transfer'
                ? "assets/images/summary/bank_transfer.png"
                : "assets/images/summary/paypal.png",
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.paymentMethod ?? "Not Selected",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (state.creditCardType != null)
                Text(
                  state.creditCardType!,
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.read<BookingBloc>().add(PreviousPageEvent());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(48),
                border: Border.all(color: AppColors.faintPrimaryColor),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Text(
                'Change',
                style: TextStyle(color: AppColors.faintPrimaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummary(BuildContext context, BookingState state) {
    final subtotal = _calculateSubtotal(state);
    final tax = _calculateTax(state);
    final total = _calculateTotal(state);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Payment Info',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 16),
            _buildPriceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            _buildPriceRow('Tax (5%)', '\$${tax.toStringAsFixed(2)}'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 1),
              child: Divider(color: Colors.grey[200], thickness: 1, height: 10),
            ),
            _buildPriceRow(
              'Payment Total',
              '\$${total.toStringAsFixed(2)}',
              isBold: true,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: state.isSubmitting
                    ? null
                    : () {
                  context.read<BookingBloc>().add(SubmitBookingEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: state.isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Book Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _iconBox(String assetPath) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 238, 239, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(assetPath),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}