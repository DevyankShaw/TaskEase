import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../models/models.dart';
import 'widgets.dart';

class TaskCardLayoutGrid extends StatelessWidget {
  const TaskCardLayoutGrid({
    Key? key,
    required this.crossAxisCount,
    required this.items,
  }) : super(key: key);

  final int crossAxisCount;
  final List<Task> items;

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
          rowSizes: [...items.map((e) => auto).toList()],
          rowGap: 8, // equivalent to mainAxisSpacing
          columnGap: 8, // equivalent to crossAxisSpacing
          // note: there's no childAspectRatio
          children: [
            // render all the cards with *automatic child placement*
            for (var i = 0; i < items.length; i++)
              TaskCard(
                data: items[i],
                onTap: () {},
              ),
          ],
        ),
      ),
    );
  }
}
