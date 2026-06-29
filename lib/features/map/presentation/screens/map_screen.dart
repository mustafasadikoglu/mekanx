import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/theme.dart';
import '../../../discover/data/models/venue_model.dart';
import '../../../discover/presentation/screens/venue_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  VenueModel? _selectedVenue;

  void _onMarkerTapped(VenueModel venue) {
    setState(() {
      _selectedVenue = venue;
    });
    // Smoothly animate map to selected coordinates
    _mapController.move(
      LatLng(venue.latitude - 0.0015, venue.longitude), // Offset slightly south to accommodate card
      15.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // FlutterMap Tile Engine
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(40.9870, 29.0270), // Kadikoy/Moda Center
              initialZoom: 15.0,
              maxZoom: 18.0,
              minZoom: 12.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              // Premium Dark Maps Template (CartoDB Dark Matter)
              TileLayer(
                urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.mekanx',
              ),
              
              // Venue Pins Layer
              MarkerLayer(
                markers: mockVenues.map((venue) {
                  final isSelected = _selectedVenue?.id == venue.id;
                  
                  return Marker(
                    width: 60,
                    height: 60,
                    point: LatLng(venue.latitude, venue.longitude),
                    child: GestureDetector(
                      onTap: () => _onMarkerTapped(venue),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 250),
                        scale: isSelected ? 1.25 : 1.0,
                        child: _buildNeonMarker(venue, isSelected),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Header Overlay
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: AppTheme.glassDecoration(borderRadius: 20),
              child: Row(
                children: [
                  const Icon(Icons.map_outlined, color: AppTheme.secondaryNeon, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Karta Göre Keşfet',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    '${mockVenues.length} Mekan',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Glassmorphic Detail Card Overlay (Bottom)
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: _selectedVenue != null
                  ? _buildBottomCard(context, _selectedVenue!)
                  : _buildTipCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonMarker(VenueModel venue, bool isSelected) {
    Color mainColor = AppTheme.primaryNeon;
    String emoji = '💻';
    
    if (venue.moodTag == 'work') {
      mainColor = AppTheme.primaryNeon;
      emoji = '💻';
    } else if (venue.moodTag == 'social') {
      mainColor = AppTheme.secondaryNeon;
      emoji = '☕';
    } else if (venue.moodTag == 'inspiration') {
      mainColor = AppTheme.accentNeon;
      emoji = '🎨';
    } else if (venue.moodTag == 'chill') {
      mainColor = Colors.blue;
      emoji = '🌿';
    }

    return Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Glow
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: mainColor.withValues(alpha: isSelected ? 0.6 : 0.3),
                  blurRadius: isSelected ? 16 : 8,
                  spreadRadius: isSelected ? 6 : 2,
                ),
              ],
            ),
          ),
          
          // Outer Ring
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.background,
              border: Border.all(
                color: mainColor,
                width: 2.5,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          // Bottom Triangle Indicator pointing to point
          Positioned(
            bottom: 2,
            child: Icon(
              Icons.arrow_drop_down,
              color: mainColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCard(BuildContext context, VenueModel venue) {
    return Container(
      key: ValueKey('card-${venue.id}'),
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.glassDecoration(borderRadius: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  venue.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getMoodLabel(venue.moodTag),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _getMoodColor(venue.moodTag),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              venue.rating.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      venue.name,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      venue.location,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 4,
                      children: venue.tags.take(2).map((tag) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: _getMoodColor(venue.moodTag).withValues(alpha: 0.15),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.inter(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedVenue = null;
                    });
                  },
                  child: Text(
                    'Kapat',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VenueDetailScreen(venue: venue),
                      ),
                    );
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getMoodColor(venue.moodTag),
                          _getMoodColor(venue.moodTag).withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Detayları Gör',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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

  Widget _buildTipCard() {
    return Container(
      key: const ValueKey('tip-card'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: AppTheme.glassDecoration(borderRadius: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app_outlined, color: AppTheme.textSecondary, size: 16),
          const SizedBox(width: 10),
          Text(
            'Keşfetmek için bir harita pinine dokunun.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodLabel(String mood) {
    switch (mood) {
      case 'work':
        return '💻 ÇALIŞMA ALANI';
      case 'social':
        return '☕ SOSYALLEŞME';
      case 'inspiration':
        return '🎨 İLHAM ALMA';
      case 'chill':
        return '🌿 KAFA DİNLEME';
      default:
        return '🌟 MEKAN';
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'work':
        return AppTheme.primaryNeon;
      case 'social':
        return AppTheme.secondaryNeon;
      case 'inspiration':
        return AppTheme.accentNeon;
      case 'chill':
        return Colors.blue;
      default:
        return AppTheme.primaryNeon;
    }
  }
}
