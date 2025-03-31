import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rest_api_login_registration/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String apiUrl = 'https://task.teamrabbil.com/api/v1/login';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String result = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _postData() async {
    try {
      final Map<String, dynamic> requestBody = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token'];
        print(token); //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDM1Mjc0MTUsImRhdGEiOiJzaGFoYWQ3NEBnbWFpbC5jb20iLCJpYXQiOjE3NDM0NDEwMTV9.CMsy4BUcH9_alklRAwgz37Et5j9MOdF8SiHxewP7cP4
        Map<String, dynamic> userData = responseData['data'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('email', userData['email']);
        await prefs.setString('firstName', userData['firstName']);
        await prefs.setString('lastName', userData['lastName']);
        await prefs.setString('mobile', userData['mobile']);
        await prefs.setString('photo', userData['photo']);

        // Navigate to HomeScreen after login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        throw Exception('Login failed. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Login')), backgroundColor: Colors.purple),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email', hintText: 'Enter your email'),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password', hintText: 'Enter your password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _postData,
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              Text('Forgot your password?', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),
      ),
    );
  }
}
