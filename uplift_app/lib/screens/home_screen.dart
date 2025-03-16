import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/job.dart';
import '../widgets/uplift_app_bar.dart';
import '../widgets/uplift_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: UpliftAppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4ECDC4),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF4ECDC4),
          tabs: const [
            Tab(text: "Job Listings"),
            Tab(text: "Student Services"),
          ],
        ),
      ),
    ),
    body: Column(
      children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search for jobs, skills, companies...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  onPressed: () {
                    // Show filters
                  },
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Job Listings Tab
                _buildJobListingsTab(),
                
                // Student Services Tab
                _buildStudentServicesTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: UpliftBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) { // If not the current tab (Home)
            if (index == 1) {
              Navigator.pushReplacementNamed(context, '/discover');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/post');
            } else if (index == 3) {
              Navigator.pushReplacementNamed(context, '/messages');
            } else if (index == 4) {
              Navigator.pushReplacementNamed(context, '/applications');
            }
          }
        },
      ),
    );
  }

  // Rest of your code remains the same
  
  Widget _buildJobListingsTab() {
    // Existing code
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Featured Jobs Section
        _buildSectionTitle("Featured Jobs"),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFeaturedJobCard(
                "Software Engineer",
                "Google",
                "Mountain View, CA",
                ["Flutter", "Dart", "Firebase"],
                "\$120,000 - \$150,000",
              ),
              _buildFeaturedJobCard(
                "Product Designer",
                "Apple",
                "Cupertino, CA",
                ["UI/UX", "Figma", "Prototyping"],
                "\$110,000 - \$140,000",
              ),
              _buildFeaturedJobCard(
                "Data Scientist",
                "Netflix",
                "Los Gatos, CA",
                ["Python", "ML", "SQL"],
                "\$130,000 - \$160,000",
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Recommended for You
        _buildSectionTitle("Recommended for You"),
        const SizedBox(height: 12),
        _buildJobCard(
          "Flutter Developer",
          "Spotify",
          "Remote",
          ["Mobile", "Flutter", "Dart"],
          "\$95,000 - \$120,000",
          "2d ago",
          matchScore: 95,
        ),
        _buildJobCard(
          "Frontend Engineer",
          "Airbnb",
          "San Francisco, CA",
          ["React", "JavaScript", "CSS"],
          "\$110,000 - \$135,000",
          "1d ago",
          matchScore: 88,
        ),
        _buildJobCard(
          "Mobile Developer",
          "Twitter",
          "Hybrid",
          ["Flutter", "iOS", "Android"],
          "\$90,000 - \$115,000",
          "3d ago",
          matchScore: 82,
        ),
        
        const SizedBox(height: 24),
        
        // Recent Jobs
        _buildSectionTitle("Recent Jobs"),
        const SizedBox(height: 12),
        _buildJobCard(
          "UX Designer",
          "Microsoft",
          "Seattle, WA",
          ["Design", "Figma", "Adobe"],
          "\$100,000 - \$125,000",
          "6h ago",
        ),
        _buildJobCard(
          "Backend Developer",
          "Amazon",
          "Remote",
          ["Java", "AWS", "Kubernetes"],
          "\$115,000 - \$140,000",
          "12h ago",
        ),
        _buildJobCard(
          "AI Engineer",
          "Meta",
          "New York, NY",
          ["Python", "TensorFlow", "ML"],
          "\$130,000 - \$160,000",
          "1d ago",
        ),
      ],
    );
  }

  Widget _buildStudentServicesTab() {
    // Existing code
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Featured Student Services
        _buildSectionTitle("Trending Student Services"),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFeaturedPeerJobCard(
                "Web Development",
                "Michael Chen",
                "Remote",
                ["HTML/CSS", "JavaScript", "WordPress"],
                "\$25/hr",
              ),
              _buildFeaturedPeerJobCard(
                "Graphic Design",
                "Sarah Johnson",
                "Remote",
                ["Photoshop", "Illustrator", "Branding"],
                "\$30/hr",
              ),
              _buildFeaturedPeerJobCard(
                "Math Tutoring",
                "David Williams",
                "In-person/Online",
                ["Calculus", "Statistics", "Algebra"],
                "\$20/hr",
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Recently Added
        _buildSectionTitle("Recently Added"),
        const SizedBox(height: 12),
        _buildPeerJobCard(
          "Resume Review",
          "Emma Thompson",
          "Online",
          ["Career Advice", "Editing", "ATS Optimization"],
          "\$15/review",
          "3h ago",
          rating: 4.8,
        ),
        _buildPeerJobCard(
          "Essay Editing",
          "James Wilson",
          "Remote",
          ["Proofreading", "Grammar", "Structure"],
          "\$18/hr",
          "5h ago",
          rating: 4.6,
        ),
        _buildPeerJobCard(
          "UI/UX Consultation",
          "Olivia Martinez",
          "Remote",
          ["Wireframing", "User Testing", "Prototyping"],
          "\$30/hr",
          "1d ago",
          rating: 4.9,
        ),
        
        const SizedBox(height: 24),
        
        // Near You
        _buildSectionTitle("Services Near You"),
        const SizedBox(height: 12),
        _buildPeerJobCard(
          "Photography",
          "Noah Garcia",
          "In-person",
          ["Portraits", "Events", "Editing"],
          "\$50/session",
          "2d ago",
          rating: 4.7,
        ),
        _buildPeerJobCard(
          "Moving Assistance",
          "Sophia Lewis",
          "In-person",
          ["Heavy Lifting", "Packing", "Assembly"],
          "\$22/hr",
          "6h ago",
          rating: 4.5,
        ),
        _buildPeerJobCard(
          "Dog Walking",
          "Ethan Brown",
          "In-person",
          ["Pet Care", "Exercise", "Feeding"],
          "\$15/walk",
          "12h ago",
          rating: 4.8,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    // Existing code
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
        TextButton(
          onPressed: () {
            // Navigate to see all
          },
          child: const Text(
            "See All",
            style: TextStyle(
              color: Color(0xFF4ECDC4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedJobCard(String title, String company, String location, List<String> skills, String salary) {
    // Existing code
    final String jobId = "${company.toLowerCase()}-${title.toLowerCase().replaceAll(' ', '-')}";
    
    return GestureDetector(
      onTap: () {
        // Navigate to job details screen
        Navigator.pushNamed(
          context,
          '/job-details',
          arguments: jobId,
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    child: Center(
                      child: Text(
                        company[0],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4ECDC4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.bookmark_border,
                    color: Colors.grey[600],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                salary,
                style: const TextStyle(
                  color: Color(0xFF4ECDC4),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(String title, String company, String location, List<String> skills, String salary, String timePosted, {int? matchScore}) {
    // Existing code
    final String jobId = "${company.toLowerCase()}-${title.toLowerCase().replaceAll(' ', '-')}";
    
    return GestureDetector(
      onTap: () {
        // Navigate to job details screen
        Navigator.pushNamed(
          context,
          '/job-details',
          arguments: jobId,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    child: Center(
                      child: Text(
                        company[0],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4ECDC4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              company,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text("•"),
                            const SizedBox(width: 4),
                            Text(
                              location,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timePosted,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    salary,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((skill) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      color: Color(0xFF4ECDC4),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
              if (matchScore != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF4ECDC4), Color(0xFF56E39F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.thumb_up,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$matchScore% Match",
                        style: const TextStyle(
                          color: Color(0xFF4ECDC4),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedPeerJobCard(String title, String provider, String location, List<String> skills, String rate) {
    // Existing code
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    provider.split(' ').map((e) => e[0]).join(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "4.8",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "($location)",
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
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              rate,
              style: const TextStyle(
                color: Color(0xFF4ECDC4),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    color: Color(0xFF4ECDC4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeerJobCard(String title, String provider, String location, List<String> skills, String rate, String timePosted, {required double rating}) {
    // Existing code
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    provider.split(' ').map((e) => e[0]).join(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        provider,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            location,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rate,
                      style: const TextStyle(
                        color: Color(0xFF4ECDC4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timePosted,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4ECDC4).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    color: Color(0xFF4ECDC4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}