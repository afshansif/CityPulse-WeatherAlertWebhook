import 'package:flutter/material.dart';

import '../constants/cities.dart';
import '../theme/app_theme.dart';

/// A searchable city dropdown. The client can pick from the suggested
/// list or type any other city name — both are sent to the backend as-is.
class CitySelector extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const CitySelector({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fieldWidth = constraints.maxWidth;
        return Autocomplete<String>(
          initialValue: TextEditingValue(text: initialValue ?? ''),
          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim().toLowerCase();
            if (query.isEmpty) return kCityOptions;
            return kCityOptions
                .where((city) => city.toLowerCase().contains(query));
          },
          onSelected: onChanged,
          fieldViewBuilder:
              (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              onChanged: onChanged,
              onSubmitted: (_) => onFieldSubmitted(),
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search or select a city',
                prefixIcon:
                    Icon(Icons.location_city, color: AppColors.blueSlate),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(AppRadius.control),
                child: SizedBox(
                  width: fieldWidth,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 260),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            child: Text(
                              option,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
