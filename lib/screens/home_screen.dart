import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiUrl = 'https://task.teamrabbil.com/api/v1/createTask';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  String result = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String mobile = '';
  String photo = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? 'Unknown';
      lastName = prefs.getString('lastName') ?? '';
      email = prefs.getString('email') ?? '';
      mobile = prefs.getString('mobile') ?? '';
      photo = prefs.getString('photo') ?? '';
      token = prefs.getString('token') ?? '';
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(
        context, '/login'); // Navigate to LoginScreen
  }
 Future<void> _loadTask() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception("No valid token found. Please log in again.");
    }

    final Map<String, dynamic> requestBody = {
      'title': titleController.text,
      'description': descriptionController.text,
      'status': 'New',  // Ensure valid status
    };

    print("Sending Request: $requestBody");
    print("Sending Request: $requestBody");
     
     print("Sending Request: $requestBody");
     print("Sending Request: $requestBody");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );

    print("Response Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      setState(() {});
      Navigator.pop(context);
    } else {
      throw Exception('Request failed. Status Code: ${response.statusCode}, Response: ${response.body}');
    }
  } catch (e) {
    setState(() {
      result = 'Error: $e';
    });
    print("Error: $e");
  }
}


  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: statusController,
                decoration: InputDecoration(labelText: 'Status  '),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Create'),
              onPressed: () {
                _loadTask();

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $firstName'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (photo.isNotEmpty)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(photo),
              ),
            SizedBox(height: 15),
            Text('$firstName $lastName',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(email, style: TextStyle(fontSize: 20, color: Colors.grey)),
            SizedBox(height: 20),
            Text('Mobile: $mobile', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Create Task'),
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontStyle: FontStyle.normal),
              ),
              onPressed: () {
                _dialogBuilder(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
