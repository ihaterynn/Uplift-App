// peer_job_list.dart
import 'package:flutter/material.dart';
import '../../models/peer_job.dart';
import '../../services/database_service.dart';
import 'peer_job_details.dart';
import '../../widgets/peer_job_card.dart';

class PeerJobList extends StatefulWidget {
  const PeerJobList({Key? key}) : super(key: key);

  @override
  State<PeerJobList> createState() => _PeerJobListState();
}

class _PeerJobListState extends State<PeerJobList> {
  final DatabaseService _databaseService = DatabaseService();

  // Simple helper to calculate "time ago" text
  String _timeAgo(DateTime postedDate) {
    final duration = DateTime.now().difference(postedDate);
    if (duration.inDays > 0) return "${duration.inDays}d ago";
    if (duration.inHours > 0) return "${duration.inHours}h ago";
    if (duration.inMinutes > 0) return "${duration.inMinutes}m ago";
    return "Just now";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PeerJob>>(
      future: _databaseService.getPeerJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error fetching services."));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No services available."));
        } else {
          final peerJobs = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: peerJobs.length,
            itemBuilder: (context, index) {
              final job = peerJobs[index];
              // Map the PeerJob fields to the PeerJobCard parameters.
              // For example, if you later add the provider's name to your PeerJob model,
              // replace job.userId with that field.
              final String provider = job.userId;
              final String location = job.isRemote ? "Remote" : job.location;
              final String rate = "${job.currency} ${job.budget}";
              final String timePosted = _timeAgo(job.postedDate);
              final double rating =
                  0.0; // Set a default as rating isn't in the PeerJob model

              return PeerJobCard(
                title: job.title,
                provider: provider,
                location: location,
                skills: job.skills,
                rate: rate,
                timePosted: timePosted,
                rating: rating,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/peer-job-details',
                    arguments: job.id,
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
