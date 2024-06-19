import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import '../../Components/HomePageNavbar.dart';
import "../../Components/BottomNavigationBar.dart";
import "../../pages/main/home/MemoryList.dart";
import "../../functions/GetMemories.dart";

class HomePage extends StatefulWidget {
  HomePage({super.key}) {}

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String profileUrl = "";
  List<dynamic> results = [];

  @override
  void initState() {
    super.initState();
    setProfilePic();
  }

  Future<String> getProfilePic() async {
    results = await GetMemories.getUserData();

    return results[0];
  }

  setProfilePic() async {
    profileUrl = await getProfilePic();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              HomePageNavbar(
                pageName: "Home",
                profileUrl: profileUrl,
              ),
              SizedBox(
                height: 40,
              ),
              Calender(),
              SizedBox(
                height: 40,
              ),
              MemoryList(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          selectedIndex: 0,
        ),
      ),
    );
  }
}

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  int selectedIndex = 2;
  late DateTime currentDate;
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    startDate = currentDate.subtract(Duration(days: 2));
    endDate = currentDate.add(Duration(days: 28));
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            List.generate(endDate.difference(startDate).inDays + 1, (index) {
          final day = startDate.add(Duration(days: index));
          final dayName = DateFormat('E').format(day);
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              //navigate to new page with memories of that date
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected ? const Color(0xff9FBDF9) : Color(0xff),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
