class PeerJob {
  final String id;
  final String title;
  final String description;
  final String userId;
  final Map<String, dynamic>? userDetails; // Contains user information like full_name, profile_picture
  final List<String> skills;
  final String location;
  final double budget;
  final String currency;
  final String timeframe; // e.g., "1 week", "1 month"
  final DateTime postedDate;
  final String status; // e.g., "open", "in_progress", "completed"
  final bool isRemote;
  final int applicants;
  final bool isSaved;

  PeerJob({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    this.userDetails,
    required this.skills,
    required this.location,
    required this.budget,
    required this.currency,
    required this.timeframe,
    required this.postedDate,
    required this.status,
    this.isRemote = false,
    this.applicants = 0,
    this.isSaved = false,
  });

  // Create from JSON data (received from API)
  factory PeerJob.fromJson(Map<String, dynamic> json) {
    return PeerJob(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['user_id'],
      userDetails: json['users'], // This comes from the join in DatabaseService
      skills: _extractSkillsFromJson(json),
      location: json['location'],
      budget: (json['budget'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      timeframe: json['timeframe'],
      postedDate: DateTime.parse(json['posted_date']),
      status: json['status'],
      isRemote: json['is_remote'] ?? false,
      applicants: json['applicants'] ?? 0,
      isSaved: json['is_saved'] ?? false,
    );
  }

  // Helper method to extract skills from the nested JSON structure
  static List<String> _extractSkillsFromJson(Map<String, dynamic> json) {
    // If skills are directly in the JSON
    if (json['skills'] is List) {
      return List<String>.from(json['skills']);
    }
    
    // If skills are from a join table (peer_job_skills)
    if (json['peer_job_skills'] is List) {
      final skillsList = <String>[];
      for (var skillJoin in json['peer_job_skills']) {
        if (skillJoin['skills'] != null && skillJoin['skills']['name'] != null) {
          skillsList.add(skillJoin['skills']['name']);
        }
      }
      return skillsList;
    }
    
    return [];
  }

  // Convert to JSON (to send to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'user_id': userId,
      'location': location,
      'budget': budget,
      'currency': currency,
      'timeframe': timeframe,
      'posted_date': postedDate.toIso8601String(),
      'status': status,
      'is_remote': isRemote,
      'applicants': applicants,
    };
  }

  // Format budget for display
  String get formattedBudget {
    if (currency == 'USD') {
      return '\$${budget.toInt().toString()}';
    } else {
      return '${budget.toInt().toString()} $currency';
    }
  }

  // Get time ago string (e.g., "2d ago")
  String get timeAgo {
    final difference = DateTime.now().difference(postedDate);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }

  // Get user name from nested user details
  String? get userName {
    if (userDetails != null && userDetails!.containsKey('full_name')) {
      return userDetails!['full_name'];
    }
    return null;
  }

  // Get user profile picture from nested user details
  String? get userProfilePicture {
    if (userDetails != null && userDetails!.containsKey('profile_picture')) {
      return userDetails!['profile_picture'];
    }
    return null;
  }
}