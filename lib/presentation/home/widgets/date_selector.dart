import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({
    required this.dates,
    required this.selectedDate,
    required this.onSelected,
    super.key,
  });

  final List<DateTime> dates;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selectedDate);

          return GestureDetector(
            onTap: () => onSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 88,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Formatters.shortWeekdayFormat.format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white : colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    Formatters.dayFormat.format(date),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.88)
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }
}
