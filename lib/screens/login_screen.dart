import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:rest_api_login_registration/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    print('Sending request to: $apiUrl');
    
    final Map<String, dynamic> requestBody = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    
    print('Request Body: ${jsonEncode(requestBody)}');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Parsed Response Data: $responseData');
      String token = responseData['token'];
      Map<String ,dynamic> UserData=responseData['data'];
      SharedPreferences prefs =await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('email', UserData['email']);
      await prefs.setString('firstName', UserData['firstName']);
      await prefs.setString('lastName', UserData['lastName']);
      await prefs.setString('mobile', UserData['mobile']);
      await prefs.setString('photo', UserData['photo']);

      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
      

       
    } else {
      throw Exception('Failed to post data. Status Code: ${response.statusCode}');
    }
  } catch (e, stacktrace) {
    print('Error: $e');
    print('Stacktrace: $stacktrace');
    setState(() {
      result = 'Error: $e';
    });
  }
}

Future<void> _loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  String? token = prefs.getString('token');
  String? email = prefs.getString('email');
  String? firstName = prefs.getString('firstName');
  String? lastName = prefs.getString('lastName');
  String? mobile = prefs.getString('mobile');

  print('Stored Token: $token');
  print('User Email: $email');
  print('User Name: $firstName $lastName');
}







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _postData,

                

                // Handle login logic here

                child: Text('Login'),
              ),
              SizedBox(height: 10),
              Text(
                'Forgot your password?',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
