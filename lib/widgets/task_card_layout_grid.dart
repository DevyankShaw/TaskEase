import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../utilities/utilities.dart';
import 'widgets.dart';

class TaskCardLayoutGrid extends StatelessWidget {
  const TaskCardLayoutGrid({
    Key? key,
    required this.crossAxisCount,
    required this.tasks,
  }) : super(key: key);

  final int crossAxisCount;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 0,
          bottom: 10,
        ),
        physics: const BouncingScrollPhysics(),
        child: LayoutGrid(
          // set some flexible track sizes based on the crossAxisCount
          columnSizes: [
            ...List.generate(crossAxisCount, (index) => 1.fr).toList()
          ],
          // set all the row sizes to auto (self-sizing height)
          rowSizes: [...tasks.map((e) => auto).toList()],
          rowGap: 8, // equivalent to mainAxisSpacing
          columnGap: 8, // equivalent to crossAxisSpacing
          // note: there's no childAspectRatio
          children: [
            // render all the cards with *automatic child placement*
            ...tasks
                .map(
                  (task) => TaskCard(
                    data: task,
                    onTap: () {
                      context.push(
                        Routes.task.toPath,
                        extra: TaskData(
                          mode: Constants.update,
                          data: task,
                        ),
                      );
                    },
                  ),
                )
                .toList()
          ],
        ),
      ),
    );
  }
}
