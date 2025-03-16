class User {
  final String id;
  final String email;
  final String fullName;
  final String? profilePicture;
  final String? resumeUrl;
  final List<String> skills;
  final String? jobTitle;
  final int yearsOfExperience;
  final String? bio;
  final String? location;
  final List<String>? interests;
  final DateTime? lastActive;
  final bool isAvailableForHire;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.profilePicture,
    this.resumeUrl,
    required this.skills,
    this.jobTitle,
    required this.yearsOfExperience,
    this.bio,
    this.location,
    this.interests,
    this.lastActive,
    this.isAvailableForHire = false,
  });

  // Create from JSON data (received from API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      profilePicture: json['profile_picture'],
      resumeUrl: json['resume_url'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      jobTitle: json['job_title'],
      yearsOfExperience: json['years_of_experience'] ?? 0,
      bio: json['bio'],
      location: json['location'],
      interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
      lastActive: json['last_active'] != null ? DateTime.parse(json['last_active']) : null,
      isAvailableForHire: json['is_available_for_hire'] ?? false,
    );
  }

  // Convert to JSON (to send to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'profile_picture': profilePicture,
      'resume_url': resumeUrl,
      'skills': skills,
      'job_title': jobTitle,
      'years_of_experience': yearsOfExperience,
      'bio': bio,
      'location': location,
      'interests': interests,
      'last_active': lastActive?.toIso8601String(),
      'is_available_for_hire': isAvailableForHire,
    };
  }

  // Create a copy of this user with updated fields
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? profilePicture,
    String? resumeUrl,
    List<String>? skills,
    String? jobTitle,
    int? yearsOfExperience,
    String? bio,
    String? location,
    List<String>? interests,
    DateTime? lastActive,
    bool? isAvailableForHire,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      skills: skills ?? this.skills,
      jobTitle: jobTitle ?? this.jobTitle,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      lastActive: lastActive ?? this.lastActive,
      isAvailableForHire: isAvailableForHire ?? this.isAvailableForHire,
    );
  }
}