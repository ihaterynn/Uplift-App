import 'package:flutter/material.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  final bool isCompact;

  const JobCard({
    Key? key,
    required this.job,
    required this.onTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Using the new getCompanyLogo method if available, otherwise fallback to the current implementation
                  job.logoUrl != null
                      ? job.getCompanyLogo(size: 50, fontSize: 24)
                      : Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[100],
                          ),
                          child: Center(
                            child: Text(
                              job.company.isNotEmpty ? job.company[0] : '?',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4ECDC4),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              job.company,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text("•"),
                            const SizedBox(width: 4),
                            Text(
                              job.location,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        job.isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: job.isSaved ? const Color(0xFF4ECDC4) : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.timeAgo,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (!isCompact) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    // Use salaryRange if the method is available, otherwise use formattedSalary
                    Text(
                      job.salaryRange ?? job.formattedSalary,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Use typeIcon if available, otherwise use work_outline
                    Icon(job.typeIcon ?? Icons.work_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    // Use formattedEmploymentType if available, otherwise use employmentType directly
                    Text(
                      job.formattedEmploymentType ?? job.employmentType,
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.skills.take(3).map((skill) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4ECDC4).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      skill,
                      style: const TextStyle(
                        color: Color(0xFF4ECDC4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )).toList(),
                ),
                // Show +X more if there are more than 3 skills
                if (job.skills.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "+${job.skills.length - 3} more",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                if (job.matchScore != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF4ECDC4), Color(0xFF56E39F)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: const Icon(
                            Icons.thumb_up,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${job.matchScore!.toInt()}% Match",
                          style: const TextStyle(
                            color: Color(0xFF4ECDC4),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Add these extension methods to handle cases where the new methods might not be available yet
extension JobExtensions on Job {
  String? get salaryRange {
    try {
      final minSalary = (salary * 0.9).toInt();
      final maxSalary = (salary * 1.1).toInt();
      
      if (currency == 'USD') {
        return '\$${minSalary.toString()} - \$${maxSalary.toString()}';
      } else {
        return '${minSalary.toString()} - ${maxSalary.toString()} $currency';
      }
    } catch (e) {
      return null;
    }
  }
  
  String? get formattedEmploymentType {
    try {
      switch (employmentType.toLowerCase()) {
        case 'full-time':
          return 'Full-time';
        case 'part-time':
          return 'Part-time';
        case 'contract':
          return 'Contract';
        case 'internship':
          return 'Internship';
        case 'freelance':
          return 'Freelance';
        default:
          return employmentType;
      }
    } catch (e) {
      return null;
    }
  }
  
  IconData? get typeIcon {
    try {
      switch (employmentType.toLowerCase()) {
        case 'full-time':
          return Icons.work;
        case 'part-time':
          return Icons.work_outline;
        case 'contract':
          return Icons.assignment;
        case 'internship':
          return Icons.school;
        case 'freelance':
          return Icons.person;
        default:
          return Icons.business_center;
      }
    } catch (e) {
      return null;
    }
  }
  
  Widget getCompanyLogo({double size = 50.0, double fontSize = 24.0}) {
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          logoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _getDefaultLogo(size, fontSize);
          },
        ),
      );
    } else {
      return _getDefaultLogo(size, fontSize);
    }
  }
  
  Widget _getDefaultLogo(double size, double fontSize) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Center(
        child: Text(
          company.isNotEmpty ? company[0] : '?',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4ECDC4),
          ),
        ),
      ),
    );
  }
}