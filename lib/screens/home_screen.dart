import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../services/voice_agent_controller.dart';
import '../services/document_provider.dart';
import '../models/models.dart';
import '../widgets/global_voice_assistant.dart';
import '../theme/design_system.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final voice = context.read<VoiceAgentController>();
      voice.setNavigateCallback(() {
        if (mounted) {
          _handleVoiceNavigation();
        }
      });
    });
  }

  void _handleVoiceNavigation() {
    final voice = context.read<VoiceAgentController>();
    final route = voice.responseText;

    // First, pop any open routes to get back to MainScreen
    Navigator.of(context).popUntil((route) => route.isFirst);

    if (route.contains('scholarship')) {
      // Navigate to Services tab first, then push scholarship detail
      Navigator.of(context)
          .pushNamed('/services', arguments: 'scholarship')
          .then((_) {
        // After returning from services, ensure we're on the right tab
        voice.clearNavigationTarget();
      });
    } else if (route.contains('license') || route.contains('driving')) {
      Navigator.of(context)
          .pushNamed('/services', arguments: 'license')
          .then((_) {
        voice.clearNavigationTarget();
      });
    } else if (route.contains('income') || route.contains('certificate')) {
      Navigator.of(context)
          .pushNamed('/services', arguments: 'income')
          .then((_) {
        voice.clearNavigationTarget();
      });
    } else if (route.contains('document') || route.contains('vault')) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushNamed(context, '/documents');
    } else if (route.contains('gr') ||
        route.contains('rule') ||
        route.contains('government')) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushNamed(context, '/gr');
    } else if (route.contains('service') || route.contains('services')) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushNamed(context, '/services');
    }

    // Clear navigation target to avoid tab switching after detail screen closes
    voice.clearNavigationTarget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SevaSetuTheme.background,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  SevaSetuTheme.primaryBlue.withOpacity(0.1),
                  SevaSetuTheme.background,
                ],
              ),
            ),
          ),

          // Floating background elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    SevaSetuTheme.primaryBlue.withOpacity(0.1),
                    SevaSetuTheme.secondaryBlue.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    SevaSetuTheme.primaryBlue.withOpacity(0.08),
                    SevaSetuTheme.secondaryBlue.withOpacity(0.03),
                  ],
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(SevaSetuTheme.spacingLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section - Small Rectangle
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          SevaSetuTheme.primaryBlue,
                          SevaSetuTheme.primaryDarkBlue,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: SevaSetuTheme.mediumShadow,
                    ),
                    child: Row(
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.account_balance,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Brand Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SevaSetu',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(1, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Smart Documents Assistant for Citizens',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: SevaSetuTheme.spacingLG),

                  // Voice Assistant - Centered Above Service Readiness
                  Consumer<VoiceAgentController>(
                    builder: (context, voice, _) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Voice Assistant',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => voice.startListening(),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: voice.isListening
                                        ? [
                                            SevaSetuTheme.statusExpiring,
                                            SevaSetuTheme.warningOrange,
                                          ]
                                        : [
                                            SevaSetuTheme.primaryBlue,
                                            SevaSetuTheme.secondaryBlue,
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: SevaSetuTheme.mediumShadow,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      voice.isListening
                                          ? Icons.stop
                                          : Icons.mic,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      voice.isListening
                                          ? 'Listening...'
                                          : 'Tap to Speak',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Try: "Show documents", "Open services", or "Check GR"',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: SevaSetuTheme.spacingLG),

                  // Service Readiness Hero Card
                  Consumer<DocumentProvider>(
                    builder: (context, documentProvider, _) {
                      // Calculate progress for each service based on documents
                      final drivingLicenseProgress =
                          _calculateDrivingLicenseProgress(
                              documentProvider.documents);
                      final bankAccountProgress = _calculateBankAccountProgress(
                          documentProvider.documents);
                      final scholarshipProgress = _calculateScholarshipProgress(
                          documentProvider.documents);

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Service Readiness',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A237E),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Driving License
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/services',
                                        arguments: 'license');
                                  },
                                  child: _buildProgressCircle(
                                    percentage: drivingLicenseProgress,
                                    color:
                                        const Color(0xFF2196F3), // Vibrant Blue
                                    label: 'Driving License',
                                    status: _getDrivingLicenseStatus(
                                        drivingLicenseProgress),
                                  ),
                                ),
                                // Bank Account
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/services',
                                        arguments: 'bank_account');
                                  },
                                  child: _buildProgressCircle(
                                    percentage: bankAccountProgress,
                                    color: const Color(0xFF4CAF50), // Green
                                    label: 'Bank Account',
                                    status: _getBankAccountStatus(
                                        bankAccountProgress),
                                  ),
                                ),
                                // Scholarship
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/services',
                                        arguments: 'scholarship');
                                  },
                                  child: _buildProgressCircle(
                                    percentage: scholarshipProgress,
                                    color:
                                        const Color(0xFFFF5252), // Red/Orange
                                    label: 'Scholarship',
                                    status: _getScholarshipStatus(
                                        scholarshipProgress),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: SevaSetuTheme.spacingLG),
                ],
              ),
            ),
          ),

          const GlobalVoiceAssistant(),
        ],
      ),
    );
  }

  Widget _buildProgressCircle({
    required int percentage,
    required Color color,
    required String label,
    required String status,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Animated progress circle
            AnimatedCircularProgress(
              targetPercentage: percentage,
              color: color,
              size: 80,
              strokeWidth: 8,
            ),
            // Center percentage text
            AnimatedPercentageText(
              targetPercentage: percentage,
              color: const Color(0xFF1A237E),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Driving License Progress Calculation
  int _calculateDrivingLicenseProgress(List<DocumentModel> documents) {
    // Required documents for driving license from services section
    final requiredDocs = [
      'Address Proof',
      'Age Proof',
      'Passport Photo',
      'Learner License',
    ];

    return _calculateProgress(documents, requiredDocs);
  }

  // Bank Account Progress Calculation
  int _calculateBankAccountProgress(List<DocumentModel> documents) {
    // Required documents for bank account from services section
    final requiredDocs = [
      'Aadhaar Card',
      'PAN Card',
      'Passport Size Photograph',
      'Address Proof (Electricity Bill, Ration Card, etc.)',
      'Identity Proof (Voter ID, Driving License, etc.)',
      'Signature Proof',
      'Nominee Details',
    ];

    return _calculateProgress(documents, requiredDocs);
  }

  // Scholarship Progress Calculation
  int _calculateScholarshipProgress(List<DocumentModel> documents) {
    // Required documents for scholarship from services section
    final requiredDocs = [
      'Mahadbt Application Form',
      'MHT-CET Result',
      'SSC Marksheet',
      'HSC Marksheet',
      'B-Tech Marksheet (Renewal)',
      'HSC LC',
      'Income Certificate',
      'Non-Creamy Layer',
      'Nationality & Domicile Certificate',
      'Caste Certificate',
      'Caste Validity',
      'Aadhaar Card',
      'Undertaking',
    ];

    return _calculateProgress(documents, requiredDocs);
  }

  // Generic progress calculation method that matches services section logic
  int _calculateProgress(
      List<DocumentModel> documents, List<String> requiredDocs) {
    final available = <String>[];
    final expired = <String>[];
    final missing = <String>[];

    for (final requiredDoc in requiredDocs) {
      DocumentModel? doc;
      try {
        doc = documents.firstWhere(
          (d) =>
              d.type.toLowerCase().contains(
                  requiredDoc.toString().toLowerCase().split(' ').first) ||
              requiredDoc
                  .toString()
                  .toLowerCase()
                  .contains(d.type.toLowerCase().split(' ').first),
        );
      } catch (e) {
        // Document not found
      }

      if (doc != null) {
        if (doc.status == 'Expired') {
          expired.add(doc.type);
        } else {
          available.add(doc.type);
        }
      } else {
        missing.add(requiredDoc.toString());
      }
    }

    final totalDocs = requiredDocs.length;
    final availableDocs = available.length;
    final progress =
        totalDocs > 0 ? (availableDocs / totalDocs).toDouble() : 0.0;
    return (progress * 100).round();
  }

  // Status text methods
  String _getDrivingLicenseStatus(int progress) {
    if (progress >= 90) return 'Almost Done';
    if (progress >= 50) return 'In-Progress';
    return 'Missing Docs';
  }

  String _getBankAccountStatus(int progress) {
    if (progress >= 90) return 'Almost Done';
    if (progress >= 50) return 'In-Progress';
    return 'Missing Docs';
  }

  String _getScholarshipStatus(int progress) {
    if (progress >= 90) return 'Almost Done';
    if (progress >= 50) return 'In-Progress';
    return 'Missing Docs';
  }
}

// Animated Circular Progress Widget
class AnimatedCircularProgress extends StatefulWidget {
  final int targetPercentage;
  final Color color;
  final double size;
  final double strokeWidth;

  const AnimatedCircularProgress({
    super.key,
    required this.targetPercentage,
    required this.color,
    required this.size,
    required this.strokeWidth,
  });

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation =
        Tween<double>(begin: 0.0, end: widget.targetPercentage / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetPercentage != widget.targetPercentage) {
      _controller.reset();
      _animation = Tween<double>(
              begin: oldWidget.targetPercentage / 100,
              end: widget.targetPercentage / 100)
          .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            foregroundPainter: CircularProgressPainter(
              progress: _animation.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
            child: child,
          ),
        );
      },
      child: Container(),
    );
  }
}

// Custom Painter for Circular Progress
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0.8),
          color.withOpacity(1.0),
          color.withOpacity(0.8),
        ],
        stops: [0.0, 0.5, 1.0],
        startAngle: -pi / 2,
        endAngle: pi * 2 * progress - pi / 2,
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Animated Percentage Text Widget
class AnimatedPercentageText extends StatefulWidget {
  final int targetPercentage;
  final Color color;

  const AnimatedPercentageText({
    super.key,
    required this.targetPercentage,
    required this.color,
  });

  @override
  State<AnimatedPercentageText> createState() => _AnimatedPercentageTextState();
}

class _AnimatedPercentageTextState extends State<AnimatedPercentageText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _animation = StepTween(begin: 0, end: widget.targetPercentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedPercentageText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetPercentage != widget.targetPercentage) {
      _controller.reset();
      _animation = StepTween(
              begin: oldWidget.targetPercentage, end: widget.targetPercentage)
          .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${_animation.value}%',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: widget.color,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        );
      },
    );
  }
}
