import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/property.dart';
import '../../providers/auth_provider.dart';

class AddEditPropertyScreen extends StatefulWidget {
  final Property? property;
  const AddEditPropertyScreen({Key? key, this.property}) : super(key: key);

  @override
  State<AddEditPropertyScreen> createState() => _AddEditPropertyScreenState();
}

class _AddEditPropertyScreenState extends State<AddEditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  String _category = "House";
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.property != null) {
      _titleController.text = widget.property!.title;
      _descController.text = widget.property!.description;
      _cityController.text = widget.property!.city;
      _pincodeController.text = widget.property!.pincode;
      _category = widget.property!.category;
      if (widget.property!.imagePath.isNotEmpty) {
        _imageFile = File(widget.property!.imagePath);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _saveProperty() {
    if (_formKey.currentState!.validate()) {
      final property = Property(
        title: _titleController.text,
        description: _descController.text,
        category: _category,
        city: _cityController.text,
        pincode: _pincodeController.text,
        imagePath: _imageFile?.path ?? '',
      );

      Provider.of<AuthProvider>(context, listen: false).saveProperty(property);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Property saved successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.property == null ? "Add Property" : "Edit Property"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Please enter a title"
                    : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) => (value == null || value.isEmpty)
                    ? "Please enter a description"
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: _category,
                items: const [
                  DropdownMenuItem(value: "House", child: Text("House")),
                  DropdownMenuItem(value: "Land", child: Text("Land")),
                  DropdownMenuItem(
                    value: "Apartment",
                    child: Text("Apartment"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _category = value ?? "House";
                  });
                },
                decoration: const InputDecoration(labelText: "Category"),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "City"),
              ),
              TextFormField(
                controller: _pincodeController,
                decoration: const InputDecoration(labelText: "Pin Code"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : const Text("No image selected"),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text("Pick Image"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProperty,
                child: const Text("Save Property"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
