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



import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase.dart';

class AuthService 
{
  Future<void> login
  (
    {
      required String email,
      required String password,
    }
  ) 
  async 
  {
    try 
    {
      await supabase.auth.signInWithPassword //attempt to find in supabase
      (
        email: email,
        password: password,
      );
    } 
    on AuthException catch (e) 
    {
      throw Exception(e.message);
    }
  }

  Future<void> register
  (
    {
      required String email,
      required String password,
      required String fullName,
      required String dateOfBirth, //role not here
    }
  ) 
  async 
  {
    try 
    {
      final response = await supabase.auth.signUp
      (
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) 
      {
        throw Exception("Failed to create auth user.");
      }
      await supabase.from('profiles').insert //insert to supabase
      (
        {
          'id': user.id,
          'full_name': fullName,
          'email': email,
          'date_of_birth': dateOfBirth,
        }
      );
      
    } on AuthException catch (e) 
    {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString()); //catch rls issue
    }
  }

  Future<void> logout() async 
  {
    await supabase.auth.signOut();
  }
}