import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/jobs/job_details.dart';
import 'screens/jobs/job_list.dart';
import 'screens/p2p/create_peer_job_post.dart';
import 'screens/p2p/peer_job_details.dart';
import 'screens/p2p/edit_peer_job.dart'; // Import the new edit screen
import 'screens/wallet/wallet_screen.dart';
import 'screens/wallet/transaction_history.dart';
import 'screens/wallet/deposit_screen.dart';
import 'screens/wallet/withdraw_screen.dart';
import 'screens/post_screen.dart';
import 'services/supabase_service.dart';
import 'services/job_service.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables
  await dotenv.load(fileName: ".env");
  // Initialize Supabase
  await SupabaseService().initialize();
  // Initialize mock job data for development
  JobService().initializeMockJobs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uplift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF4ECDC4),
          secondary: const Color(0xFF56E39F),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/job-list': (context) => const JobListScreen(),
        '/create-peer-job': (context) => const EditPeerJob(), // Use EditPeerJob without a jobId for creation
        '/wallet': (context) => const WalletScreen(),
        '/wallet/transactions': (context) => const TransactionHistoryScreen(),
        '/wallet/deposit': (context) => const DepositScreen(),
        '/wallet/withdraw': (context) => const WithdrawScreen(),
        '/post': (context) => const PostScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/job-details') {
          final String jobId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => JobDetailScreen(jobId: jobId),
          );
        } else if (settings.name == '/peer-job-details') {
          final String jobId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => PeerJobDetails(jobId: jobId),
          );
        } else if (settings.name == '/edit-peer-job') {
          final String jobId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => EditPeerJob(jobId: jobId),
          );
        }
        return null;
      },
    );
  }
}