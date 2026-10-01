import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../messages/chat/chat_screen.dart';
import 'musician_profile_screen.dart';
import 'widgets/hire_musician_dialog.dart';
import 'payment_screen.dart';

class ApplicantModel {
  final String id;
  final String musicianId;
  final String name;
  final String imagePath;
  final double rating;
  final int reviewCount;
  final String location;
  final List<String> genres;
  final String status;
  final bool isFeatured;
  final String? previousStatus;
  final String? proposedRate;
  final String? coverMessage;

  const ApplicantModel({
    required this.id,
    required this.musicianId,
    required this.name,
    required this.imagePath,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.genres,
    required this.status,
    this.isFeatured = false,
    this.previousStatus,
    this.proposedRate,
    this.coverMessage,
  });
}

class ApplicantsScreen extends StatefulWidget {
  final String gigId;
  final String gigTitle;
  final String gigBudget;
  final String gigDate;
  final String gigTime;
  final String? gigDuration;
  final String? location;
  final String? organizerName;

  const ApplicantsScreen({
    super.key, 
    required this.gigId, 
    required this.gigTitle, 
    required this.gigBudget,
    required this.gigDate,
    required this.gigTime,
    this.gigDuration,
    this.location,
    this.organizerName,
  });

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  @override
  Widget build(BuildContext context) {
    final dummyApplicants = [
      const ApplicantModel(
        id: 'app_1',
        musicianId: 'musician_sarah',
        name: 'Sarah Johnson',
        imagePath: 'assets/chat_image1.png',
        rating: 4.9,
        reviewCount: 24,
        location: 'New York, NY',
        genres: ['Jazz', 'Blues'],
        status: 'pending',
        proposedRate: '750',
      ),
      const ApplicantModel(
        id: 'app_2',
        musicianId: 'musician_michael',
        name: 'Michael Smith',
        imagePath: 'assets/portfolio_image1.png',
        rating: 4.7,
        reviewCount: 30,
        location: 'Los Angeles, CA',
        genres: ['Rock', 'Pop'],
        status: 'pending',
      ),
      const ApplicantModel(
        id: 'app_3',
        musicianId: 'musician_emily',
        name: 'Emily Davis',
        imagePath: 'assets/portfolio_image2.png',
        rating: 4.8,
        reviewCount: 18,
        location: 'Chicago, IL',
        genres: ['Classical', 'Folk'],
        status: 'pending',
      ),
      const ApplicantModel(
        id: 'app_4',
        musicianId: 'musician_david',
        name: 'David Lee',
        imagePath: 'assets/portfolio_image3.png',
        rating: 4.6,
        reviewCount: 20,
        location: 'Houston, TX',
        genres: ['Hip-Hop', 'R&B'],
        status: 'pending',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0F),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 26),
          ),
        ),
        title: const Text(
          'Applicants',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3 Applications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Review and hire musicians for your gig',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: dummyApplicants.length,
                itemBuilder: (context, index) {
                  final applicant = dummyApplicants[index];
                  return _ApplicantCard(
                    applicant: applicant,
                    gigId: widget.gigId,
                    gigTitle: widget.gigTitle,
                    gigBudget: widget.gigBudget,
                    gigDate: widget.gigDate,
                    gigTime: widget.gigTime,
                    gigDuration: widget.gigDuration,
                    location: widget.location,
                    organizerName: widget.organizerName,
                    onRefresh: () => setState(() {}),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicantCard extends StatelessWidget {
  final ApplicantModel applicant;
  final String gigId;
  final String gigTitle;
  final String gigBudget;
  final String gigDate;
  final String gigTime;
  final String? gigDuration;
  final String? location;
  final String? organizerName;
  final VoidCallback onRefresh;

  const _ApplicantCard({
    required this.applicant,
    required this.gigId,
    required this.gigTitle,
    required this.gigBudget,
    required this.gigDate,
    required this.gigTime,
    this.gigDuration,
    this.location,
    this.organizerName,
    required this.onRefresh,
  });

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: _isNetworkImage(applicant.imagePath)
                    ? Image.network(
                        applicant.imagePath,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFF2A2A2F),
                        ),
                      )
                    : Image.asset(
                        applicant.imagePath,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFF2A2A2F),
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFA2F301), size: 15),
                        const SizedBox(width: 4),
                        Text(
                          applicant.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${applicant.reviewCount})',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/location_pointer.svg',
                          width: 12,
                          height: 12,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF888888),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          applicant.location,
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: applicant.genres
                          .map((g) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2F),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  g,
                                  style: const TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 11,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MusicianProfileScreen(
                        musicianId: applicant.musicianId,
                        gigId: gigId,
                        gigTitle: gigTitle,
                        gigBudget: gigBudget,
                        gigDate: gigDate,
                        gigTime: gigTime,
                        gigDuration: gigDuration,
                        proposedRate: applicant.proposedRate,
                        coverMessage: applicant.coverMessage,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222226),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'View Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatId: 'chat_${applicant.musicianId}',
                        otherUserId: applicant.musicianId,
                        name: applicant.name,
                        imagePath: applicant.imagePath,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF222226),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Message',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HireMusicianDialog.show(
                      context,
                      name: applicant.name,
                      imagePath: applicant.imagePath,
                      rating: applicant.rating,
                      reviewCount: applicant.reviewCount,
                      location: applicant.location,
                      rate: applicant.proposedRate ?? '750',
                      onConfirm: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            musicianId: applicant.musicianId,
                            musicianName: applicant.name,
                            musicianImage: applicant.imagePath,
                            gigId: gigId.isNotEmpty ? gigId : 'gig_1',
                            gigTitle: gigTitle.isNotEmpty ? gigTitle : 'Jazz Night - Friday',
                            gigDate: gigDate.isNotEmpty ? gigDate : 'Feb 15, 2026',
                            gigTime: gigTime.isNotEmpty ? gigTime : '8:00 PM - 11:00 PM',
                            gigDuration: gigDuration ?? '3 hours',
                            amount: 750,
                            walletBalance: 2500,
                            location: location ?? 'Blue Note Jazz Club, NYC',
                            organizerName: organizerName ?? 'Blue Note Entertainment',
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA2F301),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Hire',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
