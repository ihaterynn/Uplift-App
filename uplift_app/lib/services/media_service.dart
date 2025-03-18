import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'supabase_service.dart';

class MediaService {
  final SupabaseService _supabaseService = SupabaseService();
  final Uuid _uuid = const Uuid();
  
  // Upload image to Supabase Storage
  Future<String?> uploadImage(File file, String storagePath) async {
    try {
      final String fileExtension = path.extension(file.path);
      final String fileName = '${_uuid.v4()}$fileExtension';
      final String fullPath = '$storagePath/$fileName';
      
      // Upload the file
      await _supabaseService.client
          .storage
          .from('media')
          .upload(fullPath, file);
      
      // Get the public URL
      final String publicUrl = _supabaseService.client
          .storage
          .from('media')
          .getPublicUrl(fullPath);
      
      return publicUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
  
  // Upload multiple images and return their URLs
  Future<List<String>> uploadImages(List<File> files, String storagePath) async {
    List<String> urls = [];
    
    for (var file in files) {
      final url = await uploadImage(file, storagePath);
      if (url != null) {
        urls.add(url);
      }
    }
    
    return urls;
  }
  
  // Upload video to Supabase Storage
  Future<String?> uploadVideo(File file, String storagePath) async {
    try {
      final String fileExtension = path.extension(file.path);
      final String fileName = '${_uuid.v4()}$fileExtension';
      final String fullPath = '$storagePath/$fileName';
      
      // Upload the file
      await _supabaseService.client
          .storage
          .from('videos')
          .upload(fullPath, file);
      
      // Get the public URL
      final String publicUrl = _supabaseService.client
          .storage
          .from('videos')
          .getPublicUrl(fullPath);
      
      return publicUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }
  
  // Delete media from storage
  Future<bool> deleteMedia(String url) async {
    try {
      // Extract path from URL
      final Uri uri = Uri.parse(url);
      final List<String> segments = uri.pathSegments;
      
      // Get bucket and path
      String bucket = 'media';
      if (url.contains('videos')) {
        bucket = 'videos';
      }
      
      // Skip the first segments which are likely 'storage/v1/object/public'
      final String path = segments.sublist(4).join('/');
      
      await _supabaseService.client
          .storage
          .from(bucket)
          .remove([path]);
      
      return true;
    } catch (e) {
      print('Error deleting media: $e');
      return false;
    }
  }
}