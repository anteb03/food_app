import 'package:flutter/material.dart';

class AnimatedSkeleton extends StatelessWidget {
  const AnimatedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Row(
          children: [
            const Skeleton(),
            SizedBox(
              height: fontSizeCoefficient * 12,
            ),
            const Skeleton()
          ],
        );
      },
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: paddingCoefficient * 2,
      ),
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        width: screenWidth / 2 - fontSizeCoefficient * 5,
        height: screenHeight / 4 - fontSizeCoefficient * 5,
        child: Column(children: [
          Container(),
          SizedBox(),
          Container(),
          SizedBox(),
          Container(),
          SizedBox(),
          Container(),
        ]),
      ),
    );
  }
}
