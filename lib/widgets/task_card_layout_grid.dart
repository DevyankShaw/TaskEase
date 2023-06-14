import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';
import '../utilities/utilities.dart';
import 'widgets.dart';

class TaskCardLayoutGrid extends StatefulWidget {
  const TaskCardLayoutGrid({Key? key}) : super(key: key);

  @override
  State<TaskCardLayoutGrid> createState() => _TaskCardLayoutGridState();
}

class _TaskCardLayoutGridState extends State<TaskCardLayoutGrid> {
  late final _scrollController = ScrollController();
  late final _taskProvider = context.read<TaskProvider>();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _taskProvider.getAllTaskDocuments(reset: true);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (!_isBottom) {
      return;
    }

    _taskProvider.getAllTaskDocuments();
  }

  bool get _isBottom {
    return _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    final deviceName =
        getDeviceByScreenWidth(MediaQuery.of(context).size.width);
    final crossAxisCount = deviceName == Constants.mobileDevice
        ? 2
        : deviceName == Constants.tabletDevice
            ? 4
            : 6;
    return Expanded(
      child: Selector<TaskProvider, DocumentList?>(
        selector: (_, taskProvider) => taskProvider.documentList,
        builder: (_, documentList, __) {
          return documentList != null
              ? documentList.documents.isNotEmpty
                  ? ListView(
                      controller: _scrollController
                        ..addListener(() => _onScroll()),
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 0,
                        bottom: 10,
                      ),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        LayoutGrid(
                          // set some flexible track sizes based on the crossAxisCount
                          columnSizes: [
                            ...List.generate(crossAxisCount, (_) => 1.fr)
                                .toList()
                          ],
                          // set all the row sizes to auto (self-sizing height)
                          rowSizes: [
                            ...List.generate(documentList.total, (_) => auto)
                                .toList()
                          ],
                          rowGap: 8, // equivalent to mainAxisSpacing
                          columnGap: 8, // equivalent to crossAxisSpacing
                          // note: there's no childAspectRatio
                          children: [
                            // render all the cards with *automatic child placement*
                            ...documentList.documents.map(
                              (document) {
                                final task = Task.fromJson(document.data);
                                return TaskCard(
                                  data: task,
                                  onTap: () {
                                    context.push(
                                      Routes.task.toPath,
                                      extra: TaskData(
                                        mode: Constants.update,
                                        documentId: document.$id,
                                      ),
                                    );
                                  },
                                );
                              },
                            ).toList()
                          ],
                        ),
                        if (documentList.documents.length != documentList.total)
                          const Center(child: CircularProgressIndicator()),
                      ],
                    )
                  : Center(child: loadAsset(assetName: 'no_task.png'))
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
