// lib/goal.dart

import 'package:flutter/material.dart';

class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final List<Goal> _goals = [ //나중에 데이터베이스에서 데이터 가져오기
    Goal(title: '체중 감량', description: '1개월에 2kg 감량하기'),
    Goal(title: '매일 운동하기', description: '주 5일 이상 운동하기'),
  ];

  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isAddGoalOpen = false;

  void _addGoal() {
    if (_goalController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      setState(() {
        _goals.add(Goal(
          title: _goalController.text,
          description: _descriptionController.text,
        ));
        _goalController.clear();
        _descriptionController.clear();
        _isAddGoalOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('목표'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _goals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_goals[index].title),
                  subtitle: Text(_goals[index].description),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isAddGoalOpen = true;
              });
            },
            child: Text("목표 추가"),
          ),
          if (_isAddGoalOpen) _buildAddGoalDialog(),
        ],
      ),
    );
  }

  Widget _buildAddGoalDialog() {
    return AlertDialog(
      title: Text("새 목표 추가"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _goalController,
            decoration: InputDecoration(labelText: "목표 제목 입력"),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "목표 설명 입력"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _addGoal();
            Navigator.of(context).pop();
          },
          child: Text("추가"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("취소"),
        ),
      ],
    );
  }
}

class Goal {
  String title;
  String description;

  Goal({required this.title, required this.description});
}
