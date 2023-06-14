import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskProvider.getAllTaskDocuments(reset: true);
    });
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
      child: Selector<TaskProvider, Tuple2<DocumentList?, bool>>(
        selector: (_, taskProvider) =>
            Tuple2(taskProvider.documentList, taskProvider.hasReachedMax),
        builder: (_, taskProvider, __) {
          final documentList = taskProvider.item1;
          final hasReachedMax = taskProvider.item2;
          return documentList != null
              ? documentList.documents.isNotEmpty
                  ? GridView.builder(
                      controller: _scrollController,
                      itemCount: hasReachedMax
                          ? documentList.documents.length
                          : documentList.documents.length + 1,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 0,
                        bottom: 10,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        mainAxisExtent: 192,
                      ),
                      itemBuilder: (_, index) {
                        return index >= documentList.documents.length
                            ? const Center(child: CircularProgressIndicator())
                            : TaskCard(
                                data: Task.fromJson(
                                    documentList.documents[index].data),
                                onTap: () {
                                  context.push(
                                    Routes.task.toPath,
                                    extra: TaskData(
                                      mode: Constants.update,
                                      documentId:
                                          documentList.documents[index].$id,
                                    ),
                                  );
                                },
                              );
                      },
                    )
                  : Center(child: loadAsset(assetName: 'no_task.png'))
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
