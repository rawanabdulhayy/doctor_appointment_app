import 'package:flutter/material.dart';

class SortModalSheet extends StatefulWidget {
  final String? selectedSpeciality;
  final int? selectedRating;
  //that's supposedly a callback function, right? what is its workflow? where should it be defined and where should it be called back upon?
  final Function(String?, int?) onApply;

  const SortModalSheet({
    super.key,
    this.selectedSpeciality,
    this.selectedRating,
    required this.onApply,
  });

  @override
  State<SortModalSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortModalSheet> {
  String? _selectedSpeciality;
  int? _selectedRating;

  @override
  void initState() {
    super.initState();
    //okay but where is widget.selectedSpeciality and widget.selectedRating even initialised?
    _selectedSpeciality = widget.selectedSpeciality;
    _selectedRating = widget.selectedRating;
  }

  @override
  Widget build(BuildContext context) {
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
              'Sort By',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 30),

          // Speciality Section
          Text(
            'Speciality',
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
                _buildSpecialityContainer('All', null),
                SizedBox(width: 10),
                _buildSpecialityContainer('General', 'General'),
                SizedBox(width: 10),
                _buildSpecialityContainer('Neurologic', 'Neurologist'),
                SizedBox(width: 10),
                _buildSpecialityContainer('Cardiologist', 'Cardiologist'),
              ],
            ),
          ),
          SizedBox(height: 30),

          // Rating Section
          Text(
            'Rating',
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
                //okay but why does 3 and 4 both show all the 4.(digits)?
                _buildRatingContainer('All', null),
                SizedBox(width: 10),
                _buildRatingContainer('5', 5),
                SizedBox(width: 10),
                _buildRatingContainer('4', 4),
                SizedBox(width: 10),
                _buildRatingContainer('3', 3),
              ],
            ),
          ),
          SizedBox(height: 30),

          // Done Button
          SizedBox(
            //we need a sizedBox wrapper in order to manipulate the ElevatedButton's dimensions.
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_selectedSpeciality, _selectedRating);
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
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSpecialityContainer(String label, String? value) {
    //what does this line evaluate to? and what does it even do? does it initialise both _selectedSpeciality and isSelected?
    final isSelected = _selectedSpeciality == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          //to be up to date with whatsoever selections the user presses, but does that rebuild the whole page or just this widget; _buildSpecialityContainer?
          _selectedSpeciality = value;
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

  Widget _buildRatingContainer(String label, int? value) {
    final isSelected = _selectedRating == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRating = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2E59D9) : Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          //what does this property do; mainAxisSize?
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star,
              size: 18,
              color: isSelected ? Colors.white : Color(0xFF9E9E9E),
            ),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF9E9E9E),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}