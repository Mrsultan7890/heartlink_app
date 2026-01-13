import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

class FiltersScreen extends ConsumerStatefulWidget {
  const FiltersScreen({super.key});

  @override
  ConsumerState<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends ConsumerState<FiltersScreen> {
  final List<String> availableInterests = [
    "Coding", "Gaming", "Anime", "Movies", "Music", "Travel", "Fitness", 
    "Reading", "Photography", "Cooking", "Dancing", "Sports", "Art", 
    "Technology", "Fashion", "Nature", "Pets", "Yoga", "Meditation",
    "Business", "Startups", "Investment", "Cryptocurrency", "AI/ML"
  ];

  final List<String> relationshipIntents = ["serious", "casual", "friends"];

  RangeValues ageRange = const RangeValues(18, 35);
  double maxDistance = 10.0;
  String? selectedIntent;
  List<String> selectedInterests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAgeFilter(),
            const SizedBox(height: 24),
            _buildDistanceFilter(),
            const SizedBox(height: 24),
            _buildRelationshipIntentFilter(),
            const SizedBox(height: 24),
            _buildInterestsFilter(),
            const SizedBox(height: 32),
            _buildApplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Age Range',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${ageRange.start.round()} - ${ageRange.end.round()} years',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            RangeSlider(
              values: ageRange,
              min: 18,
              max: 60,
              divisions: 42,
              onChanged: (values) {
                setState(() {
                  ageRange = values;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Maximum Distance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${maxDistance.round()} km',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: maxDistance,
              min: 1,
              max: 100,
              divisions: 99,
              onChanged: (value) {
                setState(() {
                  maxDistance = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipIntentFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Looking For',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: relationshipIntents.map((intent) {
                final isSelected = selectedIntent == intent;
                return FilterChip(
                  label: Text(intent.toUpperCase()),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedIntent = selected ? intent : null;
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interests',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Select interests you want to match with',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: availableInterests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedInterests.add(interest);
                      } else {
                        selectedInterests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _applyFilters,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text('Apply Filters'),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      ageRange = const RangeValues(18, 35);
      maxDistance = 10.0;
      selectedIntent = null;
      selectedInterests.clear();
    });
  }

  void _applyFilters() {
    // Apply filters and go back
    Navigator.pop(context, {
      'min_age': ageRange.start.round(),
      'max_age': ageRange.end.round(),
      'max_distance_km': maxDistance,
      'relationship_intent': selectedIntent,
      'required_interests': selectedInterests.isNotEmpty ? selectedInterests.join(',') : null,
    });
  }
}

class InterestsSelectionScreen extends ConsumerStatefulWidget {
  const InterestsSelectionScreen({super.key});

  @override
  ConsumerState<InterestsSelectionScreen> createState() => _InterestsSelectionScreenState();
}

class _InterestsSelectionScreenState extends ConsumerState<InterestsSelectionScreen> {
  final List<String> availableInterests = [
    "Coding", "Gaming", "Anime", "Movies", "Music", "Travel", "Fitness", 
    "Reading", "Photography", "Cooking", "Dancing", "Sports", "Art", 
    "Technology", "Fashion", "Nature", "Pets", "Yoga", "Meditation",
    "Business", "Startups", "Investment", "Cryptocurrency", "AI/ML"
  ];

  List<String> selectedInterests = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentInterests();
  }

  void _loadCurrentInterests() {
    final user = ref.read(userProvider);
    if (user != null && user.interests.isNotEmpty) {
      setState(() {
        selectedInterests = List.from(user.interests);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Interests'),
        actions: [
          TextButton(
            onPressed: isLoading ? null : _saveInterests,
            child: isLoading 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your interests',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Select interests that represent you. This helps us find better matches.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Selected: ${selectedInterests.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableInterests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedInterests.add(interest);
                      } else {
                        selectedInterests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveInterests() async {
    setState(() {
      isLoading = true;
    });

    try {
      final request = InterestsUpdateRequest(interests: selectedInterests);
      await ApiService.instance.updateInterests(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Interests updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update interests: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class RelationshipIntentScreen extends ConsumerStatefulWidget {
  const RelationshipIntentScreen({super.key});

  @override
  ConsumerState<RelationshipIntentScreen> createState() => _RelationshipIntentScreenState();
}

class _RelationshipIntentScreenState extends ConsumerState<RelationshipIntentScreen> {
  final List<Map<String, dynamic>> intents = [
    {
      'value': 'serious',
      'title': 'Serious Relationship',
      'description': 'Looking for long-term commitment',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
    {
      'value': 'casual',
      'title': 'Casual Dating',
      'description': 'Open to see where things go',
      'icon': Icons.coffee,
      'color': Colors.orange,
    },
    {
      'value': 'friends',
      'title': 'Just Friends',
      'description': 'Looking to make new friends',
      'icon': Icons.people,
      'color': Colors.blue,
    },
  ];

  String? selectedIntent;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentIntent();
  }

  void _loadCurrentIntent() {
    final user = ref.read(userProvider);
    if (user != null) {
      setState(() {
        selectedIntent = user.relationshipIntent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relationship Intent'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What are you looking for?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This helps us show you to people with similar intentions.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: intents.length,
                itemBuilder: (context, index) {
                  final intent = intents[index];
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        intent['icon'] as IconData,
                        color: intent['color'] as Color,
                        size: 32,
                      ),
                      title: Text(intent['title'] as String),
                      subtitle: Text(intent['description'] as String),
                      trailing: Radio<String>(
                        value: intent['value'] as String,
                        groupValue: selectedIntent,
                        onChanged: (value) {
                          setState(() {
                            selectedIntent = value;
                          });
                        },
                      ),
                      onTap: () {
                        setState(() {
                          selectedIntent = intent['value'] as String?;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIntent != null && !isLoading ? _saveIntent : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveIntent() async {
    if (selectedIntent == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final request = RelationshipIntentRequest(intent: selectedIntent!);
      await ApiService.instance.updateRelationshipIntent(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relationship intent updated!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update intent: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}