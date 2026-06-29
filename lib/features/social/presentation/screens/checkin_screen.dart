import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/theme.dart';
import '../../../discover/data/models/venue_model.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> with SingleTickerProviderStateMixin {
  String _scanState = 'initial'; // 'initial', 'scanning', 'success', 'dashboard'
  VenueModel? _checkedInVenue;
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;

  final List<Map<String, String>> _mockUsers = [
    {'name': 'Selin Y.', 'mood': '💻 Çalışıyor', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop'},
    {'name': 'Caner K.', 'mood': '☕ Sohbet Ediyor', 'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop'},
    {'name': 'Ece S.', 'mood': '🌿 Kafa Dinliyor', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200&auto=format&fit=crop'},
  ];

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scannerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scannerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _scanState = 'scanning';
    });
    _scannerController.repeat(reverse: true);

    // Simulate successful QR code detection after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _scannerController.stop();
        setState(() {
          _scanState = 'success';
          _checkedInVenue = mockVenues[0]; // Mavrik Lab & Coffee
        });
        
        // Auto-navigate to Checked-in Dashboard after success animation
        Future.delayed(const Duration(milliseconds: 2500), () {
          if (mounted) {
            setState(() {
              _scanState = 'dashboard';
            });
          }
        });
      }
    });
  }

  void _sendChatRequest(String username) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppTheme.secondaryNeon),
            const SizedBox(width: 10),
            Text(
              '$username kullanıcısına sohbet isteği gönderildi!',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppTheme.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background soft glowing gradients
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.secondaryNeon.withValues(alpha: 0.06),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildCurrentStateView(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStateView() {
    switch (_scanState) {
      case 'scanning':
        return _buildScanningView();
      case 'success':
        return _buildSuccessView();
      case 'dashboard':
        return _buildDashboardView();
      case 'initial':
      default:
        return _buildInitialView();
    }
  }

  Widget _buildInitialView() {
    return Column(
      key: const ValueKey('initial'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        // Center Scan Icon or Lottie Animation
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.02),
            border: Border.all(
              color: AppTheme.secondaryNeon.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.qr_code_scanner,
            size: 100,
            color: AppTheme.secondaryNeon,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Mekanda Sosyalleş',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Gittiğin mekandaki QR kodu taratarak sisteme giriş yap ve aynı mekandaki diğer kişilerle bağlantı kur!',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        
        // Scan Button
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: _startScanning,
            child: Ink(
              decoration: BoxDecoration(
                gradient: AppTheme.mintGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.black, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      'Mekan QR Kodunu Tara',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildScanningView() {
    return Column(
      key: const ValueKey('scanning'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'QR Taranıyor...',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 8),
        Text(
          'Masanın üzerindeki QR kodu hizada tutun.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 40),
        
        // Simulating camera view box
        Container(
          width: 260,
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.secondaryNeon, width: 3),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Camera Placeholder Background (Dark mesh pattern)
              Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Icon(Icons.qr_code, color: Colors.white.withValues(alpha: 0.05), size: 180),
                ),
              ),
              
              // Scanning Laser Line
              AnimatedBuilder(
                animation: _scannerAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: _scannerAnimation.value * 254,
                    left: 10,
                    right: 10,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryNeon,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.secondaryNeon.withValues(alpha: 0.8),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 50),
        
        // Cancel Scan
        TextButton(
          onPressed: () {
            _scannerController.stop();
            setState(() {
              _scanState = 'initial';
            });
          },
          child: Text(
            'Vazgeç',
            style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.6), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Center(
      key: const ValueKey('success'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie Success checkmark animation (Loads from raw github asset fallback)
          SizedBox(
            width: 150,
            height: 150,
            child: Lottie.network(
              'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/checkmark.json',
              repeat: false,
              errorBuilder: (context, error, stackTrace) {
                // Return animated fallback icon if offline
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.secondaryNeon.withValues(alpha: 0.1),
                  ),
                  child: const Icon(Icons.check, size: 70, color: AppTheme.secondaryNeon),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Check-In Başarılı!',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 26),
          ),
          const SizedBox(height: 8),
          Text(
            _checkedInVenue?.name ?? 'Mekan',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryNeon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardView() {
    return Column(
      key: const ValueKey('dashboard'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Venue Card Info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.glassDecoration(borderRadius: 20),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _checkedInVenue?.imageUrl ?? '',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check-in Yapılan Mekan',
                      style: GoogleFonts.inter(fontSize: 10, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _checkedInVenue?.name ?? '',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.secondaryNeon.withValues(alpha: 0.15),
                ),
                child: Text(
                  'Aktif',
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.secondaryNeon),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
        
        // List Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Aynı Mekandaki Kişiler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
              child: const Icon(Icons.radar, size: 16, color: AppTheme.secondaryNeon),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Sohbet başlatmak ve tanışmak için profillere dokun.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        
        // Grid / List of users
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _mockUsers.length,
            itemBuilder: (context, index) {
              final user = _mockUsers[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(user['avatar']!),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name']!,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user['mood']!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Chat Request Button
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.secondaryNeon),
                      onPressed: () => _sendChatRequest(user['name']!),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Check-Out button
        Center(
          child: TextButton.icon(
            icon: const Icon(Icons.logout, size: 16, color: Colors.redAccent),
            label: Text(
              'Mekandan Çıkış Yap',
              style: GoogleFonts.inter(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              setState(() {
                _scanState = 'initial';
                _checkedInVenue = null;
              });
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
