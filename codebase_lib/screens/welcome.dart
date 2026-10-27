//Name: Adam Dowling
//Student ID: C00298483
//Date: 17/10/2026

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.






import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

class WelcomeScreen extends StatelessWidget 
{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Figma Colours
    final Color bgColour = const Color(0xFFF7F8F6);
    final Color primaryGreen = const Color(0xFF1E5631);
    final Color buttonOrange = const Color(0xFFBC4A2D);
    final Color cardGreen = const Color(0xFFE8F0E9);

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
        child: SingleChildScrollView
        (
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Big skills. Little jobs.', //header
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryGreen),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A neighbourhood built on helping hands.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity, //for img
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Made for your neighbourhood',
                          style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TIME IS OUR CURRENCY',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Help a neighbour. Earn VC.\nGet a hand when you need one.',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: primaryGreen, height: 1.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                    ]
                  ),
                  child: Column(
                    children: [
                      _buildFeatureRow(cardGreen, 'Share your skills', 'From a tidy garden to tech advice.'),
                      const SizedBox(height: 16),
                      _buildFeatureRow(cardGreen, 'Earn virtual credits', 'Get paid in VC, not real money.'),
                      const SizedBox(height: 16),
                      _buildFeatureRow(cardGreen, 'Keep good going', 'Spend VC on help from neighbours.'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () { //nav register
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Join your neighbourhood', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () { //nav login
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryGreen,
                      side: BorderSide(color: primaryGreen.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('I already have an account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'No cash. No pressure. Just community.',
                    style: TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildFeatureRow(Color iconBg, String title, String subtitle) 
  {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }
}