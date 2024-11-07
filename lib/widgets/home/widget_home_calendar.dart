import 'package:flutter/material.dart';

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
      child: Stack(
        children: [
          // Background Container
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 200,
              height: 232,
              decoration: ShapeDecoration(
                color: Color(0xFFF2F2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          // Date, Month, Day
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
          // Events List
          for (var i = 0; i < events.length; i++)
            Positioned(
              left: 22,
              top: 85.0 + 47 * i,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    events[i].time,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    events[i].label,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          for (var i = 0; i < events.length; i++)
            Positioned(
              left: 83,
              top: 85.0 + 47 * i,
              child: Transform.rotate(
                angle: 1.57,
                child: Container(
                  width: 31,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 3,
                        color: events[i].color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          for (var i = 0; i < events.length; i++)
            Positioned(
              left: 101,
              top: 108.0 + 47 * i,
              child: Container(
                width: 7,
                height: 7,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: FlutterLogo(),
              ),
            ),
        ],
      ),
    );
  }
}

class Event {
  final String time;
  final String label;
  final Color color;

  Event({required this.time, required this.label, required this.color});
}
