import 'package:flutter/material.dart';
import '../widgets/uplift_app_bar.dart';
import '../widgets/uplift_bottom_nav.dart';
import '../services/supabase_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isCompany = false;
  
  // Development mode flag - set to true to bypass authentication check
  final bool _devMode = true;
  
  @override
  void initState() {
    super.initState();
    _checkUserType();
  }
  
  Future<void> _checkUserType() async {
    // Check if user is logged in
    if (_supabaseService.isAuthenticated || _devMode) {
      try {
        // In dev mode, we can set default values
        if (_devMode) {
          setState(() {
            _isCompany = false; // For testing regular user view
            // _isCompany = true; // Uncomment to test company view
          });
          return;
        }
        
        // Normal authentication flow
        final userId = _supabaseService.currentUserId;
        if (userId != null) {
          // You would typically check the user type from your database
          setState(() {
            _isCompany = false; // Change based on user type stored in database
          });
        }
      } catch (e) {
        print('Error fetching user type: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: UpliftAppBar(
        showLogo: false,
        showBackButton: true,
        additionalActions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                "Create a Post",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
      body: (_supabaseService.isAuthenticated || _devMode)
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What would you like to post?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Choose the type of post you want to create",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Post options
                  _buildPostOption(
                    title: "Student Service",
                    subtitle: "Offer your skills to fellow students and earn money",
                    icon: Icons.school,
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        '/create-peer-job',
                      );
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Company job posting option (conditionally visible)
                  if (_isCompany)
                    _buildPostOption(
                      title: "Company Job Posting",
                      subtitle: "Post a job opening at your company",
                      icon: Icons.business,
                      onTap: () {
                        Navigator.pushNamed(
                          context, 
                          '/create-job',
                        );
                      },
                    ),
                  
                  if (!_isCompany)
                    _buildPostOption(
                      title: "Job Posting Request",
                      subtitle: "Request to post a job (requires verification)",
                      icon: Icons.business,
                      onTap: () {
                        _showCompanyVerificationDialog();
                      },
                    ),
                ],
              ),
            )
          : _buildLoginPrompt(),
      bottomNavigationBar: UpliftBottomNav(
        currentIndex: 2, // Post tab is selected
        onTap: (index) {
          if (index != 2) { // If not the current tab
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/discover');
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

  Widget _buildPostOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF4ECDC4),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              "Login Required",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Please login to create a post",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4ECDC4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Login / Sign Up",
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
    );
  }
  
  void _showCompanyVerificationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Company Verification Required"),
          content: const Text(
            "To post job listings, you need to verify your company profile. "
            "This helps us maintain a trusted job marketplace for our users."
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/company-verification');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4ECDC4),
              ),
              child: const Text("Start Verification"),
            ),
          ],
        );
      },
    );
  }
}