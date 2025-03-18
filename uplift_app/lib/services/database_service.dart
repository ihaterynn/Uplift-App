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
  Future<Map<String, dynamic>?> createPeerJob(PeerJob job) async {
    try {
      final response = await _supabaseService.client
          .from('peer_jobs')
          .insert(job.toMap())
          .select()
          .single();

      return response;
    } catch (e) {
      print('Error creating peer job: $e');
      return null;
    }
  }

  // Update an existing peer job
  Future<Map<String, dynamic>?> updatePeerJob(PeerJob job) async {
    try {
      final response = await _supabaseService.client
          .from('peer_jobs')
          .update(job.toMap())
          .eq('id', job.id)
          .select()
          .single();

      return response;
    } catch (e) {
      print('Error updating peer job: $e');
      return null;
    }
  }

  // Get peer job by ID 
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

  // Increment view count for a peer job
  //Future<bool> incrementPeerJobViews(String jobId) async {
    //try {
      //await _client.rpc('increment_peer_job_views', params: {'job_id': jobId});
      //return true;
    //} catch (e) {
      //print('Error incrementing peer job views: $e');
      //return false;
    //}
  //}

  // Add a review for a peer job
  Future<bool> addPeerJobReview(String jobId, String reviewerId, int rating, String comment) async {
    try {
      await _client.from('peer_job_reviews').insert({
        'peer_job_id': jobId,
        'reviewer_id': reviewerId,
        'rating': rating,
        'comment': comment,
      });
      return true;
    } catch (e) {
      print('Error adding peer job review: $e');
      return false;
    }
  }

  // Get reviews for a peer job
  //Future<List<Map<String, dynamic>>> getPeerJobReviews(String jobId) async {
    //try {
      //final response = await _client
          //.from('peer_job_reviews')
          //.select('*, users!reviewer_id(full_name, profile_picture)')
          //.eq('peer_job_id', jobId)
          //.order('created_at', ascending: false);

      //return List<Map<String, dynamic>>.from(response);
    //} catch (e) {
      //print('Error getting peer job reviews: $e');
      //return [];
    //}
  //}

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
  Future<List<Transaction>> getTransactions(String walletId, {int limit = 20}) async {
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