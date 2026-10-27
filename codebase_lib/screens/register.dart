//Name: Adam Dowling
//Student ID: C00298483
//Date: 21/10/2026

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

class RegisterScreen extends StatefulWidget 
{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> 
{
  final _nameController = TextEditingController(); //inputs
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dobController = TextEditingController();
  final _authService = AuthService(); //supabase
  
  bool _isLoading = false;
  String _selectedRole = 'Both'; //automatic
  DateTime? _selectedDate; 
  final Color bgColour = const Color(0xFFF7F8F6);
  final Color primaryGreen = const Color(0xFF1E5631);
  final Color buttonOrange = const Color(0xFFBC4A2D);
  final Color cardGreen = const Color(0xFFE8F0E9);

  String _formatDateForDisplay(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${date.day} ${months[date.month - 1]} ${date.year}"; //format for text
  }
  String _formatDateForDb(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"; //formst for supabase
  }
  Future<void> _pickDate() async 
  { //calendar
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = _formatDateForDisplay(picked); 
      });
    }
  }

  Future<void> _signUp() async 
  { //no empty input allowed
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty ||  _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')), //if any input box is empty
      );
      return;
    }

    setState(() => _isLoading = true); //spin

    try {
      await _authService.register(
        email: _emailController.text.trim(), //incase speces
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        dateOfBirth: _formatDateForDb(_selectedDate!), //no role for worker customer or admin yet
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Welcome to OddJobs neighbour, you now have an account, please sign in')),
        );
        Navigator.pop(context); //login page nav
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceAll('Exception: ', '')), //if email already tied to account
            backgroundColor: Colors.red
          ),
        );
      }
    } 
    finally 
      {
        if (mounted) setState(() => _isLoading = false);
      }
  }

  Widget _buildRoleToggle(String title) 
  {
    bool isSelected = _selectedRole == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = title),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? cardGreen : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? primaryGreen : Colors.grey.shade300, 
              width: isSelected ? 1.5 : 1
            ),
          ),
          child: Center(
            child: Text(
              title, 
              style: TextStyle(
                color: isSelected ? primaryGreen : Colors.black87, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
              )
            )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColour,
      appBar: AppBar(
        backgroundColor: bgColour,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'oddjobs', 
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1, color: Colors.black)
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {}, 
              child: Text('Need help?', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold))
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Text Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make yourself at home.', 
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryGreen)
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join a neighbourhood that helps each other.', 
                      style: TextStyle(fontSize: 16, color: Colors.black54)
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0), //reg input 
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(16), 
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Full name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Adam Dowling', 
                          filled: true, 
                          fillColor: const Color(0xFFFAFAFA), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      const Text('Email address', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'adam.dowling@example.com', 
                          filled: true, 
                          fillColor: const Color(0xFFFAFAFA), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)
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
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)
                        ),
                        obscureText: true, //for password secrrity
                      ),
                      const SizedBox(height: 6),
                      const Text('Use at least 12 characters.', style: TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(height: 16),
                      
                      const Text('Date of birth', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          hintText: '26 May 2005', 
                          filled: true, 
                          fillColor: const Color(0xFFFAFAFA), 
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)
                        ),
                        readOnly: true,
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 24),
                      
                      const Text('How will you use OddJobs?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildRoleToggle('Customer'),
                          const SizedBox(width: 8),
                          _buildRoleToggle('Worker'),
                          const SizedBox(width: 8),
                          _buildRoleToggle('Both'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'I agree to the terms, privacy policy and community guidelines.', 
                        style: TextStyle(fontSize: 12, color: Colors.black54)
                      ),
                      const SizedBox(height: 24),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonOrange, 
                            foregroundColor: Colors.white, 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          child: _isLoading 
                              ? const CircularProgressIndicator(color: Colors.white) 
                              : const Text('Create my account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text.rich(
                            TextSpan(
                              text: "Already a neighbour? ", 
                              style: const TextStyle(color: Colors.black54), 
                              children: [ //go to login page
                                TextSpan(text: 'Log in', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold))
                              ]
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),

              // Green Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                color: cardGreen,
                child: Column(
                  children: [
                    Text('Give a little. Get a little.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryGreen)),
                    const SizedBox(height: 12),
                    const Text(
                      'Choose Both to post jobs and offer your own skills. You can change this later in your profile.', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(color: Colors.black87, height: 1.4)
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),

              // White Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                color: Colors.white, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Your details stay safe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text(
                      'Your date of birth and full address are never shown on your public profile.', 
                      textAlign: TextAlign.center, 
                      style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4)
                    ),
                  ],
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