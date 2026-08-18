import 'package:flutter/material.dart' show Color, Colors, IconData, Icons;

import '../../data/models/category_model.dart';

/// Resolves a themed icon/color pair for a category. Used for the category
/// chip's icon and as an image-load-failure placeholder on course
/// thumbnails, so a broken or missing image still reads as "this category"
/// instead of a blank box.
class CategoryIconMapper {
  static IconData iconFor(CategoryModel category) {
    return switch (_key(category)) {
      'flutter' => Icons.flutter_dash,
      'programming' => Icons.code,
      'business' => Icons.business,
      'finance' => Icons.attach_money,
      'design' => Icons.draw,
      'marketing' => Icons.campaign,
      'language' => Icons.language,
      _ => Icons.category,
    };
  }

  /// Null means "no strong brand color" — callers should fall back to a
  /// theme color.
  static Color? colorFor(CategoryModel category) {
    return switch (_key(category)) {
      'flutter' => const Color(0xFF02569B),
      'programming' => Colors.teal,
      'business' => Colors.indigo,
      'finance' => Colors.green,
      'design' => Colors.pink,
      'marketing' => Colors.orange,
      'language' => Colors.deepPurple,
      _ => null,
    };
  }

  static String _key(CategoryModel category) =>
      (category.icon ?? category.id).toLowerCase();
}
