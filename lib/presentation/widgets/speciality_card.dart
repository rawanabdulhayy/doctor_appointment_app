import 'package:flutter/material.dart';

class SpecialityCard extends StatelessWidget {
  final String specialityType;
  final String icon;
  const SpecialityCard({super.key, required this.icon, required this.specialityType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(icon),
            ),
          ),
          SizedBox(height: 10,),
          Text(specialityType),
        ],
      ),
    );
  }
}
