import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/user_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/forms/custom_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;
  
  List<String> _selectedInterests = [];
  String? _selectedIntent;
  
  final List<String> _availableInterests = [
    'Travel', 'Music', 'Movies', 'Sports', 'Reading', 'Cooking',
    'Photography', 'Gaming', 'Fitness', 'Art', 'Dancing', 'Yoga'
  ];
  
  final List<String> _relationshipIntents = [
    'Long-term relationship',
    'Short-term relationship',
    'Friendship',
    'Casual dating',
    'Not sure yet'
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _ageController = TextEditingController(text: user?.age?.toString() ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _locationController = TextEditingController(text: user?.location ?? '');
    _selectedInterests = user?.interests ?? [];
    _selectedIntent = user?.relationshipIntent;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (userState.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Info Section
              _buildSectionTitle('Basic Information'),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _nameController,
                label: 'Name',
                prefixIcon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _ageController,
                label: 'Age',
                prefixIcon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 18 || age > 100) {
                    return 'Please enter a valid age (18-100)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _locationController,
                label: 'Location',
                prefixIcon: Icons.location_on,
              ),
              const SizedBox(height: 24),
              
              // Bio Section
              _buildSectionTitle('About You'),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _bioController,
                label: 'Bio',
                prefixIcon: Icons.edit,
                maxLines: 4,
                maxLength: 500,
                validator: (value) {
                  if (value != null && value.length > 500) {
                    return 'Bio must be less than 500 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Interests Section
              _buildSectionTitle('Interests'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableInterests.map((interest) {
                  final isSelected = _selectedInterests.contains(interest);
                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
                    selectedColor: AppTheme.primaryColor.withOpacity(0.3),
                    checkmarkColor: AppTheme.primaryColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              
              // Relationship Intent Section
              _buildSectionTitle('Looking For'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIntent,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.favorite, color: AppTheme.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                hint: const Text('Select your relationship goal'),
                items: _relationshipIntents.map((intent) {
                  return DropdownMenuItem(
                    value: intent,
                    child: Text(intent),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedIntent = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              
              // Save Button
              CustomButton(
                text: 'Save Changes',
                onPressed: userState.isLoading ? null : _saveProfile,
                gradient: AppTheme.primaryGradient,
                icon: Icons.save,
              ),
              const SizedBox(height: 16),
              
              // Cancel Button
              CustomButton(
                text: 'Cancel',
                onPressed: () => context.pop(),
                backgroundColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(userProvider.notifier).updateProfile(
        name: _nameController.text,
        age: int.tryParse(_ageController.text),
        bio: _bioController.text.isEmpty ? null : _bioController.text,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        interests: _selectedInterests,
        relationshipIntent: _selectedIntent,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}