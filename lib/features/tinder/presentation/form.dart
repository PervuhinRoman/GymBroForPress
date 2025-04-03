import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/form_service.dart';

class FormScreen extends StatefulWidget {
  final FormService formService;

  const FormScreen({super.key, required this.formService});

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

  Future<void> _loadFormData() async {
    final formData = await widget.formService.loadFormData();
    setState(
      () {
        _nameController.text = formData['name']!;
        _trainTypeController.text = formData['trainType']!;
        _hoursController.text = formData['hours']!;
        _daysController.text = formData['days']!;
        _textInfoController.text = formData['textInfo']!;

        final imagePath = formData['imagePath'];
        if (imagePath!.isNotEmpty) {
          _imageFile = File(imagePath);
        }
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          _imageFile = File(pickedFile.path);
        },);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error while handling image: $e')),
      );
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await widget.formService.saveFormData(
        name: _nameController.text,
        trainType: _trainTypeController.text,
        hours: _hoursController.text,
        days: _daysController.text,
        textInfo: _textInfoController.text,
        imageFile: _imageFile,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
      appBar: AppBar(title: const Text('Form')),
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
                    return 'Пожалуйста, введите имя';
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
                  onPressed: _saveForm,
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
