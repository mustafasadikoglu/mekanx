import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme.dart';
import '../../../discover/data/models/venue_model.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  // Mock Voting Percentages
  final Map<String, int> _votes = {
    '1': 45, // Mavrik
    '2': 35, // Basta
    '4': 20, // Vaha
  };

  String? _myVoteId;
  int _totalVotes = 20;

  void _castVote(String venueId) {
    setState(() {
      if (_myVoteId == venueId) {
        // Remove vote
        _votes[venueId] = (_votes[venueId] ?? 1) - 1;
        _myVoteId = null;
        _totalVotes--;
      } else {
        // Change or add vote
        if (_myVoteId != null) {
          _votes[_myVoteId!] = (_votes[_myVoteId!] ?? 1) - 1;
        } else {
          _totalVotes++;
        }
        _votes[venueId] = (_votes[venueId] ?? 0) + 1;
        _myVoteId = venueId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ambient Glow Background
          Positioned(
            bottom: 100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentNeon.withOpacity(0.06),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Nav
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: AppTheme.glassDecoration(borderRadius: 12),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Text(
                          'Grup Planı',
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer to balance leading
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Plan Title Box
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: AppTheme.glassDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentNeon.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.celebration, color: AppTheme.accentNeon, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Hafta Sonu Buluşması',
                                style: GoogleFonts.outfit(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Details
                          _buildDetailRow(Icons.calendar_today, 'Tarih', 'Cumartesi, 4 Temmuz • 14:00'),
                          const SizedBox(height: 8),
                          _buildDetailRow(Icons.people, 'Grup Üyeleri', 'Sen, Caner, Selin, Ece, Kaan (+2)'),
                          
                          const SizedBox(height: 16),
                          // Avatar Stack
                          _buildAvatarStack(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Voting Header
                    Text(
                      'Mekan Seçimi Oylaması',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gitmek istediğin mekanın üzerine dokunarak oy ver.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),

                    // Voting Cards List
                    ..._votes.keys.map((id) {
                      final venue = mockVenues.firstWhere((v) => v.id == id);
                      final voteCount = _votes[id] ?? 0;
                      final percentage = _totalVotes > 0 ? ((voteCount / _totalVotes) * 100).round() : 0;
                      final hasMyVote = _myVoteId == id;
                      return _buildVoteCard(context, venue, percentage, voteCount, hasMyVote);
                    }),
                    const SizedBox(height: 30),

                    // Chat/Feedback Teaser
                    Text(
                      'Grup Sohbeti',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    _buildCommentBubble('Caner', 'Mavrik\'in internet hızı efsane, orada buluşalım!', '10 dk önce', true),
                    const SizedBox(height: 10),
                    _buildCommentBubble('Selin', 'Vaha\'nın bitkileri çok rahatlatıcı görünüyor.', '5 dk önce', false),
                    
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Bar Action
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppTheme.secondaryNeon),
                          const SizedBox(width: 10),
                          Text(
                            'Plan kaydedildi ve arkadaşlarına gönderildi!',
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      backgroundColor: AppTheme.surface,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Planı Tamamla ve Paylaş',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppTheme.textSecondary),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarStack() {
    final List<String> avatars = [
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop', // You
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop', // Caner
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop', // Selin
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200&auto=format&fit=crop', // Ece
    ];

    return Row(
      children: [
        SizedBox(
          width: 130,
          height: 32,
          child: Stack(
            children: List.generate(avatars.length + 1, (index) {
              if (index == avatars.length) {
                return Positioned(
                  left: index * 22.0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryNeon,
                      border: Border.all(color: AppTheme.surface, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '+3',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return Positioned(
                left: index * 22.0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.surface, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(avatars[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.04),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Row(
              children: [
                const Icon(Icons.add, size: 14, color: AppTheme.secondaryNeon),
                const SizedBox(width: 4),
                Text(
                  'Davet Et',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.secondaryNeon),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoteCard(
    BuildContext context,
    VenueModel venue,
    int percentage,
    int voteCount,
    bool hasMyVote,
  ) {
    return GestureDetector(
      onTap: () => _castVote(venue.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.02),
          border: Border.all(
            color: hasMyVote ? AppTheme.secondaryNeon.withOpacity(0.4) : Colors.white.withOpacity(0.04),
            width: hasMyVote ? 2.0 : 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Animated Progress Bar
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (hasMyVote ? AppTheme.secondaryNeon : AppTheme.primaryNeon).withOpacity(0.05),
                          (hasMyVote ? AppTheme.secondaryNeon : AppTheme.primaryNeon).withOpacity(0.12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      venue.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          venue.name,
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$voteCount Oy • $percentage%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: hasMyVote ? AppTheme.secondaryNeon : AppTheme.textSecondary,
                            fontWeight: hasMyVote ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Vote Radio Indicator
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: hasMyVote ? AppTheme.secondaryNeon : Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                      color: hasMyVote ? AppTheme.secondaryNeon : Colors.transparent,
                    ),
                    child: hasMyVote
                        ? const Icon(Icons.check, size: 14, color: Colors.black)
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentBubble(String author, String comment, String timeAgo, bool isPurple) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: (isPurple ? AppTheme.primaryNeon : AppTheme.accentNeon).withOpacity(0.2),
          child: Text(
            author.substring(0, 1),
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      author,
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      timeAgo,
                      style: GoogleFonts.inter(fontSize: 9, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment,
                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
