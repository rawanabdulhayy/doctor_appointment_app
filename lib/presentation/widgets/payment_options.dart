import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/state_management/booking_appointment_bloc/booking_appointment_bloc.dart';
import '../../business_logic/state_management/booking_appointment_bloc/booking_appointment_event.dart';
import '../../business_logic/state_management/booking_appointment_bloc/booking_appointment_state.dart';

class PaymentOptions extends StatelessWidget {
  const PaymentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethods = [
      {'label': 'Credit Card'},
      {'label': 'Bank Transfer'},
      {'label': 'Paypal'},
    ];

    final creditCardOptions = [
      {
        'label': 'Master Card',
        'icon': 'assets/images/payment_options/mastercard.png'
      },
      {
        'label': 'American Express',
        'icon': 'assets/images/payment_options/american_express.png'
      },
      {
        'label': 'Capital One',
        'icon': 'assets/images/payment_options/capital_one.png'
      },
      {
        'label': 'Barclays',
        'icon': 'assets/images/payment_options/barclays.png'
      },
    ];

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return RadioGroup<String>(
          groupValue: state.paymentMethod, //current selected one -- initialised with null in booking state
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read<BookingBloc>().add(UpdatePaymentEvent(newValue));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- MAIN PAYMENT METHODS ---
              ...List.generate(paymentMethods.length, (index) {
                final method = paymentMethods[index];
                final isSelected = state.paymentMethod == method['label'];
                // final typeIndex = index ~/ 2;
                //that wasn't used here because we only ever use it to know which one container has the divider belong to, here, we only ever have one generation -- payment methods, so no containers and dividers.
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.read<BookingBloc>().add(
                            UpdatePaymentEvent(method['label']!));
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                method['label']!,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected ? Colors.blue : Colors
                                      .black87,
                                ),
                              ),
                            ),
                            Radio<String>(
                              value: method['label']!,
                              activeColor: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- CREDIT CARD SUB-OPTIONS ---
                    if (isSelected && method['label'] == 'Credit Card')
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 4),
                        child: RadioGroup<String>(
                          groupValue: state.creditCardType,
                          onChanged: (String? value) {
                            if (value != null) {
                              context.read<BookingBloc>().add(
                                  UpdateCreditCardEvent(value));
                            }
                          },
                          child: Column(
                            children: creditCardOptions.map((option) {
                              final isCardSelected = state.creditCardType ==
                                  option['label'];
                              return InkWell(
                                onTap: () {
                                  context.read<BookingBloc>().add(
                                      UpdateCreditCardEvent(option['label']!));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6.0),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        option['icon']!,
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          option['label']!,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: isCardSelected
                                                ? Colors.blue
                                                : Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Radio<String>(
                                        value: option['label']!,
                                        activeColor: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                    if (index != paymentMethods.length - 1)
                      const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}