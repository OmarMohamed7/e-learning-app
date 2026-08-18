import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_search_field.dart';
import '../providers/courses_providers.dart';
import '../widgets/popular_class_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _query = value.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('searchTitle'.tr())),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSearchField(
              controller: _controller,
              hintText: 'searchHint'.tr(),
              autofocus: true,
              onChanged: _onQueryChanged,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _query.isEmpty
                  ? Center(child: Text('searchPrompt'.tr()))
                  : _SearchResults(query: _query),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(courseSearchProvider(query));

    return resultsAsync.when(
      data: (courses) {
        if (courses.isEmpty) {
          return Center(child: Text('noSearchResults'.tr()));
        }

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: courses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final course = courses[index];
            return PopularClassCard(
              course: course.toEntity(),
              width: double.infinity,
              onTap: () => context.push('/course/${course.id}'),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('genericError'.tr())),
    );
  }
}
