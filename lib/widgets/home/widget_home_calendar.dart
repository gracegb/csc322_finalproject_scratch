import 'package:flutter/material.dart';
import 'package:csc322_starter_app/screens/general/screen_home.dart';

class CustomEventCard extends StatelessWidget {
  final String date;
  final String month;
  final String day;
  final List<HomeEvent> events;

  const CustomEventCard({
    Key? key,
    required this.date,
    required this.month,
    required this.day,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116, // Match CustomAttentionCard width
      height: 232, // Match CustomAttentionCard height
      decoration: ShapeDecoration(
        color: Color(0xFFF2F2F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for Day and Date
            Row(
              crossAxisAlignment: CrossAxisAlignment.end, // Align to the bottom
              children: [
                // Day and Month Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day, // Day (e.g., "Monday")
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      month, // Month (e.g., "JAN")
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 38,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5), // Spacing between Month and Date
                // Date Text
                Text(
                  date, // Date (e.g., "15")
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 85,
                    fontWeight: FontWeight.w600,
                    height: 1.0, // Adjust line height for better alignment
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Reduced space between Date/Month and Events

            // Events List
            Expanded(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Time
                        Text(
                          event.time,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 8),
                        // Vertical Line
                        Container(
                          width: 2,
                          height: 20,
                          color: event.color,
                        ),
                        SizedBox(width: 8),
                        // Event Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.label,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                event.location,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
