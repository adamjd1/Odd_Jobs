//Name: Adam Dowling
//Student ID: C00298483
//Date: 20/10/2026

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register.dart';
import 'home_dashboard.dart';

class LoginScreen extends StatefulWidget 
{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> 
{
  final _emailController = TextEditingController(); //text for input
  final _passwordController = TextEditingController();
  final _authService = AuthService(); //for supabase
  bool _isLoading = false;
  final Color bgColour = const Color(0xFFF7F8F6);
  final Color primaryGreen = const Color(0xFF1E5631);
  final Color buttonOrange = const Color(0xFFBC4A2D);
  final Color cardGreen = const Color(0xFFE8F0E9);

  Future<void> _signIn() async 
  {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')), //if submitted empty
      );
      return;
    }

    setState(() => _isLoading = true); //spin

    try {
      await _authService.login //wait for auth to confirm inputs are valid
      (
        email: _emailController.text.trim(), //remove spaces
        password: _passwordController.text,
      );
      
      if (mounted) 
      {
        Navigator.pushReplacement( //nav for home
          context, 
          MaterialPageRoute(builder: (context) => const HomeDashboard())
        );
      }
    } catch (error) 
    {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar( //testing error msg
          SnackBar(
            content: Text(error.toString().replaceAll('Exception: ', '')), 
            backgroundColor: Colors.red
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false); //force stop spin
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColour,
      appBar: AppBar(
        backgroundColor: bgColour,
        elevation: 0,
        title: const Text(
          'oddjobs',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {},
              child: Text('Need help?', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headers
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good to see you again.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryGreen)),
                    const SizedBox(height: 8),
                    const Text('A helping hand is just around the corner.', style: TextStyle(fontSize: 16, color: Colors.black54)),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              Padding( //login
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Log in to your community', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen)),
                      const SizedBox(height: 24),
                      
                      const Text('Email address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'adam.dowling@example.com',
                          filled: true,
                          fillColor: const Color(0xFFFAFAFA),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          filled: true,
                          fillColor: const Color(0xFFFAFAFA),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        ),
                        obscureText: true, //for password security
                      ),
                      
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot password?', style: TextStyle(color: primaryGreen, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(height: 8),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signIn, //stop double clicks
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Log in', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: () { //go register
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                          },
                          child: Text.rich(
                            TextSpan(
                              text: "New here? ",
                              style: const TextStyle(color: Colors.black54),
                              children: [
                                TextSpan(text: 'Register for OddJobs', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                              ]
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Full-width Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                color: cardGreen,
                child: Column(
                  children: [
                    Text('Good neighbours. Great skills.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryGreen)),
                    const SizedBox(height: 12),
                    const Text('Earn virtual credits when you help. Spend them when you need a hand. No cash changes hands.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, height: 1.4)),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Text('By logging in, you agree to our community guidelines and privacy policy.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black45)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}