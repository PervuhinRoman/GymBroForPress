import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _trainTypeController = TextEditingController();
  final _hoursController = TextEditingController();
  final _daysController = TextEditingController();
  final _textInfoController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }
  Future<void> _saveFormData() async {
    if (!_formKey.currentState!.validate()) return;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8080/api/profiles'),
    );

    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ),
      );
    }

    request.fields['time'] = _hoursController.text;
    request.fields['day'] = _daysController.text;
    request.fields['textInfo'] = _textInfoController.text;
    request.fields['trainType'] = _trainTypeController.text;

    try {
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $responseString')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('trainType', _trainTypeController.text);
    await prefs.setString('hours', _hoursController.text);
    await prefs.setString('days', _daysController.text);
    await prefs.setString('textInfo', _textInfoController.text);
    if (_imageFile != null) {
      await prefs.setString('imagePath', _imageFile!.path);
    }
  }

  Future<void> _loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _trainTypeController.text = prefs.getString('trainType') ?? '';
      _hoursController.text = prefs.getString('hours') ?? '';
      _daysController.text = prefs.getString('days') ?? '';
      _textInfoController.text = prefs.getString('textInfo') ?? '';

      final imagePath = prefs.getString('imagePath');
      if (imagePath != null) {
        _imageFile = File(imagePath);
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while handling image: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _trainTypeController.dispose();
    _hoursController.dispose();
    _daysController.dispose();
    _textInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    _imageFile != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(_imageFile!),
                          )
                        : const CircleAvatar(
                            radius: 60,
                            child: Icon(Icons.person, size: 60),
                          ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Change image'),
                      //ToDo: string resources
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Имя';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FormInputField(
                controller: _trainTypeController,
                label: 'Тип тренировки',
              ),
              const SizedBox(height: 16),
              FormInputField(
                controller: _hoursController,
                label: 'Часы',
              ),
              const SizedBox(height: 16),
              FormInputField(
                controller: _daysController,
                label: 'Дни',
              ),
              const SizedBox(height: 16),
              FormInputField(
                controller: _textInfoController,
                label: 'Дополнительная информация',
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _saveFormData();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Data loaded')),
                        );
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FormInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const FormInputField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
