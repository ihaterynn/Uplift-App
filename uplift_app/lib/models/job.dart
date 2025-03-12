import 'package:flutter/material.dart';

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final String description;
  final List<String> requirements;
  final List<String> skills;
  final String employmentType; // full-time, part-time, contract
  final String experienceLevel; // entry, mid, senior
  final double salary;
  final String currency;
  final DateTime postedDate;
  final String? logoUrl;
  final double? matchScore; // AI-calculated match score
  final String? contactEmail;
  final String? contactPhone;
  final String? applicationUrl;
  final int applicants;
  final bool isFeatured;
  final bool isSaved;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.requirements,
    required this.skills,
    required this.employmentType,
    required this.experienceLevel,
    required this.salary,
    required this.currency,
    required this.postedDate,
    this.logoUrl,
    this.matchScore,
    this.contactEmail,
    this.contactPhone,
    this.applicationUrl,
    this.applicants = 0,
    this.isFeatured = false,
    this.isSaved = false,
  });

  // Create from JSON data (received from API)
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      description: json['description'],
      requirements: List<String>.from(json['requirements'] ?? []),
      skills: _extractSkillsFromJson(json),
      employmentType: json['employment_type'],
      experienceLevel: json['experience_level'],
      salary: (json['salary'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      postedDate: DateTime.parse(json['posted_date']),
      logoUrl: json['logo_url'],
      matchScore: json['match_score'] != null ? (json['match_score'] as num).toDouble() : null,
      contactEmail: json['contact_email'],
      contactPhone: json['contact_phone'],
      applicationUrl: json['application_url'],
      applicants: json['applicants'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
      isSaved: json['is_saved'] ?? false,
    );
  }

  // Helper method to extract skills from the nested JSON structure
  static List<String> _extractSkillsFromJson(Map<String, dynamic> json) {
    // If skills are directly in the JSON
    if (json['skills'] is List) {
      return List<String>.from(json['skills']);
    }
    
    // If skills are from a join table (job_skills)
    if (json['job_skills'] is List) {
      final skillsList = <String>[];
      for (var skillJoin in json['job_skills']) {
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
      'company': company,
      'location': location,
      'description': description,
      'requirements': requirements,
      'employment_type': employmentType,
      'experience_level': experienceLevel,
      'salary': salary,
      'currency': currency,
      'posted_date': postedDate.toIso8601String(),
      'logo_url': logoUrl,
      'contact_email': contactEmail,
      'contact_phone': contactPhone,
      'application_url': applicationUrl,
      'applicants': applicants,
      'is_featured': isFeatured,
      'is_saved': isSaved,
    };
  }

  // Create a dummy job for testing
  factory Job.dummy({
    required String id,
    required String title,
    required String company,
    required String location,
  }) {
    return Job(
      id: id,
      title: title,
      company: company,
      location: location,
      description: 'This is a sample job description. It includes details about the role, responsibilities, and what the company is looking for in an ideal candidate.',
      requirements: [
        'Bachelor\'s degree in related field',
        '2+ years of experience',
        'Strong communication skills',
        'Ability to work in a team'
      ],
      skills: ['Communication', 'Teamwork', 'Problem Solving'],
      employmentType: 'Full-time',
      experienceLevel: 'Mid-level',
      salary: 80000,
      currency: 'USD',
      postedDate: DateTime.now().subtract(const Duration(days: 3)),
      applicants: 24,
    );
  }

  // Create a copy of this job with updated fields
  Job copyWith({
    String? id,
    String? title,
    String? company,
    String? location,
    String? description,
    List<String>? requirements,
    List<String>? skills,
    String? employmentType,
    String? experienceLevel,
    double? salary,
    String? currency,
    DateTime? postedDate,
    String? logoUrl,
    double? matchScore,
    String? contactEmail,
    String? contactPhone,
    String? applicationUrl,
    int? applicants,
    bool? isFeatured,
    bool? isSaved,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      skills: skills ?? this.skills,
      employmentType: employmentType ?? this.employmentType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      salary: salary ?? this.salary,
      currency: currency ?? this.currency,
      postedDate: postedDate ?? this.postedDate,
      logoUrl: logoUrl ?? this.logoUrl,
      matchScore: matchScore ?? this.matchScore,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      applicationUrl: applicationUrl ?? this.applicationUrl,
      applicants: applicants ?? this.applicants,
      isFeatured: isFeatured ?? this.isFeatured,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  // Format salary for display
  String get formattedSalary {
    if (currency == 'USD') {
      return '\$${salary.toInt().toString()}';
    } else {
      return '${salary.toInt().toString()} $currency';
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
  
  // New helper methods for UI display
  
  // Get salary range for display
  String get salaryRange {
    final minSalary = (salary * 0.9).toInt();
    final maxSalary = (salary * 1.1).toInt();
    
    if (currency == 'USD') {
      return '\$${minSalary.toString()} - \$${maxSalary.toString()}';
    } else {
      return '${minSalary.toString()} - ${maxSalary.toString()} $currency';
    }
  }
  
  // Get company logo as widget
  Widget getCompanyLogo({double size = 50.0, double fontSize = 24.0}) {
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          logoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _getDefaultLogo(size, fontSize);
          },
        ),
      );
    } else {
      return _getDefaultLogo(size, fontSize);
    }
  }
  
  // Generate default logo based on company initial
  Widget _getDefaultLogo(double size, double fontSize) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Center(
        child: Text(
          company.isNotEmpty ? company[0] : '?',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4ECDC4),
          ),
        ),
      ),
    );
  }
  
  // Get formatted employment type
  String get formattedEmploymentType {
    switch (employmentType.toLowerCase()) {
      case 'full-time':
        return 'Full-time';
      case 'part-time':
        return 'Part-time';
      case 'contract':
        return 'Contract';
      case 'internship':
        return 'Internship';
      case 'freelance':
        return 'Freelance';
      default:
        return employmentType;
    }
  }
  
  // Get formatted experience level
  String get formattedExperienceLevel {
    switch (experienceLevel.toLowerCase()) {
      case 'entry':
      case 'entry-level':
        return 'Entry Level';
      case 'mid':
      case 'mid-level':
        return 'Mid Level';
      case 'senior':
      case 'senior-level':
        return 'Senior Level';
      case 'executive':
        return 'Executive';
      default:
        return experienceLevel;
    }
  }
  
  // Get job type icon
  IconData get typeIcon {
    switch (employmentType.toLowerCase()) {
      case 'full-time':
        return Icons.work;
      case 'part-time':
        return Icons.work_outline;
      case 'contract':
        return Icons.assignment;
      case 'internship':
        return Icons.school;
      case 'freelance':
        return Icons.person;
      default:
        return Icons.business_center;
    }
  }
}