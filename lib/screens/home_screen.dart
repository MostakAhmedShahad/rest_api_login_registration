import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to LoginScreen
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (photo.isNotEmpty)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(photo),
              ),
            SizedBox(height: 10),
            Text('$firstName $lastName', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(email, style: TextStyle(fontSize: 18, color: Colors.grey)),
            Text('Mobile: $mobile', style: TextStyle(fontSize: 18)),
            Text('Toten: $token', style: TextStyle(fontSize: 18)),

            Text('welcome')
          ],
        ),
      ),
    );
  }
}
