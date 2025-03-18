import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // Singleton pattern
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // Supabase client
  late SupabaseClient _client;
  SupabaseClient get client => _client;

  // Initialize Supabase
  Future<void> initialize() async {
    // Get Supabase URL and anonymous key from .env file
    final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
      throw Exception('Supabase credentials not found. Please check your .env file.');
    }

    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
      debug: true, // Set to false in production
    );

    // Get the client
    _client = Supabase.instance.client;
    
    print('SupabaseService initialized successfully');
  }

  

  // Get current user ID
  String? get currentUserId => _client.auth.currentUser?.id;

  // Check if user is authenticated
  bool get isAuthenticated => _client.auth.currentUser != null;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  // Reset password
  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }
  
  // Update user password
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _client.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );
  }
  
  // Update user data
  Future<UserResponse> updateUserData(Map<String, dynamic> userData) async {
    return await _client.auth.updateUser(
      UserAttributes(
        data: userData,
      ),
    );
  }
  
  // Get user profile from Auth
  User? get currentUser => _client.auth.currentUser;
  
  // Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  // Listen for user changes
  Stream<User?> get userChanges => _client.auth.onAuthStateChange.map((event) => event.session?.user);
}