import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../models/gig.dart' as gig_model;
import 'widgets/gigs_filter_tabs.dart';
import 'widgets/gig_card.dart' as gig_card;
import 'post_gig_screen.dart';
import '../../services/auth_service.dart';
import '../home/widgets/home_header.dart';

import 'package:onlygigz_organizer/services/api_service.dart';

class GigsScreen extends StatefulWidget {
  const GigsScreen({super.key});

  @override
  State<GigsScreen> createState() => _GigsScreenState();
}

class _GigsScreenState extends State<GigsScreen> {
  final ApiService _apiService = ApiService();
  String _selectedFilter = 'All';
  Key _refreshKey = UniqueKey();

  void _refreshData() {
    setState(() => _refreshKey = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Provider.of<AuthService>(context).user?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... (header section unchanged)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0x4DA2F301), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 16),
                  GigsFilterTabs(
                    selected: _selectedFilter,
                    onSelected: (val) => setState(() => _selectedFilter = val),
                  ),
                ],
              ),
            ),

            // My Gigs title + Post Gig button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Gigs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                   ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PostGigScreen(returnToGigs: true)),
                      );
                      _refreshData();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFA2F301),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.black, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Post Gig',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Gig cards list - Direct Render
            Expanded(
              child: Builder(
                builder: (context) {
                  final dummyGigs = [
                    gig_model.GigModel(
                      gigId: 'dummy_gig_1',
                      title: 'Jazz Night - Friday',
                      genres: ['Active'],
                      location: 'Blue Note Jazz Club, NYC',
                      date: 'Dec 24, 2025',
                      time: '8:00 PM',
                      budget: '\$800 - \$1,200',
                      description: 'Looking for a live jazz band or pianist for Friday night.',
                      status: 'active',
                      imageUrl: 'assets/gig_image1.jpg',
                      organizerId: currentUserId ?? 'current_user',
                      organizerName: 'Alex Chen',
                      createdAt: DateTime.now(),
                    ),
                    gig_model.GigModel(
                      gigId: 'dummy_gig_2',
                      title: 'Rock Fest - Saturday',
                      genres: ['Active'],
                      location: 'Madison Square Garden, NYC',
                      date: 'Jan 15, 2026',
                      time: '7:00 PM',
                      budget: '\$1,000 - \$1,500',
                      description: 'High-energy rock band needed for Saturday night festival.',
                      status: 'active',
                      imageUrl: 'assets/gig_image2.jpg',
                      organizerId: currentUserId ?? 'current_user',
                      organizerName: 'Alex Chen',
                      createdAt: DateTime.now(),
                    ),
                  ];

                  final filteredGigs = dummyGigs.where((gig) {
                    if (_selectedFilter == 'All') return true;
                    if (_selectedFilter == 'Active') return gig.status == 'open' || gig.status == 'active';
                    if (_selectedFilter == 'Closed') return gig.status == 'closed';
                    if (_selectedFilter == 'Completed') return gig.status == 'completed';
                    return true;
                  }).toList();

                  if (filteredGigs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFF666666), size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'No $_selectedFilter gigs found.',
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: filteredGigs.length,
                    itemBuilder: (context, index) {
                      final gig = filteredGigs[index];
                      return gig_card.GigCard(gig: gig);
                    },
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
