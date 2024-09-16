import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Padding(
        padding: EdgeInsets.all(32.0),
        child: SquareAnimation(),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

class SquareAnimationState extends State<SquareAnimation> {
  static const _squareSize = 50.0;
  Alignment currentAlignment = Alignment.center;
  bool isAnimationStarted = false;
  bool? isRightSide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedAlign(
                alignment: currentAlignment,
                duration: const Duration(seconds: 1),
                child: Container(
                  width: _squareSize,
                  height: _squareSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(),
                  ),
                ),
                onEnd: () {
                  setState(() {
                    isAnimationStarted = false;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: ((isAnimationStarted ||
                            currentAlignment == Alignment.centerRight))
                        ? null
                        : () {
                            currentAlignment = Alignment.centerRight;
                            isAnimationStarted = true;
                            isRightSide = true;
                            setState(() {});
                          },
                    child: const Text('Right'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: (isAnimationStarted ||
                            currentAlignment == Alignment.centerLeft)
                        ? null
                        : () {
                            currentAlignment = Alignment.centerLeft;
                            isAnimationStarted = true;
                            isRightSide = false;
                            setState(() {});
                          },
                    child: const Text('Left'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
