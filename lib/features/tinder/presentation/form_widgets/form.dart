import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../controller/form_service.dart';
import 'form_content.dart';

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
  final _contactController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _trainTypeController.dispose();
    _hoursController.dispose();
    _daysController.dispose();
    _textInfoController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    setState(() => _isLoading = true);

    try {
      final formData = await widget.formService.loadFormData();
      if (mounted) {
        setState(() {
          _nameController.text = formData['name']!;
          _trainTypeController.text = formData['trainType']!;
          _hoursController.text = formData['hours']!;
          _daysController.text = formData['days']!;
          _textInfoController.text = formData['textInfo']!;
          _contactController.text = formData['contact']!;

          final imagePath = formData['imagePath'];
          if (imagePath!.isNotEmpty) {
            _imageFile = File(imagePath);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${AppLocalizations.of(context)!.errorLoadingData} $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await widget.formService.saveFormData(
        name: _nameController.text,
        trainType: _trainTypeController.text,
        hours: _hoursController.text,
        days: _daysController.text,
        textInfo: _textInfoController.text,
        imageFile: _imageFile,
        contact: _contactController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.profileSavedSuccessfully),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myProfile),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FormContent(
              formKey: _formKey,
              imageFile: _imageFile,
              onImageChanged: (File? newImage) =>
                  setState(() => _imageFile = newImage),
              nameController: _nameController,
              trainTypeController: _trainTypeController,
              hoursController: _hoursController,
              daysController: _daysController,
              personalInfoController: _textInfoController,
              contactController: _contactController,
              onSave: _saveForm,
              isLoading: _isLoading,
            ),
      //ToDO: сделать красивее
    );
  }
}


