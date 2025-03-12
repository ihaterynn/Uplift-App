import 'package:flutter/material.dart';
import '../../models/job.dart';
import '../../widgets/job_card.dart';

class JobListScreen extends StatefulWidget {
  final String? category;
  final String? searchQuery;
  final bool showRecommended;

  const JobListScreen({
    Key? key,
    this.category,
    this.searchQuery,
    this.showRecommended = false,
  }) : super(key: key);

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late List<Job> _jobs;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String _selectedFilter = 'All Jobs';
  final List<String> _filters = ['All Jobs', 'Remote', 'Full-time', 'Part-time', 'Contract'];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery ?? '';
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    // This would normally fetch from an API
    // For now, we'll use dummy data
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    setState(() {
      _jobs = [
        Job.dummy(
          id: '1',
          title: 'Software Engineer',
          company: 'Google',
          location: 'Mountain View, CA',
        ),
        Job.dummy(
          id: '2',
          title: 'Product Designer',
          company: 'Apple',
          location: 'Cupertino, CA',
        ),
        Job.dummy(
          id: '3',
          title: 'Data Scientist',
          company: 'Netflix',
          location: 'Los Gatos, CA',
        ),
        Job.dummy(
          id: '4',
          title: 'Flutter Developer',
          company: 'Spotify',
          location: 'Remote',
        ),
        Job.dummy(
          id: '5',
          title: 'Frontend Engineer',
          company: 'Airbnb',
          location: 'San Francisco, CA',
        ),
        Job.dummy(
          id: '6',
          title: 'Mobile Developer',
          company: 'Twitter',
          location: 'Hybrid',
        ),
        Job.dummy(
          id: '7',
          title: 'UX Designer',
          company: 'Microsoft',
          location: 'Seattle, WA',
        ),
        Job.dummy(
          id: '8',
          title: 'Backend Developer',
          company: 'Amazon',
          location: 'Remote',
        ),
        Job.dummy(
          id: '9',
          title: 'AI Engineer',
          company: 'Meta',
          location: 'New York, NY',
        ),
      ];
      
      // Apply filtering based on category or search query
      if (widget.category != null) {
        _jobs = _jobs.where((job) => 
          job.employmentType.toLowerCase() == widget.category!.toLowerCase() ||
          job.location.toLowerCase().contains(widget.category!.toLowerCase())
        ).toList();
      }
      
      if (widget.searchQuery != null && widget.searchQuery!.isNotEmpty) {
        final query = widget.searchQuery!.toLowerCase();
        _jobs = _jobs.where((job) => 
          job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query) ||
          job.skills.any((skill) => skill.toLowerCase().contains(query))
        ).toList();
      }
      
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        title: Row(
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
            icon: Icon(Icons.notifications_outlined, color: Colors.grey[800]),
            onPressed: () {
              // Navigate to notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.grey[800]),
            onPressed: () {
              // Navigate to profile
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search jobs, skills, companies...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.tune, color: Colors.grey),
                  onPressed: () {
                    // Show filters
                    _showFilterBottomSheet(context);
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
              onSubmitted: (value) {
                // Perform search
                setState(() {
                  _isLoading = true;
                });
                _loadJobs();
              },
            ),
          ),
          
          // Filter chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = filter;
                          _isLoading = true;
                        });
                        _loadJobs();
                      }
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: const Color(0xFF4ECDC4).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF4ECDC4) : Colors.grey[800],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.showRecommended 
                      ? "Recommended Jobs"
                      : widget.category != null 
                          ? "${widget.category} Jobs"
                          : "All Jobs",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                        ),
                      )
                    : Text(
                        "${_jobs.length} Results",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
              ],
            ),
          ),
          
          // Job listings
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                    ),
                  )
                : _jobs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No jobs found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Try adjusting your search or filters",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _jobs.length,
                        itemBuilder: (context, index) {
                          final job = _jobs[index];
                          return JobCard(
                            job: job,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/job-details',
                                arguments: job.id,
                              );
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
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
              padding: const EdgeInsets.all(16.0),
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
                  const Text(
                    "Filter Jobs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Filters will go here
                  // This is just a placeholder. You would expand this with actual filter options.
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        _buildFilterSection("Job Type", ["Full-time", "Part-time", "Contract", "Internship"]),
                        _buildFilterSection("Experience Level", ["Entry-level", "Mid-level", "Senior", "Manager", "Executive"]),
                        _buildFilterSection("Location", ["Remote", "Hybrid", "On-site"]),
                        _buildFilterSection("Salary Range", ["\$0-\$50k", "\$50k-\$100k", "\$100k-\$150k", "\$150k+"]),
                      ],
                    ),
                  ),
                  
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFF4ECDC4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Reset",
                            style: TextStyle(color: Color(0xFF4ECDC4)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Apply filters
                            setState(() {
                              _isLoading = true;
                            });
                            _loadJobs();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFF4ECDC4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("Apply"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return FilterChip(
              label: Text(option),
              selected: false, // You would track selection state
              onSelected: (selected) {
                // Handle filter selection
              },
              backgroundColor: Colors.grey[100],
              selectedColor: const Color(0xFF4ECDC4).withOpacity(0.2),
              labelStyle: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}