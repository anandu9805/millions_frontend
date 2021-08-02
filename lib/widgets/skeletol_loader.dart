import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const SkeletonContainer._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    Key key,
  }) : super(key: key);

  const SkeletonContainer.square({
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(20)),

    double width,
    double height,
  }) : this._(width: width, height: height);

  const SkeletonContainer.rounded({
    double width,
    double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : this._(width: width, height: height, borderRadius: borderRadius);

  const SkeletonContainer.circular({
    double width,
    double height,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(20)),
  }) : this._(width: width, height: height, borderRadius: borderRadius);

  @override
  Widget build(BuildContext context) => SkeletonAnimation(
    //gradientColor: Colors.orange,
    //shimmerColor: Colors.red,
    curve: Curves.easeInOutQuad,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: borderRadius,
      ),
    ),
  );
}