class PeerJob {
  final String id;
  final String userId;
  final String title;
  final String description;
  final List<String> skills;
  final String location;
  final double budget; // using this to store the rate
  final String currency;
  final String timeframe;
  final DateTime postedDate;
  final String rateType; // new field for rate type
  final bool isRemote;

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
  });

  // Convert PeerJob instance to a map for insertion
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'location': location,
      'rate': budget,
      'rate_type': rateType, // now using the correct field
      'currency': currency,
      'posted_date': postedDate.toIso8601String(),
      'is_active': true,
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
      // Defaulting isRemote to false if not provided by your API/DB.
      isRemote: json.containsKey('is_remote') ? json['is_remote'] as bool : false,
    );
  }
}
