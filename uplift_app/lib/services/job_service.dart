import '../models/job.dart';

class JobService {
  // Singleton pattern
  static final JobService _instance = JobService._internal();
  factory JobService() => _instance;
  JobService._internal();

  // In-memory job storage
  final Map<String, Job> _jobs = {};

  // Initialize with mock data
  void initializeMockJobs() {
    // Featured jobs
    _addJob(
      title: "Software Engineer",
      company: "Google",
      location: "Mountain View, CA",
      skills: ["Flutter", "Dart", "Firebase"],
      salary: 120000,
      description: "Join Google's engineering team to build innovative products used by billions of people.",
      requirements: [
        "Bachelor's degree in Computer Science or related field",
        "3+ years of experience in software development",
        "Strong problem-solving skills",
      ],
      employmentType: "Full-time",
      experienceLevel: "Mid-level",
    );
    
    // Add more mock jobs as needed
    _addJob(
      title: "Product Designer",
      company: "Apple",
      location: "Cupertino, CA",
      skills: ["UI/UX", "Figma", "Prototyping"],
      salary: 110000,
      description: "Design beautiful, intuitive interfaces for Apple's next generation of products.",
      requirements: [
        "Bachelor's degree in Design, HCI, or related field",
        "4+ years of experience in product design",
        "Strong portfolio showing UI/UX work",
      ],
      employmentType: "Full-time",
      experienceLevel: "Senior",
    );
    
    // Add more jobs as needed...
  }

  // Add a job and return its ID
  String _addJob({
    required String title,
    required String company,
    required String location,
    required List<String> skills,
    required double salary,
    required String description,
    required List<String> requirements,
    required String employmentType,
    required String experienceLevel,
  }) {
    final id = "${company.toLowerCase()}-${title.toLowerCase().replaceAll(' ', '-')}";
    
    _jobs[id] = Job(
      id: id,
      title: title,
      company: company,
      location: location,
      description: description,
      requirements: requirements,
      skills: skills,
      employmentType: employmentType,
      experienceLevel: experienceLevel,
      salary: salary,
      currency: "USD",
      postedDate: DateTime.now().subtract(Duration(days: _jobs.length % 7)),
    );
    
    return id;
  }

  // Get a job by ID
  Job? getJobById(String id) {
    return _jobs[id];
  }

  // Get all jobs
  List<Job> getAllJobs() {
    return _jobs.values.toList();
  }
  
  // Get featured jobs
  List<Job> getFeaturedJobs() {
    return _jobs.values.where((job) => 
      job.company == "Google" || 
      job.company == "Apple" || 
      job.company == "Netflix"
    ).toList();
  }
  
  // Get recommended jobs
  List<Job> getRecommendedJobs() {
    // In a real app, this would use an algorithm based on user preferences
    return _jobs.values.where((job) => 
      job.skills.contains("Flutter") || 
      job.skills.contains("Mobile")
    ).toList();
  }
}