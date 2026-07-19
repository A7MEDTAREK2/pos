// lib/feature/dashboard/presentation/widgets/date_filter.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class DateFilter extends StatefulWidget {
  final bool isCompact;

  final void Function(DateTime from, DateTime to)? onDateChanged;

  const DateFilter({
    super.key,
    this.isCompact = false,
    this.onDateChanged,
  });


  @override
  State<DateFilter> createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  String selectedFilter = 'آخر 7 أيام';


  final List<String> filters = [
    'اليوم',
    'أمس',
    'آخر 7 أيام',
    'آخر 30 يوم',
    'هذا الشهر',
    'الشهر الماضي',
    'هذه السنة',
    'السنة الماضية',
    'فترة مخصصة',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.calendar_today,
              size: 18,
              color: Color(0xFF6B7280),
            ),
          ),
          DropdownButton<String>(
            value: selectedFilter,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down),
            style: GoogleFonts.cairo(
              color: const Color(0xFF111827),
              fontSize: widget.isCompact ? 12 : 14,
            ),
            items: filters.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e),
              );
            }).toList(),
            onChanged: (value) async {
              if (value == null) return;

              setState(() {
                selectedFilter = value;
              });

              final now = DateTime.now();

              DateTime from = now;
              DateTime to = now;

              switch (value) {
                case "اليوم":
                  from = DateTime(now.year, now.month, now.day);
                  to = now;
                  break;

                case "أمس":
                  final yesterday = now.subtract(const Duration(days: 1));
                  from = DateTime(
                    yesterday.year,
                    yesterday.month,
                    yesterday.day,
                  );
                  to = DateTime(
                    yesterday.year,
                    yesterday.month,
                    yesterday.day,
                    23,
                    59,
                    59,
                  );
                  break;

                case "آخر 7 أيام":
                  from = now.subtract(const Duration(days: 7));
                  to = now;
                  break;

                case "آخر 30 يوم":
                  from = now.subtract(const Duration(days: 30));
                  to = now;
                  break;

                case "هذا الشهر":
                  from = DateTime(now.year, now.month, 1);
                  to = now;
                  break;

                case "الشهر الماضي":
                  from = DateTime(now.year, now.month - 1, 1);
                  to = DateTime(now.year, now.month, 0, 23, 59, 59);
                  break;

                case "هذه السنة":
                  from = DateTime(now.year, 1, 1);
                  to = now;
                  break;

                case "السنة الماضية":
                  from = DateTime(now.year - 1, 1, 1);
                  to = DateTime(now.year - 1, 12, 31, 23, 59, 59);
                  break;

                case "فترة مخصصة":
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );

                  if (range == null) return;

                  from = range.start;
                  to = range.end;
                  break;
              }

              if (!context.mounted) return;

              widget.onDateChanged?.call(from, to);

            },
          ),
        ],
      ),
    );
  }
}