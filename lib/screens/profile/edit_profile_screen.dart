import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../providers/user_provider.dart';
import '../../utils/app_theme.dart';
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
    // Lifestyle
    'Travel', 'Music', 'Movies', 'Sports', 'Reading', 'Cooking',
    'Photography', 'Gaming', 'Fitness', 'Art', 'Dancing', 'Yoga',
    
    // Hobbies
    'Hiking', 'Swimming', 'Cycling', 'Running', 'Gym', 'Meditation',
    'Painting', 'Writing', 'Singing', 'Guitar', 'Piano', 'Drawing',
    
    // Food & Drinks
    'Coffee', 'Wine', 'Beer', 'Cocktails', 'Vegetarian', 'Vegan',
    'Foodie', 'Baking', 'BBQ', 'Sushi', 'Pizza', 'Street Food',
    
    // Entertainment
    'Netflix', 'Comedy', 'Horror Movies', 'Action Movies', 'Romance',
    'Documentaries', 'Podcasts', 'Live Music', 'Concerts', 'Theater',
    
    // Outdoor Activities
    'Beach', 'Mountains', 'Camping', 'Fishing', 'Surfing', 'Skiing',
    'Rock Climbing', 'Kayaking', 'Sailing', 'Road Trips', 'Nature',
    
    // Social & Culture
    'Parties', 'Nightlife', 'Museums', 'Art Galleries', 'Fashion',
    'Shopping', 'Volunteering', 'Charity', 'Politics', 'Philosophy',
    
    // Technology & Learning
    'Technology', 'Coding', 'Startups', 'Investing', 'Crypto',
    'Learning Languages', 'History', 'Science', 'Astronomy', 'Books',
    
    // Pets & Animals
    'Dogs', 'Cats', 'Pets', 'Animal Lover', 'Wildlife', 'Horses',
    
    // Wellness & Spirituality
    'Mindfulness', 'Spirituality', 'Self-improvement', 'Therapy',
    'Mental Health', 'Wellness', 'Astrology', 'Tarot'
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
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                  tooltip: 'Get current location',
                ),
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
              const SizedBox(height: 8),
              Text(
                'Select up to 10 interests that represent you',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableInterests.map((interest) {
                      final isSelected = _selectedInterests.contains(interest);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedInterests.remove(interest);
                            } else if (_selectedInterests.length < 10) {
                              _selectedInterests.add(interest);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('You can select maximum 10 interests'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: isSelected 
                                ? AppTheme.primaryGradient
                                : null,
                            color: isSelected 
                                ? null 
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: isSelected 
                                  ? Colors.transparent 
                                  : Colors.grey[300]!,
                              width: 1,
                            ),
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ] : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected)
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              if (isSelected) const SizedBox(width: 6),
                              Text(
                                interest,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_selectedInterests.length}/10 selected',
                style: TextStyle(
                  fontSize: 12,
                  color: _selectedInterests.length >= 10 ? Colors.red : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
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
              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: userState.isLoading ? null : _saveProfile,
                  icon: userState.isLoading 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.favorite, color: Colors.white),
                  label: Text(
                    userState.isLoading ? 'Saving...' : 'Save Changes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey[400]!, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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

  Future<void> _getCurrentLocation() async {
    try {
      // Check permissions
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final newPermission = await Geolocator.requestPermission();
        if (newPermission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permission denied'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission permanently denied. Please enable in settings.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ),
                SizedBox(width: 12),
                Text('Getting your location...'),
              ],
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final address = StringBuffer();
        
        if (place.locality?.isNotEmpty ?? false) {
          address.write(place.locality);
        }
        if (place.administrativeArea?.isNotEmpty ?? false) {
          if (address.length > 0) {
            address.write(', ');
          }
          address.write(place.administrativeArea);
        }
        if (place.country?.isNotEmpty ?? false) {
          if (address.length > 0) {
            address.write(', ');
          }
          address.write(place.country);
        }

        final locationString = address.toString();

        setState(() {
          _locationController.text = locationString;
        });

        // Update backend with coordinates
        try {
          await ref.read(userProvider.notifier).updateLocation(
            position.latitude,
            position.longitude,
            locationName: locationString,
          );
        } catch (e) {
          // Location text is set, backend update failed but that's ok
        }

        if (mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location updated: $locationString'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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