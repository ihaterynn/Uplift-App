import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/job.dart';
import '../models/peer_job.dart';
import '../models/user.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../models/payment_method.dart';
import 'supabase_service.dart';

class DatabaseService {
  final SupabaseService _supabaseService = SupabaseService();

  // Get Supabase client
  SupabaseClient get _client => _supabaseService.client;

  // USER METHODS

  // Create or update user profile
  Future<User?> upsertUser(User user) async {
    try {
      final response =
          await _client.from('users').upsert(user.toJson()).select().single();

      return User.fromJson(response);
    } catch (e) {
      print('Error upserting user: $e');
      return null;
    }
  }

  // Get user by ID
  Future<User?> getUserById(String userId) async {
    try {
      final response =
          await _client.from('users').select().eq('id', userId).single();

      return User.fromJson(response);
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // JOB METHODS

  // Get all jobs with pagination
  Future<List<Job>> getJobs({int page = 1, int limit = 10}) async {
    try {
      final response = await _supabaseService.client
          .from('jobs')
          .select('*, job_skills(skill_id, skills(name))')
          .range((page - 1) * limit, page * limit - 1)
          .order('posted_date', ascending: false);

      return response.map<Job>((job) => Job.fromJson(job)).toList();
    } catch (e) {
      print('Error getting jobs: $e');
      return [];
    }
  }

  // Get job by ID
  Future<Job?> getJobById(String jobId) async {
    try {
      final response = await _client
          .from('jobs')
          .select('*, job_skills(skill_id, skills(name))')
          .eq('id', jobId)
          .single();

      return Job.fromJson(response);
    } catch (e) {
      print('Error getting job: $e');
      return null;
    }
  }

  // Search jobs
  Future<List<Job>> searchJobs(String query) async {
    try {
      final response = await _client
          .from('jobs')
          .select('*, job_skills(skill_id, skills(name))')
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('posted_date', ascending: false);

      return response.map<Job>((job) => Job.fromJson(job)).toList();
    } catch (e) {
      print('Error searching jobs: $e');
      return [];
    }
  }

  // PEER JOB METHODS

  // Get all peer jobs
  Future<List<PeerJob>> getPeerJobs({int page = 1, int limit = 10}) async {
    try {
      final response = await _client
          .from('peer_jobs')
          .select('*, users(id, full_name, profile_picture)')
          .range((page - 1) * limit, page * limit - 1)
          .order('posted_date', ascending: false);

      return response.map<PeerJob>((job) => PeerJob.fromJson(job)).toList();
    } catch (e) {
      print('Error getting peer jobs: $e');
      return [];
    }
  }

  // Create a new peer job
  // Future<PeerJob?> createPeerJob(PeerJob peerJob) async {
  //   try {
  //     // First insert the basic peer job data
  //     final response = await _client
  //         .from('peer_jobs')
  //         .insert({
  //           'title': peerJob.title,
  //           'description': peerJob.description,
  //           'user_id': peerJob.userId,
  //           'location': peerJob.location,
  //           'budget': peerJob.budget,
  //           'currency': peerJob.currency,
  //           'timeframe': peerJob.timeframe,
  //           'posted_date': DateTime.now().toIso8601String(),
  //           'status': 'open',
  //           'is_remote': peerJob.isRemote,
  //         })
  //         .select()
  //         .single();

  //     final String jobId = response['id'];

  //     // Then add skills using the join table
  //     if (peerJob.skills.isNotEmpty) {
  //       // For each skill, first check if it exists in the skills table
  //       for (String skillName in peerJob.skills) {
  //         // Try to find the skill
  //         final skillResponse = await _client
  //             .from('skills')
  //             .select()
  //             .eq('name', skillName)
  //             .maybeSingle();

  //         String skillId;

  //         // If skill doesn't exist, create it
  //         if (skillResponse == null) {
  //           final newSkill = await _client
  //               .from('skills')
  //               .insert({'name': skillName})
  //               .select()
  //               .single();

  //           skillId = newSkill['id'];
  //         } else {
  //           skillId = skillResponse['id'];
  //         }

  //         // Create the join between peer job and skill
  //         await _client
  //             .from('peer_job_skills')
  //             .insert({
  //               'peer_job_id': jobId,
  //               'skill_id': skillId,
  //             });
  //       }
  //     }

  //     // Return the created job with complete data
  //     return getPeerJobById(jobId);
  //   } catch (e) {
  //     print('Error creating peer job: $e');
  //     return null;
  //   }
  // }
  Future<Map<String, dynamic>?> createPeerJob(PeerJob job) async {
    final response =
        await _supabaseService.client.from('peer_jobs').insert(job.toMap());

    // Check if response is null
    if (response == null) {
      print(
          "Error: Response is null. Check your Supabase client initialization.");
      return null;
    }

    // Now check if there is an error in the response
    if (response.error != null) {
      print('Error inserting job: ${response.error!.message}');
      return null;
    }

    return response.data;
  }

  // Get peer job by ID (helper method)
  Future<PeerJob?> getPeerJobById(String jobId) async {
    try {
      final response = await _client
          .from('peer_jobs')
          .select('*')
          .eq('id', jobId)
          .single();

      return PeerJob.fromJson(response);
    } catch (e) {
      print('Error getting peer job: $e');
      return null;
    }
  }

  // WALLET METHODS

  // Get user wallet
  Future<Wallet?> getUserWallet(String userId) async {
    try {
      final response =
          await _client.from('wallets').select().eq('user_id', userId).single();

      return Wallet.fromJson(response);
    } catch (e) {
      print('Error getting wallet: $e');
      return null;
    }
  }

  // Get transaction history
  Future<List<Transaction>> getTransactions(String walletId,
      {int limit = 20}) async {
    try {
      final response = await _client
          .from('transactions')
          .select()
          .eq('wallet_id', walletId)
          .order('timestamp', ascending: false)
          .limit(limit);

      return response
          .map<Transaction>((tx) => Transaction.fromJson(tx))
          .toList();
    } catch (e) {
      print('Error getting transactions: $e');
      return [];
    }
  }

  // PAYMENT METHODS

  // Get user payment methods
  Future<List<PaymentMethod>> getUserPaymentMethods(String userId) async {
    try {
      final response = await _client
          .from('payment_methods')
          .select()
          .eq('user_id', userId)
          .order('is_default', ascending: false);

      return response
          .map<PaymentMethod>((pm) => PaymentMethod.fromJson(pm))
          .toList();
    } catch (e) {
      print('Error getting payment methods: $e');
      return [];
    }
  }

  // Add payment method
  Future<PaymentMethod?> addPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      final response = await _client
          .from('payment_methods')
          .insert(paymentMethod.toJson())
          .select()
          .single();

      return PaymentMethod.fromJson(response);
    } catch (e) {
      print('Error adding payment method: $e');
      return null;
    }
  }

  // Set default payment method
  Future<bool> setDefaultPaymentMethod(
      String userId, String paymentMethodId) async {
    try {
      // First unset all default payment methods for this user
      await _client
          .from('payment_methods')
          .update({'is_default': false}).eq('user_id', userId);

      // Then set the selected one as default
      await _client
          .from('payment_methods')
          .update({'is_default': true}).eq('id', paymentMethodId);

      return true;
    } catch (e) {
      print('Error setting default payment method: $e');
      return false;
    }
  }

  // APPLICATION METHODS

  // Apply for a job
  Future<bool> applyForJob(
      String userId, String jobId, Map<String, dynamic> applicationData) async {
    try {
      await _client.from('applications').insert({
        'user_id': userId,
        'job_id': jobId,
        'status': 'pending',
        'application_data': applicationData,
        'applied_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error applying for job: $e');
      return false;
    }
  }

  // Get user applications
  Future<List<Map<String, dynamic>>> getUserApplications(String userId) async {
    try {
      final response = await _client
          .from('applications')
          .select('*, jobs(id, title, company, location)')
          .eq('user_id', userId)
          .order('applied_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting applications: $e');
      return [];
    }
  }
}
