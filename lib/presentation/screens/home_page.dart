import 'package:doctor_appointment_app/core/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

import '../widgets/doctor_card.dart';
import '../widgets/speciality_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,

      // appBar: PreferredSize(
      // Q) so what exactly is the difference between the preferredsize wrapper and the toolbarheight? they both complement one another but what is each of them responsible for?

      // | Property            | Belongs To      | What It Does                                                                                                                                            |
      // | ------------------- | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
      // | **`PreferredSize`** | Wrapper widget  | Tells Flutter the **overall size** the child widget (here, your `AppBar`) *wants* to take. It’s used by parents like `Scaffold` to lay out the app bar. |
      // | **`toolbarHeight`** | `AppBar` itself | Controls the **height of the toolbar area** (the main content region inside the app bar).

      // Here, you’re telling Flutter:
      // “I want an AppBar that prefers to be about 106 px tall (56 + 50), but the toolbar’s own content is 200 px tall.”
      // This mismatch causes layout stretching, and the Scaffold will size the app bar based on whichever height is larger.

      // PreferredSize = outer wrapper size hint for layout
      // toolbarHeight = internal content height (the visible toolbar section)

      //   //the default, 56 px + 25 top + 25 bottom.
      //   preferredSize: const Size.fromHeight(kToolbarHeight + 50),
      //   child: AppBar(
      //     toolbarHeight: 200,
      //     leading: Column(
      //       children: [
      //         Text('Hi Omar!'),
      //         Text('How are you today?'),
      //       ],
      //     ),
      //   ),
      // ),

      // This (flexibleSpace approach )replaces the usual compact toolbar with a custom one that can include any widget you want — multiple text lines, icons, even input fields — while still behaving like an AppBar (staying at the top, scrolling correctly, etc.).

      // flexibleSpace = background or full layout space inside the AppBar.
      // It sits under the toolbar (and title/leading/action widgets).

      // Use it for:
      // Gradients, images, blur effects.
      // Multi-line titles or custom layouts.
      // Fancy headers (like a “welcome” message or search bar).
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 85,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hi Omar!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'How are you today?',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[100],
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                //background container
                Container(
                  margin: const EdgeInsets.all(
                    16,
                  ),
                  height: height * 0.5 * 0.5,
                  width: width,
                  decoration: BoxDecoration(
                    color: AppColors.boldPrimaryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Book and \n"
                          "schedule with\n"
                          "nearest doctor",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColors.faintPrimaryColor,
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            "Find Nearby",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: width * 0.5 + 15,
                  child: Image.asset(
                    "assets/images/home_page/smiling_dr_female.png",
                    height: height * 0.5 * 0.5 + 16,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "Doctor Speciality",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.faintPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SpecialityCard(
                    icon: "assets/images/home_page/dr_icon.png",
                    specialityType: "General",
                  ),
                  SpecialityCard(
                    icon: "assets/images/home_page/brain.png",
                    specialityType: "Neurologic",
                  ),
                  SpecialityCard(
                    icon: "assets/images/home_page/baby.png",
                    specialityType: "Pediatric",
                  ),
                  SpecialityCard(
                    icon: "assets/images/home_page/kidneys.png",
                    specialityType: "Radiology",
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    "Doctor Recommendation",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.faintPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),  // Disable inner scroll
              padding: EdgeInsets.zero, // Remove default ListView padding because he DoctorCard already has margin built into it. we can't add padding to the ListView, because then we'd be getting double horizontal spacing, which causes an overflow.
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
