import 'package:flutter/material.dart' show IconData, Icons;

class CategoryIconMapper {
  static IconData resolve(String value) {
    return switch (value.toLowerCase()) {
      'programming' => Icons.code,
      'business' => Icons.business,
      'design' => Icons.draw,
      'marketing' => Icons.campaign,
      'language' => Icons.language,
      _ => Icons.category,
    };
  }
}
