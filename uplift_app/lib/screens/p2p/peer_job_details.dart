// peer_job_details.dart
import 'package:flutter/material.dart';
import '../../models/peer_job.dart';
import '../../services/database_service.dart';

class PeerJobDetails extends StatelessWidget {
  final String jobId;

  const PeerJobDetails({Key? key, required this.jobId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DatabaseService _databaseService = DatabaseService();

    return FutureBuilder<PeerJob?>(
      future: _databaseService.getPeerJobById(jobId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(child: Text("Error fetching service details.")),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text("Service not found.")),
          );
        } else {
          final job = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text(job.title),
              backgroundColor: const Color(0xFF4ECDC4),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    job.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 4),
                      Text(job.isRemote ? "Remote" : job.location),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.attach_money),
                      const SizedBox(width: 4),
                      Text("${job.currency} ${job.budget.toString()} (${job.rateType})"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // You can add more details (skills, posted date, etc.) here.
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
