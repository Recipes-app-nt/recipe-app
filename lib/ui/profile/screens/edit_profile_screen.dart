import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/blocs/user/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final String? imageUrl;
  final String? username;
  final String? bio;

  const EditProfileScreen({
    super.key,
    this.imageUrl,
    this.username,
    this.bio,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _profilePicture;

  @override
  void initState() {
    if (widget.username != null) {
      _usernameController.text = widget.username!;
    }
    if (widget.bio != null) {
      _bioController.text = widget.bio!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
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
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final bio = _bioController.text;

      final prefs = await SharedPreferences.getInstance();

      final userInfo = jsonDecode(prefs
          .getString("userData")!); // Replace with actual user ID from your app

      // Dispatch the EditUserEvent
      context.read<UserBloc>().add(EditUserEvent(
            email: userInfo['email'],
            username: username,
            bio: bio,
            profilePicture: _profilePicture,
          ));

      await Fluttertoast.showToast(
          msg: "Updated profile",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
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
                        : widget.imageUrl != null
                            ? NetworkImage(widget.imageUrl!) as ImageProvider
                            : null,
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Enter your username";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
