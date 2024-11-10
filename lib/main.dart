import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fl_chart/fl_chart.dart'; // 그래프를 위한 패키지 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedPageIndex = 0;

  Map<DateTime, Map<String, dynamic>> _dateData = {
    DateTime.utc(2024, 10, 1): {
      'checklist': ['운동하기', '영양제 복용'],
      'nutrition': {'칼로리': 2200, '단백질': 150},
      'goal': '5km 달리기',
    },
    DateTime.utc(2024, 10, 2): {
      'checklist': ['스트레칭', '물 2L 마시기'],
      'nutrition': {'칼로리': 1800, '단백질': 130},
      'goal': '책 30페이지 읽기',
    },
  };

  Map<String, dynamic> _currentData = {};

  @override
  void initState() {
    super.initState();
    _loadDataForSelectedDay(_focusedDay);
  }

  void _loadDataForSelectedDay(DateTime selectedDay) {
    setState(() {
      _currentData = _dateData[selectedDay] ?? {
        'checklist': ['데이터 없음'],
        'nutrition': {'칼로리': 0, '단백질': 0},
        'goal': '목표 없음',
      };
    });
  }

  void _showCalendarDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _loadDataForSelectedDay(selectedDay);
              });
              Navigator.pop(context); // 팝업 닫기
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Life Style'),
        backgroundColor: Color(0xffB81736),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: _showCalendarDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildWeekDates(),
          Expanded(
            child: IndexedStack(
              index: _selectedPageIndex,
              children: [
                ChecklistPage(),
                NutritionPage(),
                StatisticsPage(dateData: _dateData), // 통계 페이지 추가
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: '체크리스트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: '영양제',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildWeekDates() {
    DateTime startOfWeek = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => setState(() {
            _focusedDay = _focusedDay.subtract(Duration(days: 7));
          }),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (index) {
                DateTime date = startOfWeek.add(Duration(days: index));
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = date;
                      _loadDataForSelectedDay(date);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 8.5,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: date == _selectedDay ? Colors.blue.withOpacity(0.3) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${date.month}/${date.day}",
                          style: TextStyle(
                            color: date == _selectedDay ? Colors.blue : Colors.black,
                            fontWeight: date == _selectedDay ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${["월", "화", "수", "목", "금", "토", "일"][date.weekday - 1]}",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () => setState(() {
            _focusedDay = _focusedDay.add(Duration(days: 7));
          }),
        ),
      ],
    );
  }
}

// 할 일 목록 페이지
class ChecklistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("체크리스트 기능 구현"));
  }
}

// 영양소 기록 페이지
class NutritionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("영양소 기능 구현"));
  }
}

// 통계 페이지
class StatisticsPage extends StatelessWidget {
  final Map<DateTime, Map<String, dynamic>> dateData;

  StatisticsPage({required this.dateData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("주 단위 할 일 완료율"),
          SizedBox(height: 200, child: _buildCompletionChart('weekly')),

          Text("월 단위 할 일 완료율"),
          SizedBox(height: 200, child: _buildCompletionChart('monthly')),

          Text("영양소 섭취 통계"),
          SizedBox(height: 200, child: _buildNutrientChart()),

          Text("추천 목표"),
          _buildGoalRecommendation(),
        ],
      ),
    );
  }

  // 완료율 그래프 생성
  Widget _buildCompletionChart(String period) {
    List<PieChartSectionData> sections = [];
    double completed = 0, total = 0;

    dateData.forEach((date, data) {
      if (data['checklist'] != null) {
        total += (data['checklist'] as List).length;
        completed += (data['checklist'] as List).where((task) => task == '완료').length;
      }
    });

    double completionRate = total > 0 ? (completed / total) * 100 : 0;

    sections.add(PieChartSectionData(value: completionRate, color: Colors.blue, title: "$completionRate%"));
    sections.add(PieChartSectionData(value: 100 - completionRate, color: Colors.grey, title: ""));

    return PieChart(PieChartData(sections: sections));
  }

  // 영양소 섭취 그래프 생성
  Widget _buildNutrientChart() {
    return BarChart(BarChartData(
      barGroups: [
        BarChartGroupData(
          x: 1,
          barRods: [BarChartRodData(y: 120, colors: [Colors.blue])], // 예: 섭취량 120g
        ),
        BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(y: 80, colors: [Colors.red])], // 예: 목표 대비 부족한 섭취량
        ),
      ],
    ));
  }

  // 목표 추천 UI
  Widget _buildGoalRecommendation() {
    return FutureBuilder<String>(
      future: _fetchGoalRecommendations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("목표 추천을 가져오는 중 오류 발생");
        } else {
          return Text(snapshot.data ?? "추천 목표를 로드할 수 없습니다.");
        }
      },
    );
  }

  // AI 기반 목표 추천 API 호출 (예시)
  Future<String> _fetchGoalRecommendations() async {
    // AI API 호출을 통해 목표를 추천 받는 코드 작성
    return Future.value("운동 목표: 하루에 5000걸음 걷기");
  }
}
