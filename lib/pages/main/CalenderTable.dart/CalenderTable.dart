import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../functions/GetMemories.dart';
import "./MemoryByDate.dart";

class CalenderTable extends StatefulWidget {
  const CalenderTable({Key? key});

  @override
  State<CalenderTable> createState() => _CalenderTableState();
}

class _CalenderTableState extends State<CalenderTable> {
  Map<String, dynamic> allMemories = {};
  List<String> dateStrings = [];
  List<DateTime> focusedDays = [];

  @override
  void initState() {
    super.initState();
    getMemoryByDate();
  }

  Future<void> getMemoryByDate() async {
    allMemories = await GetMemories.getMemoryByDate();
    convertDates();
  }

  void convertDates() {
    dateStrings = allMemories.keys.toList();
    DateTime now = DateTime.now();

    DateTime convertToDate(String date, int year) {
      DateFormat format = DateFormat("d MMMM yyyy");
      return format.parse('$date $year');
    }

    for (int i = 0; i < dateStrings.length; i++) {
      DateTime convertedDate = convertToDate(dateStrings[i], now.year);
      focusedDays.add(convertedDate);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String date;
    return Container(
      child: TableCalendar(
        rowHeight: 43,
        headerStyle: const HeaderStyle(
          headerMargin: EdgeInsets.fromLTRB(40, 0, 40, 10),
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Color(0xff999191),
            fontFamily: "Poppins",
            fontSize: 12,
          ),
          weekendStyle: TextStyle(
            color: Color(0xff999191),
            fontFamily: "Poppins",
            fontSize: 12,
          ),
        ),
        calendarStyle: const CalendarStyle(
          todayTextStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 12,
            color: Colors.white,
            decorationColor: Color(0xff9FBDF9),
          ),
          outsideTextStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 12,
            color: Colors.black54,
          ),
          defaultTextStyle: TextStyle(
            color: Colors.black54,
            fontFamily: "Poppins",
            fontSize: 12,
          ),
          weekendTextStyle: TextStyle(
            color: Colors.black54,
            fontFamily: "Poppins",
            fontSize: 12,
          ),
          selectedTextStyle: TextStyle(
              color: Colors.white,
              decorationColor: Color(0xff9FBDF9),
              fontFamily: "Poppins",
              fontSize: 12),
        ),
        daysOfWeekHeight: 40,
        onDaySelected: (selectedDay, focusedDay) => {
          date = DateFormat('d MMMM').format(selectedDay),
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MemoryByDate(allMemories: allMemories, date: date)))
        },
        focusedDay: focusedDays.isNotEmpty ? focusedDays[0] : DateTime.now(),
        firstDay: DateTime.utc(DateTime.now().year, 1, 1),
        lastDay: DateTime.utc(DateTime.now().year, 12, 31),
        selectedDayPredicate: (day) {
          for (int i = 0; i < focusedDays.length; i++) {
            if (day.year == focusedDays[i].year &&
                day.month == focusedDays[i].month &&
                day.day == focusedDays[i].day) {
              return true;
            }
          }
          return false;
        },
      ),
    );
  }
}
