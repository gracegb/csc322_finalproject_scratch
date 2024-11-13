import 'package:csc322_starter_app/providers/provider_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CalendarOverview extends StatefulWidget {
  const CalendarOverview({Key? key}) : super(key: key);

  @override
  _CalendarOverviewState createState() => _CalendarOverviewState();
}

class _CalendarOverviewState extends State<CalendarOverview> {
  DateTime _focusedDate = DateTime.now();
  final DateTime _today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final currentMonth = DateFormat.yMMMM().format(_focusedDate);
    final daysInMonth = DateTime(_focusedDate.year, _focusedDate.month + 1, 0).day;
    final firstDayOffset = DateTime(_focusedDate.year, _focusedDate.month, 1).weekday % 7;

    return Container(
      width: 340,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          // Month and year label with navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.black),
                onPressed: _previousMonth,
              ),
              Text(
                currentMonth,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.black),
                onPressed: _nextMonth,
              ),
            ],
          ),
          // Horizontal divider
          Divider(color: Color(0xFFE6E6E6)),
          // Weekday labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('S', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
              Text('M', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
              Text('T', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
              Text('W', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
              Text('T', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
              Text('F', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
              Text('S', style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          // Date Grid
          GridView.builder(
            physics: NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 days in a week
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: firstDayOffset + daysInMonth,
            itemBuilder: (context, index) {
              // Empty spaces for days of the previous month
              if (index < firstDayOffset) {
                return Container(); // Empty cell
              }
              final dayNumber = index - firstDayOffset + 1;
              // Check if this day is the current date
              final isToday = _focusedDate.year == _today.year &&
                  _focusedDate.month == _today.month &&
                  dayNumber == _today.day;
              return Container(
                decoration: ShapeDecoration(
                  color: isToday ? Color(0xFFFFF3E3) : Color(0xFFD9D9D9), // Red for today, grey for other dates
                  shape: OvalBorder(),
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      color: isToday? Color(0xFF7C3030) : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
          // Google Sign-In button
          SizedBox(height: 16),
          InkWell(
            onTap: () async {
              await context.read<ProviderAuth>().signInWithGoogle();
            },
            child: Icon(
              Icons.login,
              size: 24,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
    });
  }
}
