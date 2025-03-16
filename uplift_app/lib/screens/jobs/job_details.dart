import 'package:flutter/material.dart';
import '../../models/job.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobId;

  const JobDetailScreen({
    Key? key,
    required this.jobId,
  }) : super(key: key);

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late Job _job;
  bool _isLoading = true;
  bool _isSaved = false;
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  @override
  void initState() {
    super.initState();
    _loadJobDetails();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 200 && !_showAppBarTitle) {
      setState(() {
        _showAppBarTitle = true;
      });
    } else if (_scrollController.offset <= 200 && _showAppBarTitle) {
      setState(() {
        _showAppBarTitle = false;
      });
    }
  }

  Future<void> _loadJobDetails() async {
    // This would normally fetch from an API
    // For now, we'll use dummy data
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
    
    final Job dummyJob = Job(
      id: widget.jobId,
      title: 'Senior Flutter Developer',
      company: 'Uplift Technologies',
      location: 'Remote / New York, NY',
      description: '''
We are looking for an experienced Flutter Developer to join our team and help us build beautiful, responsive mobile applications.

You will be responsible for developing high-quality mobile applications, collaborating with cross-functional teams, and ensuring the performance and quality of applications.

As a Flutter Developer, you will work with our team of talented engineers to design and build the next generation of our mobile applications.

We offer a competitive salary, flexible working hours, and an opportunity to work on exciting projects that will challenge you and help you grow as a developer.
''',
      requirements: [
        'Proven experience as a Flutter Developer with at least 3 years of experience',
        'Strong knowledge of Flutter framework and Dart programming language',
        'Experience with state management solutions (Provider, Bloc, Redux)',
        'Familiarity with RESTful APIs and GraphQL',
        'Understanding of the full mobile development lifecycle',
        'Ability to write clean, maintainable code',
        'Experience with Git version control',
        'Excellent problem-solving skills',
        'BSc/MSc in Computer Science, Engineering, or a related field',
      ],
      skills: [
        'Flutter',
        'Dart',
        'Mobile Development',
        'UI/UX',
        'Firebase',
        'REST APIs',
        'State Management',
      ],
      employmentType: 'Full-time',
      experienceLevel: 'Senior',
      salary: 120000,
      currency: 'USD',
      postedDate: DateTime.now().subtract(const Duration(days: 5)),
      contactEmail: 'careers@uplift-tech.com',
      contactPhone: '+1 (555) 123-4567',
      applicationUrl: 'https://careers.uplift-tech.com/flutter-developer',
      applicants: 42,
      isFeatured: true,
    );
    
    setState(() {
      _job = dummyJob;
      _isLoading = false;
    });
  }

  void _toggleSaved() {
    setState(() {
      _isSaved = !_isSaved;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isSaved ? 'Job saved to favorites' : 'Job removed from favorites'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _isSaved = !_isSaved;
            });
          },
        ),
      ),
    );
  }

  void _applyForJob() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  // Title
                  Text(
                    "Apply for ${_job.title}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _job.company,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Application form
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        // Resume upload
                        _buildApplicationField(
                          title: "Resume",
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Handle resume upload
                            },
                            icon: const Icon(Icons.upload_file),
                            label: const Text("Upload Resume"),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                        
                        // Cover letter
                        _buildApplicationField(
                          title: "Cover Letter (Optional)",
                          child: TextField(
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: "Tell us why you're a good fit for this position...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF4ECDC4)),
                              ),
                            ),
                          ),
                        ),
                        
                        // Contact information
                        _buildApplicationField(
                          title: "Phone Number",
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter your phone number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF4ECDC4)),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        
                        // Additional questions
                        _buildApplicationField(
                          title: "Years of Experience",
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Enter years of relevant experience",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFF4ECDC4)),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Submit button
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Application submitted successfully!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF4ECDC4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Submit Application",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildApplicationField({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: _showAppBarTitle
            ? const Row(
                children: [
                  // Logo with gradient letter
                  Text(
                    "Job Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  // Logo with gradient letter
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Up",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        WidgetSpan(
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF4ECDC4), Color(0xFF56E39F)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds),
                            child: const Text(
                              "l",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(
                          text: "ift",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_outline,
              color: _isSaved ? const Color(0xFF4ECDC4) : Colors.grey[800],
            ),
            onPressed: _isLoading ? null : _toggleSaved,
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.grey[800]),
            onPressed: _isLoading
                ? null
                : () {
                    // Share job
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sharing job...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company header
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[100],
                          ),
                          child: Center(
                            child: Text(
                              _job.company[0],
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4ECDC4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _job.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _job.company,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    _job.location,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Job stats
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildJobStat(Icons.attach_money, "${_job.formattedSalary}/year"),
                        _buildJobStat(Icons.work_outline, _job.employmentType),
                        _buildJobStat(Icons.timeline, _job.experienceLevel),
                        _buildJobStat(Icons.people_outline, "${_job.applicants} applied"),
                      ],
                    ),
                  ),
                  
                  // Job description
                  _buildSection(
                    title: "Job Description",
                    content: Text(
                      _job.description,
                      style: TextStyle(
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  // Requirements
                  _buildSection(
                    title: "Requirements",
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _job.requirements.map((requirement) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle, size: 16, color: Colors.green[500]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  requirement,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Skills
                  _buildSection(
                    title: "Skills",
                    content: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _job.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4ECDC4).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: Color(0xFF4ECDC4),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Contact information
                  _buildSection(
                    title: "Contact Information",
                    content: Column(
                      children: [
                        _buildContactItem(
                          icon: Icons.email_outlined,
                          title: "Email",
                          value: _job.contactEmail ?? "Not provided",
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          icon: Icons.phone_outlined,
                          title: "Phone",
                          value: _job.contactPhone ?? "Not provided",
                        ),
                      ],
                    ),
                  ),
                  
                  // Posted date and deadline
                  _buildSection(
                    title: "Additional Information",
                    content: Column(
                      children: [
                        _buildInfoItem(
                          title: "Posted Date",
                          value: "Posted ${_job.timeAgo}",
                        ),
                        const SizedBox(height: 8),
                        _buildInfoItem(
                          title: "Job ID",
                          value: _job.id,
                        ),
                      ],
                    ),
                  ),
                  
                  // Similar jobs notice
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Similar Jobs",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  // Spacing at the bottom to account for the apply button
                  const SizedBox(height: 80),
                ],
              ),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _applyForJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4ECDC4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Apply Now",
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
          BottomNavigationBar(
            selectedItemColor: const Color(0xFF4ECDC4),
            unselectedItemColor: Colors.grey,
            currentIndex: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: "Discover",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                label: "Post",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined),
                label: "Messages",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                label: "Applications",
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
              // Handle other navigation items
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget content,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  Widget _buildJobStat(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF4ECDC4)),
        const SizedBox(height: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF4ECDC4)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }
}