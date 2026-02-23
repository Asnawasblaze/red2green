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
      maxWidth: 1080,
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
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Uploading your report...'),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 5),
        ),
      );
      
      final position = await _locationService.getCurrentPosition();
      if (position == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to get location. Please enable location services.'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }
      
      setState(() => _isUploadingImage = true);
      final imageUrl = await _cloudinaryService.uploadImage(_imageFile!);
      setState(() => _isUploadingImage = false);
      
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to upload image. Please try again.'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        setState(() => _isLoading = false);
        return;
      }
      
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
          SnackBar(
            content: const Text('Issue reported successfully! 🎉'),
            backgroundColor: const Color(0xFF059669),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = _isLoading || _isUploadingImage;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Column(
        children: [
          // Emerald Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF059669), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Report Issue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: isDisabled ? null : _submitReport,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isDisabled
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                            ),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              color: Color(0xFF059669),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          
          // Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Picker
                    GestureDetector(
                      onTap: isDisabled ? null : _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(_imageFile!, fit: BoxFit.cover),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD1FAE5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(Icons.camera_alt_outlined, size: 28, color: Color(0xFF059669)),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Tap to take photo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Photo will be compressed automatically',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Category
                    _buildLabel('Category'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: IssueCategory.values.map((category) {
                        final isSelected = _selectedCategory == category;
                        return GestureDetector(
                          onTap: isDisabled
                              ? null
                              : () => setState(() => _selectedCategory = category),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFD1FAE5) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF059669) : const Color(0xFFE5E7EB),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Text(
                              _getCategoryName(category),
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF059669) : const Color(0xFF6B7280),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    
                    // Severity
                    _buildLabel('Severity'),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: ['Low', 'Medium', 'High'].map((level) {
                          final isSelected = _severity == level;
                          final color = level == 'Low'
                              ? const Color(0xFF059669)
                              : level == 'Medium'
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFFEF4444);
                          return Expanded(
                            child: GestureDetector(
                              onTap: isDisabled
                                  ? null
                                  : () => setState(() => _severity = level),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: isSelected
                                      ? [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    level,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? color : const Color(0xFF6B7280),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Title
                    _buildLabel('Title'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      enabled: !isDisabled,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Garbage dump near park entrance',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16, right: 12),
                          child: Icon(Icons.title, color: Color(0xFF9CA3AF), size: 20),
                        ),
                        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter a title' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    // Description
                    _buildLabel('Description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      enabled: !isDisabled,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Describe the issue in detail...',
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    // Anonymous Toggle
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _isAnonymous ? const Color(0xFFD1FAE5) : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.visibility_off_outlined,
                              color: _isAnonymous ? const Color(0xFF059669) : const Color(0xFF9CA3AF),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Report Anonymously',
                                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF111827)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Hide your identity from the report',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _isAnonymous,
                            onChanged: isDisabled ? null : (value) => setState(() => _isAnonymous = value),
                            activeColor: const Color(0xFF059669),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
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