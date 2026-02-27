import 'dart:math';
import 'package:flutter/material.dart';

class MovingPointsBackground extends StatefulWidget {
  final Color dotColor;
  final int numberOfDots;

  const MovingPointsBackground({
    super.key,
    this.dotColor = const Color(0xFF00A38E), // Matches your primary teal
    this.numberOfDots = 40,
  });

  @override
  State<MovingPointsBackground> createState() => _MovingPointsBackgroundState();
}

class _MovingPointsBackgroundState extends State<MovingPointsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {
          for (var particle in particles) {
            particle.update();
          }
        });
      })..repeat();

    // Initialize particles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < widget.numberOfDots; i++) {
        particles.add(Particle(
          position: Offset(random.nextDouble() * size.width, random.nextDouble() * size.height),
          velocity: Offset(random.nextDouble() * 0.4 - 0.2, random.nextDouble() * 0.4 - 0.2),
          size: random.nextDouble() * 3 + 1,
          opacity: random.nextDouble() * 0.5 + 0.1,
          screenSize: size,
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(particles, widget.dotColor),
      size: Size.infinite,
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  double size;
  double opacity;
  Size screenSize;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
    required this.screenSize,
  });

  void update() {
    position += velocity;

    // Wrap around screen
    if (position.dx < 0) position = Offset(screenSize.width, position.dy);
    if (position.dx > screenSize.width) position = Offset(0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, screenSize.height);
    if (position.dy > screenSize.height) position = Offset(position.dx, 0);
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color dotColor;

  ParticlePainter(this.particles, this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      paint.color = dotColor.withValues(alpha: particle.opacity);
      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
