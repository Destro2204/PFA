import 'package:flutter/material.dart';

class HeartRateWidget extends StatefulWidget {
  @override
  _HeartRateWidgetState createState() => _HeartRateWidgetState();
}

class _HeartRateWidgetState extends State<HeartRateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final int heartRate = 72; // Simulé pour le MVP

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fréquence cardiaque',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1.0 + (_animationController.value * 0.1),
                      child: CustomPaint(
                        size: Size(100, 100),
                        painter: HeartPainter(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  '$heartRate',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'BPM',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  final Color color;

  HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.moveTo(width * 0.5, height * 0.35);
    path.cubicTo(
      width * 0.2, height * 0.1, 
      width * 0.0, height * 0.45, 
      width * 0.5, height * 0.9
    );
    path.cubicTo(
      width * 1.0, height * 0.45, 
      width * 0.8, height * 0.1, 
      width * 0.5, height * 0.35
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}