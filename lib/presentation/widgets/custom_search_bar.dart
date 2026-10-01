import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Reusable search bar widget with accessible semantics and clear action.
class CustomSearchBar extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onSearch;

  const CustomSearchBar({
    super.key,
    required this.initialValue,
    required this.onSearch,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      widget.onSearch(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Semantics(
      label: l10n?.searchLabel ?? 'Search city input',
      textField: true,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          key: const Key('search_text_field'),
          controller: _controller,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            hintText: l10n?.searchHint ?? 'Search city...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              key: const Key('search_button'),
              icon: const Icon(Icons.arrow_forward_rounded),
              tooltip: l10n?.searchAction ?? 'Search',
              onPressed: _submit,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}
