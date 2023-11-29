import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(height * 0.1),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedButton(
                child: Text('Hello TikTok'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Widget child;
  final dynamic duration;
  final dynamic onTap;

  const AnimatedButton(
      {super.key, required this.child, this.duration, this.onTap});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 1200),
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.repeat();
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
    return InkWell(
      onTap: () {
        isTapped = !isTapped;
        setState(() {});
      },
      child: CustomPaint(
        painter: AnimatedButtonPainter(animation: _controller , isTapped: isTapped),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Container(
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class AnimatedButtonPainter extends CustomPainter {
  final Animation animation;
  final Color animatedButtonColor;
  final Color borderColor;
  final double borderWidth;
  final bool isTapped;

  AnimatedButtonPainter({
    required this.isTapped,
    required this.animation,
    this.borderColor = Colors.white,
    this.borderWidth = 4,
    this.animatedButtonColor = Colors.purple,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
        colors:  [
          isTapped ? Colors.pink : Colors.purple,
          Colors.transparent,
        ],
        stops: const [
          0.7,
          1.0,
        ],
        startAngle: 0,
        endAngle: vector.radians(180),
        transform: GradientRotation(
          vector.radians((360 * animation.value).toDouble()),
        ),
      ).createShader(rect);
    final path = Path.combine(
      PathOperation.xor,
      Path()..addRect(rect),
      Path()
        ..addRect(
          rect.deflate(borderWidth),
        ),
    );

    canvas.drawRect(
        rect.deflate(borderWidth / 2),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = borderWidth);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
