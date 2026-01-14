import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'dart:convert';

import '../../providers/user_provider.dart';
import '../../services/api_service.dart';
import '../../utils/app_theme.dart';

class PhotoUploadScreen extends ConsumerStatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  ConsumerState<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends ConsumerState<PhotoUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(userProvider.notifier).loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final user = userState.user;
    final photos = user?.profileImages ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Photos'),
        actions: [
          if (photos.length < 6)
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: _isUploading ? null : () => _pickImage(),
            ),
        ],
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add up to 6 photos',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your first photo will be your main profile picture',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Photos Grid
                  Text(
                    'Your Photos (${photos.length}/6)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: photos.length + (photos.length < 6 ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < photos.length) {
                        return _buildPhotoCard(photos[index], index);
                      } else {
                        return _buildAddPhotoCard();
                      }
                    },
                  ),

                  if (_isUploading)
                    const SizedBox(height: 24),
                  if (_isUploading)
                    const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Uploading photo...'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildPhotoCard(String photoUrl, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Photo
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: photoUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: const Icon(Icons.error),
              ),
            ),
          ),

          // Main Badge
          if (index == 0)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'MAIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Delete Button
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                onPressed: () => _deletePhoto(index),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoCard() {
    return GestureDetector(
      onTap: _isUploading ? null : () => _pickImage(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate,
              size: 48,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Photo',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _uploadImage(File(image.path));
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isUploading = true);

    try {
      // Read image as bytes and convert to base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Upload to backend (which will store in Telegram @storagecat)
      final response = await ApiService.instance.uploadImage(
        ImageUploadRequest(
          telegramFileId: base64Image, // Backend will handle Telegram upload
        ),
      );

      // Reload profile to get updated photos
      await ref.read(userProvider.notifier).loadProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to upload image: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _deletePhoto(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        await ApiService.instance.deleteImage(index);
        await ref.read(userProvider.notifier).loadProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        _showError('Failed to delete photo: $e');
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}