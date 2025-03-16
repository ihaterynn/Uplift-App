import 'package:flutter/material.dart';
import 'dart:io';
import '../widgets/uplift_app_bar.dart';
import '../widgets/uplift_bottom_nav.dart';
import '../models/user.dart';
import '../services/supabase_service.dart';
import '../services/database_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  final DatabaseService _databaseService = DatabaseService();
  final bool _devMode = true; // For development purposes
  
  User? _user;
  bool _isLoading = true;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers for edit mode
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillController = TextEditingController();
  List<String> _selectedSkills = [];
  
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _jobTitleController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _skillController.dispose();
    super.dispose();
  }
  
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_devMode) {
        // Load a mock user for development
        await Future.delayed(const Duration(milliseconds: 500));
        _user = User(
          id: 'mock-user-id',
          email: 'user@example.com',
          fullName: 'John Doe',
          skills: ['Flutter', 'Dart', 'Firebase', 'UI/UX', 'Python'],
          yearsOfExperience: 3,
          bio: 'Passionate mobile developer with a focus on creating beautiful and functional apps that solve real-world problems.',
          location: 'San Francisco, CA',
          jobTitle: 'Mobile Developer',
          profilePicture: null,
          resumeUrl: null,
          interests: ['Technology', 'Design', 'AI', 'Machine Learning'],
          lastActive: DateTime.now(),
          isAvailableForHire: true,
        );
      } else {
        // Get the current user ID
        final userId = _supabaseService.currentUserId;
        if (userId == null) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
        
        // Fetch user profile from database
        _user = await _databaseService.getUserById(userId);
      }
      
      // Set up controllers with loaded data
      if (_user != null) {
        _nameController.text = _user!.fullName;
        _emailController.text = _user!.email;
        _locationController.text = _user!.location ?? '';
        _jobTitleController.text = _user!.jobTitle ?? '';
        _bioController.text = _user!.bio ?? '';
        _experienceController.text = _user!.yearsOfExperience.toString();
        _selectedSkills = List<String>.from(_user!.skills);
      }
    } catch (e) {
      print('Error loading user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Update user data
        final updatedUser = User(
          id: _user!.id,
          email: _emailController.text,
          fullName: _nameController.text,
          skills: _selectedSkills,
          yearsOfExperience: int.tryParse(_experienceController.text) ?? 0,
          bio: _bioController.text,
          location: _locationController.text,
          jobTitle: _jobTitleController.text,
          profilePicture: _user!.profilePicture,
          resumeUrl: _user!.resumeUrl,
          interests: _user!.interests,
          lastActive: DateTime.now(),
          isAvailableForHire: _user!.isAvailableForHire,
        );
        
        if (_devMode) {
          // Simulate database update
          await Future.delayed(const Duration(milliseconds: 500));
          _user = updatedUser;
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        } else {
          // Update in database
          final result = await _databaseService.upsertUser(updatedUser);
          if (result != null) {
            _user = result;
            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update profile')),
            );
          }
        }
      } catch (e) {
        print('Error updating user profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isEditing = false;
          });
        }
      }
    }
  }
  
  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
        _skillController.clear();
      });
    }
  }
  
  void _removeSkill(String skill) {
    setState(() {
      _selectedSkills.remove(skill);
    });
  }
  
  Future<void> _uploadResume() async {
    // This would be implemented with file picker and Supabase storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resume upload coming soon!')),
    );
  }
  
  Future<void> _uploadProfilePicture() async {
    // This would be implemented with image picker and Supabase storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile picture upload coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UpliftAppBar(
        showLogo: false,
        showBackButton: true,
        additionalActions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading 
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
              ),
            )
          : (_user == null 
              ? _buildSignInPrompt() 
              : _isEditing
                  ? _buildEditProfile()
                  : _buildViewProfile()),
      bottomNavigationBar: UpliftBottomNav(
        currentIndex: 0, // No tab selected
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/discover');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/post');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/messages');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/applications');
          }
        },
      ),
    );
  }
  
  Widget _buildSignInPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              "Sign In Required",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Please sign in to view and manage your profile",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Sign In / Sign Up",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildViewProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header with Picture
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _user!.profilePicture != null 
                          ? NetworkImage(_user!.profilePicture!) 
                          : null,
                      child: _user!.profilePicture == null
                          ? Text(
                              _user!.fullName.isNotEmpty ? _user!.fullName[0].toUpperCase() : '?',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4ECDC4),
                              ),
                            )
                          : null,
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: const Color(0xFF4ECDC4),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: _uploadProfilePicture,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _user!.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user!.jobTitle ?? 'Add your job title',
                  style: TextStyle(
                    fontSize: 16,
                    color: _user!.jobTitle != null ? Colors.grey[800] : Colors.grey[400],
                    fontStyle: _user!.jobTitle != null ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                if (_user!.location != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        _user!.location!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                // Edit Profile Button
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Resume Section
          _buildSectionHeader("Resume"),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF4ECDC4).withOpacity(0.1),
                child: const Icon(Icons.description, color: Color(0xFF4ECDC4)),
              ),
              title: Text(
                _user!.resumeUrl != null ? 'My Resume.pdf' : 'No resume uploaded',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: _user!.resumeUrl != null ? Colors.black : Colors.grey[500],
                ),
              ),
              subtitle: _user!.resumeUrl != null
                  ? const Text('Last updated: 2 weeks ago')
                  : const Text('Upload your resume to apply for jobs faster'),
              trailing: TextButton.icon(
                icon: const Icon(Icons.upload_file, size: 16),
                label: Text(_user!.resumeUrl != null ? 'Update' : 'Upload'),
                onPressed: _uploadResume,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // About Section
          _buildSectionHeader("About"),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user!.bio ?? 'Add a bio to tell others about yourself and your expertise.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: _user!.bio != null ? Colors.black87 : Colors.grey[500],
                      fontStyle: _user!.bio != null ? FontStyle.normal : FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Skills Section
          _buildSectionHeader("Skills"),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _user!.skills.isNotEmpty
                    ? _user!.skills.map((skill) => Chip(
                        label: Text(skill),
                        backgroundColor: const Color(0xFF4ECDC4).withOpacity(0.1),
                        labelStyle: const TextStyle(
                          color: Color(0xFF4ECDC4),
                        ),
                      )).toList()
                    : [
                        Text(
                          'Add skills to showcase your expertise',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Experience Section
          _buildSectionHeader("Experience"),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.work_outline, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        "${_user!.yearsOfExperience} years of experience",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add your work experience to showcase your professional journey",
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text("Add Experience"),
                    onPressed: () {
                      // Will be implemented in a future feature
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Work experience feature coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Account Settings Section
          _buildSectionHeader("Account Settings"),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.email_outlined, color: Colors.grey[600]),
                  title: const Text("Email"),
                  subtitle: Text(_user!.email),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to email settings
                  },
                ),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.grey[600]),
                  title: const Text("Password"),
                  subtitle: const Text("Change your password"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to password settings
                  },
                ),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(
                  leading: Icon(Icons.notifications_outlined, color: Colors.grey[600]),
                  title: const Text("Notifications"),
                  subtitle: const Text("Manage notification preferences"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to notification settings
                  },
                ),
                Divider(height: 1, color: Colors.grey[200]),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: Colors.grey[600]),
                  title: const Text("Privacy"),
                  subtitle: const Text("Manage privacy settings"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Sign Out Button
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.logout, size: 16),
              label: const Text("Sign Out"),
              onPressed: () {
                // Sign out functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign out feature coming soon!')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[400],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
  
  Widget _buildEditProfile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _user!.profilePicture != null 
                        ? NetworkImage(_user!.profilePicture!) 
                        : null,
                    child: _user!.profilePicture == null
                        ? Text(
                            _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : '?',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4ECDC4),
                            ),
                          )
                        : null,
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF4ECDC4),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      onPressed: _uploadProfilePicture,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Personal Information
            _buildSectionHeader("Personal Information"),
            const SizedBox(height: 16),
            
            // Full Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                hintText: "Enter your full name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Email
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              enabled: false, // Email can't be changed
            ),
            const SizedBox(height: 16),
            
            // Job Title
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(
                labelText: "Job Title",
                hintText: "Enter your job title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.work_outline),
              ),
            ),
            const SizedBox(height: 16),
            
            // Location
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: "Location",
                hintText: "Enter your location",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 16),
            
            // Bio
            TextFormField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: "Bio",
                hintText: "Tell us about yourself",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 24),
            
            // Professional Information
            _buildSectionHeader("Professional Information"),
            const SizedBox(height: 16),
            
            // Years of Experience
            TextFormField(
              controller: _experienceController,
              decoration: InputDecoration(
                labelText: "Years of Experience",
                hintText: "Enter your years of experience",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.timeline),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your years of experience';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Skills
            Text(
              "Skills",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedSkills.map((skill) => Chip(
                label: Text(skill),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => _removeSkill(skill),
                backgroundColor: const Color(0xFF4ECDC4).withOpacity(0.1),
                labelStyle: const TextStyle(
                  color: Color(0xFF4ECDC4),
                ),
              )).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _skillController,
                    decoration: InputDecoration(
                      hintText: "Add a skill",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.add),
                    ),
                    onFieldSubmitted: (value) {
                      _addSkill(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _addSkill(_skillController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4ECDC4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Resume
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.upload_file),
                    label: const Text("Upload Resume"),
                    onPressed: _uploadResume,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Save Button
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updateUserProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text("Save Changes"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}