import 'package:flutter/material.dart';

class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({Key? key}) : super(key: key);

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = ColorTween(begin: Colors.grey[300], end: Colors.grey[600])
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: paddingCoefficient / 1.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSkeletonContainer(screenWidth, fontSizeCoefficient),
              _buildSkeletonContainer(screenWidth, fontSizeCoefficient),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeletonContainer(
      double screenWidth, double fontSizeCoefficient) {
    return Container(
      height: 128 * fontSizeCoefficient,
      width: screenWidth * 0.45,
      decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 1, color: Colors.black.withOpacity(0.2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            Container(
              height: 73 * fontSizeCoefficient,
              width: double.infinity,
              color: _animation.value,
            ),
            SizedBox(height: 6 * fontSizeCoefficient),
            for (int i = 0; i < 3; i++)
              Container(
                height: 8 * fontSizeCoefficient,
                width: double.infinity,
                color: _animation.value,
                margin: const EdgeInsets.symmetric(vertical: 2),
              ),
          ],
        ),
      ),
    );
  }
}
