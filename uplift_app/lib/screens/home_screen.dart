// home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/uplift_app_bar.dart';
import '../widgets/uplift_bottom_nav.dart';

// Import your new modular card widgets
import '../widgets/featured_job_card.dart';
import '../screens/p2p/peer_job_list.dart'; 

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
          // Search bar remains unchanged
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
                // Job Listings Tab using modular widgets
                _buildJobListingsTab(),
                
                // Student Services Tab (Peer Job list)
                const PeerJobList(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: UpliftBottomNav(
        currentIndex: 0,
        onTap: (index) {
          if (index != 0) {
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
  
  Widget _buildJobListingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Section Title
        _buildSectionTitle("Featured Jobs"),
        const SizedBox(height: 12),
        // Use the modular FeaturedJobCard widget
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              FeaturedJobCard(
                title: "Software Engineer",
                company: "Google",
                location: "Mountain View, CA",
                skills: ["Flutter", "Dart", "Firebase"],
                salary: "\$120,000 - \$150,000",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/job-details',
                    arguments: "google-software-engineer",
                  );
                },
              ),
              FeaturedJobCard(
                title: "Product Designer",
                company: "Apple",
                location: "Cupertino, CA",
                skills: ["UI/UX", "Figma", "Prototyping"],
                salary: "\$110,000 - \$140,000",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/job-details',
                    arguments: "apple-product-designer",
                  );
                },
              ),
              FeaturedJobCard(
                title: "Data Scientist",
                company: "Netflix",
                location: "Los Gatos, CA",
                skills: ["Python", "ML", "SQL"],
                salary: "\$130,000 - \$160,000",
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/job-details',
                    arguments: "netflix-data-scientist",
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Continue with your other sections (e.g., Recommended, Recent Jobs) using similar modular widgets...
        _buildSectionTitle("Recommended for You"),
        const SizedBox(height: 12),
        // Here you could use your existing JobCard widget
        // Example:
        // JobCard(job: someJobModel, onTap: () => Navigator.pushNamed(...)),
      ],
    );
  }
  
  Widget _buildSectionTitle(String title) {
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
}
