import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Placeholder shown in place of the topic icon row while categories load.
class ExploreTopicsRowShimmer extends StatelessWidget {
  const ExploreTopicsRowShimmer({this.itemCount = 4, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < itemCount; i++)
            Column(
              children: [
                const CircleAvatar(radius: 28, backgroundColor: Colors.white),
                const SizedBox(height: 8),
                Container(
                  width: 48,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
