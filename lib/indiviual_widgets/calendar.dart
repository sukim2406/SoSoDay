import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../globals.dart' as globals;

class Calendar extends StatefulWidget {
  final Map selectEvents;
  final Function setDates;
  final getEvents;

  const Calendar({
    Key? key,
    required this.selectEvents,
    required this.setDates,
    required this.getEvents,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: globals.primaryColor,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: globals.tertiaryColor,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: globals.secondaryColor,
          shape: BoxShape.circle,
        ),
      ),
      firstDay: DateTime.utc(2020, 01, 01),
      lastDay: DateTime.utc(2040, 12, 31),
      focusedDay: DateTime.now(),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.setDates(selectedDay, focusedDay);
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(
          () {
            _calendarFormat = format;
          },
        );
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: widget.getEvents,
    );
  }
}
