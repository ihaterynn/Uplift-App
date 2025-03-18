import 'package:flutter/material.dart';
import '../../models/peer_job.dart';
import '../../services/database_service.dart';
import '../../services/supabase_service.dart';

class PeerJobDetails extends StatefulWidget {
  final String jobId;
  
  const PeerJobDetails({Key? key, required this.jobId}) : super(key: key);
  
  @override
  State<PeerJobDetails> createState() => _PeerJobDetailsState();
}

class _PeerJobDetailsState extends State<PeerJobDetails> {
  final DatabaseService _databaseService = DatabaseService();
  final SupabaseService _supabaseService = SupabaseService();
  
  // Dev mode for testing without authentication - match the same flag from CreatePeerJobPostScreen
  final bool _devMode = true;
  // Use the same hardcoded user ID as in CreatePeerJobPostScreen
  final String _devUserId = "a4fa3b69-5cec-4dde-999f-8cf5bc67cf4a";
  
  bool _isLoading = true;
  PeerJob? _peerJob;
  bool _isCurrentUserOwner = false;
  
  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }
  
  Future<void> _loadJobDetails() async {
    setState(() => _isLoading = true);
    
    try {
      final job = await _databaseService.getPeerJobById(widget.jobId);
      
      // Use the same user ID resolution as in CreatePeerJobPostScreen
      final currentUserId = _supabaseService.currentUserId ?? (_devMode ? _devUserId : null);
      
      print("===== USER ID DEBUG =====");
      print("Dev Mode: $_devMode");
      print("Current User ID: $currentUserId");
      print("Job Owner ID: ${job?.userId}");
      print("ID Equality Check: ${currentUserId == job?.userId}");
      print("========================");
      
      if (mounted) {
        setState(() {
          _peerJob = job;
          // Set owner status based on ID match, just like in CreatePeerJobPostScreen
          _isCurrentUserOwner = _devMode || (currentUserId != null && job?.userId == currentUserId);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading job: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading service details')),
        );
      }
    }
  }
  
  void _navigateToEditScreen() async {
    print("Navigating to edit screen with job ID: ${widget.jobId}");
    // Navigate to edit screen with the job ID
    final result = await Navigator.pushNamed(
      context, 
      '/edit-peer-job',
      arguments: widget.jobId,
    );
    
    print("Result from edit screen: $result");
    
    // Refresh data if edit was successful
    if (result == true) {
      _loadJobDetails();
    }
  }
  
  void _requestService() {
    // Implement request service functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service request feature coming soon!')),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Service Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_peerJob == null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Service Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: Text("Service not found")),
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Service Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isCurrentUserOwner)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: _navigateToEditScreen,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media Gallery
            _buildMediaGallery(),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Owner status indicator - For debugging and development
                  if (_devMode)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "Dev Mode: Edit enabled",
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                  // Title and Rate
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          _peerJob!.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${_peerJob!.currency} ${_peerJob!.budget} ${_getRateTypeText()}",
                          style: const TextStyle(
                            color: Color(0xFF4ECDC4),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Location and Posted Date
                  Row(
                    children: [
                      Icon(
                        _peerJob!.isRemote ? Icons.web : Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _peerJob!.location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Posted ${_getPostedDateText()}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Skills Section
                  const Text(
                    "Skills & Expertise",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _peerJob!.skills.map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: const Color(0xFF4ECDC4).withOpacity(0.1),
                      labelStyle: const TextStyle(
                        color: Color(0xFF4ECDC4),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),
                  
                  // Description Section
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _peerJob!.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Service Details Section
                  const Text(
                    "Service Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailItem(
                    icon: Icons.timer_outlined,
                    title: "Duration",
                    value: _peerJob!.timeframe,
                  ),
                  _buildDetailItem(
                    icon: Icons.attach_money,
                    title: "Rate",
                    value: "${_peerJob!.currency} ${_peerJob!.budget} ${_getRateTypeText()}",
                  ),
                  _buildDetailItem(
                    icon: _peerJob!.isRemote ? Icons.web : Icons.location_on_outlined,
                    title: "Location",
                    value: _peerJob!.location,
                  ),
                  const SizedBox(height: 30),
                  
                  // Action Button (Edit or Request based on ownership)
                  if (_isCurrentUserOwner)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _navigateToEditScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Edit Service",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _requestService,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4ECDC4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Request Service",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMediaGallery() {
    // If there's no media
    if ((_peerJob!.mediaUrls == null || _peerJob!.mediaUrls!.isEmpty) && 
        _peerJob!.videoUrl == null) {
      return Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[200],
        child: const Center(
          child: Icon(
            Icons.photo_library,
            size: 48,
            color: Colors.grey,
          ),
        ),
      );
    }
    
    // If there's video, show it first
    if (_peerJob!.videoUrl != null) {
      return Container(
        height: 250,
        width: double.infinity,
        color: Colors.black,
        child: const Center(
          child: Icon(
            Icons.play_circle_fill,
            size: 64,
            color: Colors.white,
          ),
        ),
      );
    }
    
    // If there are images, show the first one
    if (_peerJob!.mediaUrls != null && _peerJob!.mediaUrls!.isNotEmpty) {
      return SizedBox(
        height: 250,
        child: PageView.builder(
          itemCount: _peerJob!.mediaUrls!.length,
          itemBuilder: (context, index) {
            return Image.network(
              _peerJob!.mediaUrls![index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }
    
    // Fallback (should never happen based on the logic above)
    return const SizedBox.shrink();
  }
  
  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _getRateTypeText() {
    switch (_peerJob!.rateType) {
      case 'hourly':
        return '/hour';
      case 'fixed':
        return ' flat rate';
      case 'per session':
        return '/session';
      default:
        return '';
    }
  }
  
  String _getPostedDateText() {
    final difference = DateTime.now().difference(_peerJob!.postedDate);
    
    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? '1 day ago' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }
}