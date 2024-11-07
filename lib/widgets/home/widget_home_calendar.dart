import 'package:flutter/material.dart';

class Event {
  final String time;
  final String label;
  final String location;
  final Color color;

  Event({
    required this.time,
    required this.label,
    required this.location,
    required this.color,
  });
}

class CustomEventCard extends StatelessWidget {
  final String date;
  final String month;
  final String day;
  final List<Event> events;

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
      width: 200,
      height: 232,
      decoration: ShapeDecoration(
        color: Color(0xFFF2F2F2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Stack(
        children: [
          // Date display at the top
          Positioned(
            left: 98,
            top: 8,
            child: Text(
              date,
              style: TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 36,
            child: Text(
              month,
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            left: 23,
            top: 21,
            child: Text(
              day,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          // Loop through each event and display it with dynamic positioning
          ...List.generate(events.length, (index) {
            final event = events[index];
            final topPosition = 85 + index * 47.0; // Dynamically position each event

            return Positioned(
              left: 22,
              top: topPosition,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Time display
                  Text(
                    event.time,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 10),
                  // Vertical color indicator for event
                  Container(
                    width: 3,
                    height: 30, // Height of the vertical line
                    decoration: BoxDecoration(
                      color: event.color,
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                  SizedBox(width: 10),
                  // Event label and location with icon in a Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.label,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 8,
                            color: Colors.black,
                          ),
                          SizedBox(width: 4),
                          Text(
                            event.location,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
