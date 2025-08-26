import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/property.dart';

class PropertyDetailScreen extends StatelessWidget {
  final Property property;
  const PropertyDetailScreen({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(property.category)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            property.imagePath.isNotEmpty
                ? Image.file(
                    File(property.imagePath),
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 240,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 80),
                  ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.category,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(property.description),
                  const SizedBox(height: 12),
                  Text('Address: ${property.address}'),
                  const SizedBox(height: 6),
                  Text('City: ${property.city}'),
                  const SizedBox(height: 6),
                  Text('Pin Code: ${property.pinCode}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
