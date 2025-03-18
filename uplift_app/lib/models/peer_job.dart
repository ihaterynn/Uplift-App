class PeerJob {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> skills;
  final String location;
  final double budget;
  final String currency;
  final String timeframe;
  final DateTime postedDate;
  final String rateType;
  final bool isRemote;
  final List<String>? mediaUrls; // Added for image storage
  final String? videoUrl;        // Added for video storage
  final int viewCount;           // Added to track popularity
  final double? rating;          // Added to store average rating
  
  PeerJob({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.skills,
    required this.location,
    required this.budget,
    required this.currency,
    required this.timeframe,
    required this.postedDate,
    required this.rateType,
    required this.isRemote,
    this.mediaUrls,
    this.videoUrl,
    this.viewCount = 0,
    this.rating,
  });

  // Convert PeerJob instance to a map for insertion
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'location': location,
      'rate': budget,
      'rate_type': rateType,
      'currency': currency,
      'posted_date': postedDate.toIso8601String(),
      'is_active': true,
      'is_remote': isRemote,
      'timeframe': timeframe,
      'media_urls': mediaUrls,
      'video_url': videoUrl,
      'view_count': viewCount,
      'rating': rating,
      // Skills might need to be handled separately depending on your implementation
    };
  }

  // Factory constructor to create a PeerJob from a JSON map
  factory PeerJob.fromJson(Map<String, dynamic> json) {
    return PeerJob(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      skills: json['skills'] != null
          ? List<String>.from(json['skills'])
          : [],
      location: json['location'] as String,
      budget: (json['rate'] as num).toDouble(),
      currency: json['currency'] as String,
      timeframe: json['timeframe'] != null ? json['timeframe'] as String : '',
      postedDate: DateTime.parse(json['posted_date'] as String),
      rateType: json['rate_type'] as String,
      isRemote: json.containsKey('is_remote') ? json['is_remote'] as bool : false,
      mediaUrls: json['media_urls'] != null ? List<String>.from(json['media_urls']) : null,
      videoUrl: json['video_url'] as String?,
      viewCount: json['view_count'] as int? ?? 0,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
    );
  }
  
  // Create a copy with updated fields
  PeerJob copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    List<String>? skills,
    String? location,
    double? budget,
    String? currency,
    String? timeframe,
    DateTime? postedDate,
    String? rateType,
    bool? isRemote,
    List<String>? mediaUrls,
    String? videoUrl,
    int? viewCount,
    double? rating,
  }) {
    return PeerJob(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      skills: skills ?? this.skills,
      location: location ?? this.location,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      timeframe: timeframe ?? this.timeframe,
      postedDate: postedDate ?? this.postedDate,
      rateType: rateType ?? this.rateType,
      isRemote: isRemote ?? this.isRemote,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      viewCount: viewCount ?? this.viewCount,
      rating: rating ?? this.rating,
    );
  }
}