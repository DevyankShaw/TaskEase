import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import '../utilities/utilities.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    Key? key,
    required this.data,
    required this.onTap,
  }) : super(key: key);

  final Task data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.all(2),
          color: getTaskCardBackgroundColor(data.taskStatus),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.taskName,
                  style: textTheme.titleLarge!.copyWith(fontSize: 18),
                ),
                if (data.remarks != null)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        data.remarks!,
                        style: textTheme.bodyMedium!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    if (data.deadline != null)
                      Tooltip(
                        message: 'Deadline',
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, right: 4),
                          child: Text(
                            DateFormat(_getCustomDateFormat())
                                .format(data.deadline!),
                            style: textTheme.labelMedium!,
                          ),
                        ),
                      ),
                    Tooltip(
                      message: getTaskStatusName(data.taskStatus),
                      child: Icon(
                        getTaskStatusIcon(data.taskStatus),
                        size: 18,
                      ),
                    ),
                    if (data.isImportant)
                      const Tooltip(
                        message: 'Important',
                        child: Icon(
                          Icons.priority_high_outlined,
                          size: 18,
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCustomDateFormat() {
    if (DateUtils.isSameDay(data.deadline, DateTime.now())) {
      return 'hh:mm a';
    } else if (data.deadline!.year == DateTime.now().year) {
      return 'd MMM, h:mm a';
    } else {
      return 'd MMM yyyy';
    }
  }
}
