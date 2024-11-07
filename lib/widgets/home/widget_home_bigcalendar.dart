import 'package:flutter/material.dart';

class CalendarOverview extends StatelessWidget {
  const CalendarOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 184,
      child: Stack(
        children: [
          // Background container with rounded corners
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 340,
              height: 184,
              decoration: ShapeDecoration(
                color: Color(0xFFF2F2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          // Month and year label
          Positioned(
            left: 35,
            top: 23,
            child: Text(
              'October, 2024',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Chevron down icon for month selection
          Positioned(
            left: 126,
            top: 23,
            child: Icon(
              Icons.expand_more, // Chevron down icon
              size: 17,
              color: Colors.black,
            ),
          ),
          // Plus icon for adding events
          Positioned(
            left: 297,
            top: 23,
            child: Icon(
              Icons.add, // Plus icon
              size: 15,
              color: Colors.black,
            ),
          ),
          // Horizontal line below the month and above weekday labels
          Positioned(
            left: 0, // Align the line with the container's left edge
            top: 60,
            child: Container(
              width: 340, // Set width to match the container
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Color(0xFFE6E6E6),
                  ),
                ),
              ),
            ),
          ),
          // Weekday labels
          ..._buildWeekdayLabels(),
          // Date circles
          ..._buildDateCircles(),
          // Date numbers (centered in circles)
          ..._buildDateNumbers(),
        ],
      ),
    );
  }

  // Helper method to create weekday labels
  List<Widget> _buildWeekdayLabels() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return List.generate(
      days.length,
      (index) => Positioned(
        left: 35.0 + index * 44,
        top: 77,
        child: Text(
          days[index],
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Helper method to create date circles
  List<Widget> _buildDateCircles() {
    return List.generate(
      7,
      (index) => Positioned(
        left: 25.0 + index * 44,
        top: 97,
        child: Container(
          width: 30,
          height: 29,
          decoration: ShapeDecoration(
            color: Color(0xFFD9D9D9),
            shape: OvalBorder(),
          ),
        ),
      ),
    );
  }

  // Helper method to create date numbers centered in circles
  List<Widget> _buildDateNumbers() {
    const dates = ['27', '28', '29', '30', '31', '1', '2'];
    return List.generate(
      dates.length,
      (index) => Positioned(
        left: 25.0 + index * 44,
        top: 97, // Aligns with the circle's top position
        child: Container(
          width: 30,
          height: 29,
          alignment: Alignment.center, // Centers the text within the container
          child: Text(
            dates[index],
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
