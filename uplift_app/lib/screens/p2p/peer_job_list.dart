// peer_job_list.dart
import 'package:flutter/material.dart';
import '../../models/peer_job.dart';
import '../../services/database_service.dart';
import 'peer_job_details.dart';

class PeerJobList extends StatefulWidget {
  const PeerJobList({Key? key}) : super(key: key);

  @override
  State<PeerJobList> createState() => _PeerJobListState();
}

class _PeerJobListState extends State<PeerJobList> {
  final DatabaseService _databaseService = DatabaseService();

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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PeerJobDetails(jobId: job.id),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          job.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.attach_money, size: 16),
                            const SizedBox(width: 4),
                            Text("${job.currency} ${job.budget.toString()}"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(job.isRemote ? "Remote" : job.location),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
