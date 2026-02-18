import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/auth_provider.dart';
import '../../providers/issue_provider.dart';
import '../../services/location_service.dart';
import '../../services/cloudinary_service.dart';
import '../home/home_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;
  IssueCategory _selectedCategory = IssueCategory.garbage;
  String _severity = 'Medium';
  bool _isAnonymous = false;
  bool _isLoading = false;
  bool _isUploadingImage = false;
  final LocationService _locationService = LocationService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080, // Initial compression
      maxHeight: 1080,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      setState(() => _isLoading = true);
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final issueProvider = Provider.of<IssueProvider>(context, listen: false);
      
      // Show uploading message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Compressing and uploading image...'),
            ],
          ),
          duration: Duration(seconds: 5),
        ),
      );
      
      // Get location
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to get location. Please enable location services.')),
        );
        setState(() => _isLoading = false);
        return;
      }
      
      // Upload image to Cloudinary
      setState(() => _isUploadingImage = true);
      final imageUrl = await _cloudinaryService.uploadImage(_imageFile!);
      setState(() => _isUploadingImage = false);
      
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to upload image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
        return;
      }
      
      // Create issue with Cloudinary URL
      final issue = IssueModel(
        reporterId: authProvider.user!.uid,
        reporterName: _isAnonymous ? 'Anonymous' : authProvider.user!.displayName,
        reporterPhotoUrl: _isAnonymous ? null : authProvider.user!.photoUrl,
        location: GeoPoint(position.latitude, position.longitude),
        photoUrl: imageUrl,
        category: _selectedCategory,
        severity: _severity,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: DateTime.now(),
        isAnonymous: _isAnonymous,
      );
      
      final issueId = await issueProvider.createIssue(issue);
      
      setState(() => _isLoading = false);
      
      if (issueId != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue reported successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        actions: [
          TextButton(
            onPressed: (_isLoading || _isUploadingImage) ? null : _submitReport,
            child: (_isLoading || _isUploadingImage)
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Picker
              GestureDetector(
                onTap: (_isLoading || _isUploadingImage) ? null : _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text('Tap to take photo', style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                ),
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Image will be compressed before upload',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600], fontStyle: FontStyle.italic),
                  ),
                ),
              const SizedBox(height: 24),
              
              // Category Selection
              const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: IssueCategory.values.map((category) {
                  return ChoiceChip(
                    label: Text(_getCategoryName(category)),
                    selected: _selectedCategory == category,
                    onSelected: (_isLoading || _isUploadingImage) 
                        ? null 
                        : (selected) {
                            setState(() => _selectedCategory = category);
                          },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              
              // Severity
              const Text('Severity', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Low', label: Text('Low')),
                  ButtonSegment(value: 'Medium', label: Text('Medium')),
                  ButtonSegment(value: 'High', label: Text('High')),
                ],
                selected: {_severity},
                onSelectionChanged: (_isLoading || _isUploadingImage)
                    ? null
                    : (Set<String> newSelection) {
                        setState(() => _severity = newSelection.first);
                      },
              ),
              const SizedBox(height: 16),
              
              // Title
              TextFormField(
                controller: _titleController,
                enabled: !(_isLoading || _isUploadingImage),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                enabled: !(_isLoading || _isUploadingImage),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),
              
              // Anonymous Toggle
              SwitchListTile(
                title: const Text('Report Anonymously'),
                value: _isAnonymous,
                onChanged: (_isLoading || _isUploadingImage)
                    ? null
                    : (value) => setState(() => _isAnonymous = value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryName(IssueCategory category) {
    switch (category) {
      case IssueCategory.garbage: return 'Garbage';
      case IssueCategory.pothole: return 'Pothole';
      case IssueCategory.drainage: return 'Drainage';
      case IssueCategory.brokenProperty: return 'Broken Property';
      case IssueCategory.illegalPosters: return 'Illegal Posters';
      case IssueCategory.strayAnimals: return 'Stray Animals';
      case IssueCategory.treeHazard: return 'Tree Hazard';
      case IssueCategory.waterLeakage: return 'Water Leakage';
    }
  }
}