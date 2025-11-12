import 'package:flutter/material.dart';

import '../widgets/doctor_card.dart';

class RecommendationDoctor extends StatefulWidget {
  const RecommendationDoctor({super.key});

  @override
  State<RecommendationDoctor> createState() => _RecommendationDoctorState();
}

class _RecommendationDoctorState extends State<RecommendationDoctor> {
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
              border: BoxBorder.all(color: Colors.grey[100]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15),
              Row(
                children: [
                  Flexible(
                    flex: 10,
                    child: SearchBar(
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
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Flexible(flex: 1,child: Image.asset('assets/images/recommendation_dr/sort.png', width: 30, height: 30,), ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Disable inner scroll
                  padding: EdgeInsets
                      .zero, // Remove default ListView padding because he DoctorCard already has margin built into it. we can't add padding to the ListView, because then we'd be getting double horizontal spacing, which causes an overflow.
                  scrollDirection: Axis.vertical,
                  children: [
                    DoctorCard(
                      image: "assets/images/home_page/dr1.png",
                      name: "Dr. Sarah Johnson",
                      speciality: "Cardiologist",
                      rating: 4.8,
                      reviewsNumber: 128,
                      university: "Harvard Medical School",
                    ),
                    DoctorCard(
                      image: "assets/images/home_page/dr2.png",
                      name: "Dr. Omar Khaled",
                      speciality: "Neurologist",
                      rating: 4.6,
                      reviewsNumber: 98,
                      university: "Stanford University",
                    ),
                    DoctorCard(
                      image: "assets/images/home_page/dr1.png",
                      name: "Dr. Sarah Johnson",
                      speciality: "Cardiologist",
                      rating: 4.8,
                      reviewsNumber: 128,
                      university: "Harvard Medical School",
                    ),
                    DoctorCard(
                      image: "assets/images/home_page/dr2.png",
                      name: "Dr. Omar Khaled",
                      speciality: "Neurologist",
                      rating: 4.6,
                      reviewsNumber: 98,
                      university: "Stanford University",
                    ),  DoctorCard(
                      image: "assets/images/home_page/dr1.png",
                      name: "Dr. Sarah Johnson",
                      speciality: "Cardiologist",
                      rating: 4.8,
                      reviewsNumber: 128,
                      university: "Harvard Medical School",
                    ),
                    DoctorCard(
                      image: "assets/images/home_page/dr2.png",
                      name: "Dr. Omar Khaled",
                      speciality: "Neurologist",
                      rating: 4.6,
                      reviewsNumber: 98,
                      university: "Stanford University",
                    ),
                  ],
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
