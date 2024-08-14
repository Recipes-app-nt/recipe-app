import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/blocs/user/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _favoriteDishesController = TextEditingController();
  File? _profilePicture;

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    _favoriteDishesController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() async {
    final username = _usernameController.text;
    final bio = _bioController.text;

    final prefs = await SharedPreferences.getInstance();

    final userInfo = jsonDecode( prefs.getString("userInfo")!); // Replace with actual user ID from your app

    // Dispatch the EditUserEvent
    context.read<UserBloc>().add(EditUserEvent(
      userId: userInfo['id'],
      username: username,
      bio: bio,
      profilePicture: _profilePicture,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon:const  Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickProfilePicture,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePicture != null
                      ? FileImage(_profilePicture!)
                      : const NetworkImage('https://example.com/default-profile-picture.png') as ImageProvider,
                  child: const Icon(Icons.camera_alt),
                ),
              ),
             const  SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _bioController,
                decoration:const  InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
             const  SizedBox(height: 20),
              TextField(
                controller: _favoriteDishesController,
                decoration: const InputDecoration(
                  labelText: 'Favorite Dishes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
