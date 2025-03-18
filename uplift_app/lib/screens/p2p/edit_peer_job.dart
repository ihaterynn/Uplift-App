import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../models/peer_job.dart';
import '../../services/database_service.dart';
import '../../services/media_service.dart';
import '../../services/supabase_service.dart';
import '../../widgets/form_widgets.dart'; // We'll create this for shared form widgets

class EditPeerJob extends StatefulWidget {
  final String? jobId; // Optional for new job creation
  
  const EditPeerJob({Key? key, this.jobId}) : super(key: key);
  
  @override
  State<EditPeerJob> createState() => _EditPeerJobState();
}

class _EditPeerJobState extends State<EditPeerJob> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final _timeframeController = TextEditingController();
  final _skillsController = TextEditingController();
  
  final DatabaseService _databaseService = DatabaseService();
  final MediaService _mediaService = MediaService();
  final SupabaseService _supabaseService = SupabaseService();
  
  bool _isRemote = false;
  String _currency = 'USD';
  String _rateType = 'hourly';
  bool _isLoading = false;
  bool _isEditMode = false;
  List<String> _selectedSkills = [];
  
  // Media handling
  List<File> _imageFiles = [];
  File? _videoFile;
  VideoPlayerController? _videoController;
  List<String> _existingMediaUrls = [];
  String? _existingVideoUrl;
  
  final List<String> _availableCurrencies = ['USD', 'EUR', 'GBP', 'CAD', 'AUD'];
  final List<String> _availableRateTypes = ['hourly', 'fixed', 'per session'];
  final List<String> _availableTimeframes = ['1 hour', '2 hours', 'Half day', 'Full day', 'Custom'];
  
  // Popular skills for auto-suggestion
  final List<String> _suggestedSkills = [
    'Teaching', 'Tutoring', 'Academic Writing', 'Mathematics',
    'Programming', 'Web Development', 'Language', 'Dance',
    'Music', 'Piano', 'Guitar', 'Tennis', 'Basketball',
    'Fitness', 'Yoga', 'Photography', 'Art', 'Design',
    'Cooking', 'Resume Writing', 'Interview Preparation', 'Career Coaching'
  ];

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.jobId != null;
    if (_isEditMode) {
      _loadExistingJob();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _rateController.dispose();
    _timeframeController.dispose();
    _skillsController.dispose();
    _videoController?.dispose();
    super.dispose();
  }
  
  Future<void> _loadExistingJob() async {
    setState(() => _isLoading = true);
    
    try {
      final job = await _databaseService.getPeerJobById(widget.jobId!);
      
      if (job != null) {
        _titleController.text = job.title;
        _descriptionController.text = job.description;
        _locationController.text = job.isRemote ? '' : job.location;
        _rateController.text = job.budget.toString();
        _timeframeController.text = job.timeframe;
        _currency = job.currency;
        _rateType = job.rateType;
        _isRemote = job.isRemote;
        
        setState(() {
          _selectedSkills = List<String>.from(job.skills);
          
          // Store existing media for display
          if (job.mediaUrls != null) {
            _existingMediaUrls = List<String>.from(job.mediaUrls!);
          }
          
          if (job.videoUrl != null) {
            _existingVideoUrl = job.videoUrl;
            _initVideoPlayer(job.videoUrl!);
          }
        });
      }
    } catch (e) {
      print('Error loading job: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading service details')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  void _initVideoPlayer(String url) {
    _videoController = VideoPlayerController.network(url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate() && _validateSkills()) {
      setState(() => _isLoading = true);
      
      try {
        final userId = _supabaseService.currentUserId ?? "dev-user-id";
        
        // Upload images if any
        List<String> mediaUrls = List<String>.from(_existingMediaUrls);
        for (File image in _imageFiles) {
          final url = await _mediaService.uploadImage(image, 'peer-jobs/$userId');
          if (url != null) {
            mediaUrls.add(url);
          }
        }
        
        // Upload video if selected
        String? videoUrl = _existingVideoUrl;
        if (_videoFile != null) {
          videoUrl = await _mediaService.uploadVideo(_videoFile!, 'peer-jobs/$userId');
        }
        
        final peerJob = PeerJob(
          id: _isEditMode ? widget.jobId! : '', 
          title: _titleController.text,
          description: _descriptionController.text,
          userId: userId,
          skills: _selectedSkills,
          location: _isRemote ? 'Remote' : _locationController.text,
          budget: double.parse(_rateController.text),
          currency: _currency,
          timeframe: _timeframeController.text,
          postedDate: DateTime.now(),
          rateType: _rateType,
          isRemote: _isRemote,
          mediaUrls: mediaUrls.isNotEmpty ? mediaUrls : null,
          videoUrl: videoUrl,
        );
        
        var result;
        if (_isEditMode) {
          result = await _databaseService.updatePeerJob(peerJob);
        } else {
          result = await _databaseService.createPeerJob(peerJob);
        }
        
        if (result != null) {
          _showSuccessDialog();
        } else {
          _showErrorDialog('Failed to ${_isEditMode ? 'update' : 'post'} service. Please try again.');
        }
      } catch (e) {
        print('Error creating/updating service: $e');
        _showErrorDialog('Error: ${e.toString()}');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
  
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_isEditMode ? 'Service Updated' : 'Success'),
        content: Text(_isEditMode ? 'Your service has been updated successfully!' : 'Service posted successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.pop(context, true); // Close screen and return success
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _validateSkills() {
    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one skill')),
      );
      return false;
    }
    return true;
  }

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
        _skillsController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() => _selectedSkills.remove(skill));
  }
  
  Future<void> _pickImages() async {
    try {
      final result = await ImagePicker().pickMultiImage();
      if (result.isNotEmpty) {
        setState(() {
          _imageFiles.addAll(result.map((xFile) => File(xFile.path)).toList());
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }
  
  Future<void> _pickVideo() async {
    try {
      final result = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (result != null) {
        // Check file size (limit to 50MB for example)
        final file = File(result.path);
        final fileSize = await file.length();
        if (fileSize > 50 * 1024 * 1024) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video size too large. Maximum allowed is 50MB')),
          );
          return;
        }
        
        setState(() {
          _videoFile = file;
          
          // Initialize video player for preview
          _videoController?.dispose();
          _videoController = VideoPlayerController.file(file)
            ..initialize().then((_) {
              setState(() {});
            });
        });
      }
    } catch (e) {
      print('Error picking video: $e');
    }
  }
  
  void _removeImage(int index) {
    setState(() => _imageFiles.removeAt(index));
  }
  
  void _removeVideo() {
    setState(() {
      _videoFile = null;
      _videoController?.dispose();
      _videoController = null;
    });
  }
  
  void _removeExistingImage(int index) {
    setState(() => _existingMediaUrls.removeAt(index));
  }
  
  void _removeExistingVideo() {
    setState(() {
      _existingVideoUrl = null;
      _videoController?.dispose();
      _videoController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          _isEditMode ? "Edit Service" : "Create Service Listing",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitPost,
            child: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                    ),
                  )
                : Text(
                    _isEditMode ? "Update" : "Post",
                    style: const TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: _isLoading && _isEditMode
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Service Title
                    _buildSectionTitle("Service Title"),
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration(
                        hintText: "E.g., Math Tutoring, Guitar Lessons, Fitness Training...",
                        prefixIcon: Icons.work_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a service title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Media Upload Section
                    _buildSectionTitle("Media (Images/Video)"),
                    Text(
                      "Add photos or a video showcasing your skills",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Existing media preview
                    if (_existingMediaUrls.isNotEmpty)
                      _buildExistingImagesSection(),
                    
                    // New image preview
                    if (_imageFiles.isNotEmpty)
                      _buildNewImagesSection(),
                      
                    // Video preview
                    if (_existingVideoUrl != null || _videoFile != null)
                      _buildVideoPreviewSection(),
                    
                    // Upload buttons
                    _buildMediaUploadButtons(),
                    const SizedBox(height: 20),
                    
                    // Description
                    _buildSectionTitle("Description"),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration(
                        hintText: "Describe your service, experience, teaching methods...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Skills
                    _buildSkillsSection(),
                    const SizedBox(height: 20),
                    
                    // Location
                    _buildLocationSection(),
                    const SizedBox(height: 20),
                    
                    // Your Rate
                    _buildRateSection(),
                    const SizedBox(height: 8),
                    
                    // Explanation of rate
                    Text(
                      _rateType == 'hourly' 
                          ? "Clients will be charged this rate per hour" 
                          : _rateType == 'fixed' 
                              ? "Clients will be charged this fixed rate for the entire service" 
                              : "Clients will be charged this rate per session",
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Timeframe
                    _buildSectionTitle("Service Duration"),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration(
                        hintText: "Select typical duration",
                        prefixIcon: Icons.timer_outlined,
                      ),
                      value: _timeframeController.text.isEmpty ? null : _timeframeController.text,
                      items: _availableTimeframes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _timeframeController.text = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a duration';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                _isEditMode ? "Update Service" : "Post Service",
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }

  // Widget builder methods to organize the UI code

  Widget _buildExistingImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Current Images",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              _existingMediaUrls.length,
              (index) => _buildExistingImageItem(index),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNewImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "New Images",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              _imageFiles.length,
              (index) => _buildImageItem(index),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildVideoPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Video Preview",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: _existingVideoUrl != null ? _removeExistingVideo : _removeVideo,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_videoController != null && _videoController!.value.isInitialized)
          AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_videoController!),
                IconButton(
                  icon: Icon(
                    _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      _videoController!.value.isPlaying
                          ? _videoController!.pause()
                          : _videoController!.play();
                    });
                  },
                ),
              ],
            ),
          )
        else
          Container(
            height: 150,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMediaUploadButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.photo_library),
            label: const Text("Add Images"),
            onPressed: _pickImages,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.videocam),
            label: const Text("Add Video"),
            onPressed: _existingVideoUrl != null || _videoFile != null ? null : _pickVideo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[200],
              foregroundColor: Colors.black87,
              disabledBackgroundColor: Colors.grey[100],
              disabledForegroundColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Skills & Expertise"),
        // Selected skills chips
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
        
        // Skills input
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                controller: _skillsController,
                decoration: _inputDecoration(
                  hintText: "Add skills...",
                  prefixIcon: Icons.psychology,
                ),
                onFieldSubmitted: (value) {
                  _addSkill(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                _addSkill(_skillsController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ECDC4),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        
        // Suggested skills
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _suggestedSkills.map((skill) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(skill),
                onPressed: () => _addSkill(skill),
                backgroundColor: Colors.grey[100],
              ),
            )).toList(),
          ),
        ),
        
        if (_selectedSkills.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "Please add at least one skill",
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Location"),
        Row(
          children: [
            Checkbox(
              value: _isRemote,
              onChanged: (value) {
                setState(() {
                  _isRemote = value ?? false;
                });
              },
              activeColor: const Color(0xFF4ECDC4),
            ),
            const Text("This is an online/remote service"),
          ],
        ),
        if (!_isRemote)
          TextFormField(
            controller: _locationController,
            decoration: _inputDecoration(
              hintText: "E.g., University Campus, My Studio, Client's home",
              prefixIcon: Icons.location_on_outlined,
            ),
            validator: (value) {
              if (!_isRemote && (value == null || value.isEmpty)) {
                return 'Please enter a location';
              }
              return null;
            },
          ),
      ],
    );
  }

  Widget _buildRateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Your Rate"),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Currency dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currency,
                  onChanged: (String? newValue) {
                    setState(() {
                      _currency = newValue!;
                    });
                  },
                  items: _availableCurrencies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            
            // Rate amount
            Expanded(
              child: TextFormField(
                controller: _rateController,
                decoration: _inputDecoration(
                  hintText: "Enter your rate",
                  prefixIcon: Icons.attach_money,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your rate';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            
            // Rate type
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _rateType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _rateType = newValue!;
                    });
                  },
                  items: _availableRateTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildExistingImageItem(int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(_existingMediaUrls[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 8,
          child: GestureDetector(
            onTap: () => _removeExistingImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildImageItem(int index) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(_imageFiles[index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 8,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    IconData? prefixIcon,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF4ECDC4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
    );
  }
}