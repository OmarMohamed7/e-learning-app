import 'package:flutter/material.dart';

/// Maps a [CategoryModel.icon] key (stored in Firestore/the REST API as a
/// plain string, since neither can hold a Flutter [IconData]) to the
/// [IconData] shown for it.
IconData categoryIconFor(String iconKey) {
  switch (iconKey) {
    case 'flutter_dash':
      return Icons.flutter_dash_rounded;
    case 'business_center':
      return Icons.business_center_outlined;
    case 'brush':
      return Icons.brush_outlined;
    case 'campaign':
      return Icons.campaign_outlined;
    default:
      return Icons.category_outlined;
  }
}
