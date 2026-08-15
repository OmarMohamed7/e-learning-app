import 'package:flutter/material.dart';

/// A filled, rounded search input using the app's [InputDecorationTheme].
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }
}
