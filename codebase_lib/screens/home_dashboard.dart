//Name: Adam Dowling
//Student ID: C00298483
//Date: 25/10/2026

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

import 'package:flutter/material.dart';
import '../services/supabase.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> 
{
  int _currentIndex = 0;
  String _greeting = 'Hello';
  String _firstName = 'Neighbour';
  bool _isLoading = true;
  List<dynamic> _categories = []; //list of categories from supabase
  bool _isCategoriesLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
    _loadCategories(); 
  }

  Future<void> _loadUserData() async 
  {
    try 
    {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();

      String fullName = data['full_name'] ?? 'Neighbour'; //name or neighbour
      String firstName = fullName.split(' ').first;

      final hour = DateTime.now().hour;
      String greeting = 'Hello';
      if (hour < 12) 
      {
        greeting = 'Morning';
      } else if (hour < 18) 
      {
        greeting = 'Afternoon';
      } else 
      {
        greeting = 'Evening';
      }

      if (mounted) {
        setState(() {
          _firstName = firstName;
          _greeting = greeting;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCategories() async {//tp be loaded when the tab is opened, gotten from supabase
    try {
      final data = await supabase.from('categories').select().order('id');
      if (mounted) {
        setState(() {
          _categories = data;
          _isCategoriesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isCategoriesLoading = false); //error if it can not find or load categories
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody; //what body to display based on the tab selected, default home

    if (_currentIndex == 0) { //home
      currentBody = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_greeting, $_firstName',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E5631),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Let's make your neighbourhood a little brighter.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
          ),
          const Expanded(
            child: Center(child: Text("Home", style: TextStyle(color: Colors.grey))),
          ),
        ],
      );
    } else if (_currentIndex == 1) {

      if (_isCategoriesLoading) {//search
        currentBody = const Center(child: CircularProgressIndicator());
      } else {
        currentBody = SingleChildScrollView( //search
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0), //loading spin
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Text
              const Text(
                'What do you need a hand with?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E5631)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find good people with just the right skills.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey), //create seachbar
                    SizedBox(width: 12),
                    Text('Try gardening or maths tutoring', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ..._categories.map((category) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    category['name'], //retrieves the name of category
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }
    } else {
      const List<String> titles = ["", "", "Post", "Wallet", "Profile"]; //unfinished tabs w no start
      currentBody = Center(child: Text("${titles[_currentIndex]} ", style: const TextStyle(color: Colors.grey)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F0E9),
        elevation: 0,
        title: const Text(
          'oddjobs',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -1, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                '1240 VC', //template wallet balance
                style: const TextStyle(color: Color(0xFF1E5631), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          )
        ],
      ),
      body: currentBody,
      bottomNavigationBar: BottomNavigationBar
      (
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() 
          {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E5631),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}