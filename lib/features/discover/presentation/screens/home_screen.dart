import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/venue_model.dart';
import 'venue_detail_screen.dart';
import '../../../map/presentation/screens/map_screen.dart';
import '../../../social/presentation/screens/checkin_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String initialMood;
  const HomeScreen({super.key, required this.initialMood});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _selectedMood;
  int _currentIndex = 0;

  final List<Map<String, String>> _moods = [
    {'id': 'all', 'label': '🌟 Tümü', 'color': 'all'},
    {'id': 'work', 'label': '💻 Çalış', 'color': 'purple'},
    {'id': 'social', 'label': '☕ Sohbet', 'color': 'mint'},
    {'id': 'inspiration', 'label': '🎨 İlham Al', 'color': 'pink'},
    {'id': 'chill', 'label': '🌿 Dinlen', 'color': 'blue'},
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.initialMood;
  }

  List<VenueModel> get _filteredVenues {
    if (_selectedMood == 'all') {
      return mockVenues;
    }
    return mockVenues.where((v) => v.moodTag == _selectedMood).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 1:
        return const MapScreen();
      case 2:
        return const CheckInScreen();
      case 3:
        return const ProfileScreen();
      case 0:
      default:
        return _buildDiscoverBody();
    }
  }

  Widget _buildDiscoverBody() {
    return Stack(
      children: [
        // Background soft glowing gradients
        Positioned(
          top: 40,
          left: -80,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryNeon.withValues(alpha: 0.08),
                  blurRadius: 90,
                  spreadRadius: 45,
                ),
              ],
            ),
          ),
        ),
        
        SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Keşfet',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 36,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'En popüler mekanlar listeleniyor',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      // Profile Glow Button redirects to Profile Tab
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex = 3;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppTheme.primaryGradient,
                          ),
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Mood Filters
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _moods.length,
                    itemBuilder: (context, index) {
                      final mood = _moods[index];
                      final isSelected = _selectedMood == mood['id'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMood = mood['id']!;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: isSelected
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: mood['id'] == 'work'
                                        ? AppTheme.primaryGradient
                                        : mood['id'] == 'inspiration'
                                            ? AppTheme.accentGradient
                                            : mood['id'] == 'chill'
                                                ? AppTheme.mintGradient
                                                : AppTheme.primaryGradient,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (mood['id'] == 'work'
                                                ? AppTheme.primaryNeon
                                                : mood['id'] == 'inspiration'
                                                    ? AppTheme.accentNeon
                                                    : AppTheme.secondaryNeon)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  )
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white.withValues(alpha: 0.04),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.06),
                                    ),
                                  ),
                            child: Center(
                              child: Text(
                                mood['label']!,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 25)),

              // Featured Card Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Popüler Kartlar',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 15)),

              // Featured Horizontal Slider
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 380,
                  child: _filteredVenues.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredVenues.length,
                          itemBuilder: (context, index) {
                            final venue = _filteredVenues[index];
                            return _buildFeaturedCard(context, venue);
                          },
                        ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 25)),

              // Nearby Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Yakındakiler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 15)),

              // Nearby List
              _filteredVenues.isEmpty
                  ? const SliverToBoxAdapter(child: SizedBox.shrink())
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final venue = _filteredVenues[index];
                            return _buildNearbyListItem(context, venue);
                          },
                          childCount: _filteredVenues.length,
                        ),
                      ),
                    ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
          const SizedBox(height: 10),
          Text(
            'Bu kategoriye uygun mekan bulunamadı.',
            style: GoogleFonts.inter(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, VenueModel venue) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VenueDetailScreen(venue: venue),
          ),
        );
      },
      child: Container(
        width: 270,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Venue Image with Hero transition
            Hero(
              tag: 'venue-img-${venue.id}',
              child: Image.network(
                venue.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            
            // Vignette Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Rating Badge (Top Right)
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: AppTheme.glassDecoration(borderRadius: 12),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      venue.rating.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info Glassmorphic Card (Bottom)
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassDecoration(borderRadius: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      venue.name,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          venue.location,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      children: venue.tags.take(2).map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppTheme.primaryNeon.withValues(alpha: 0.2),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyListItem(BuildContext context, VenueModel venue) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VenueDetailScreen(venue: venue),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.04),
          ),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                venue.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        venue.location,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        venue.rating.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${venue.reviewCount} yorum)',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Go Arrow
            Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
      decoration: AppTheme.glassDecoration(borderRadius: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.explore_outlined,
              color: _currentIndex == 0 ? AppTheme.primaryNeon : AppTheme.textSecondary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.map_outlined,
              color: _currentIndex == 1 ? AppTheme.secondaryNeon : AppTheme.textSecondary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.qr_code_scanner,
              color: _currentIndex == 2 ? AppTheme.accentNeon : AppTheme.textSecondary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: _currentIndex == 3 ? Colors.blue : AppTheme.textSecondary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _currentIndex = 3;
              });
            },
          ),
        ],
      ),
    );
  }
}
