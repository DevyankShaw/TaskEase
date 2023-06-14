import 'package:appwrite_hackathon/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../utilities/utilities.dart';

class TaskScreen extends StatefulWidget {
  final TaskData taskData;

  const TaskScreen({
    super.key,
    required this.taskData,
  });

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late final _formKey = GlobalKey<FormState>();

  late final _taskNameController = TextEditingController();
  late final _taskStatusController = TextEditingController();
  late final _deadlineController = TextEditingController();
  late final _remarksController = TextEditingController();

  TaskStatus _taskStatus = TaskStatus.notStarted;
  DateTime? _deadline;
  bool _isImportant = false;
  bool _submitting = false;
  bool _loadingTask = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    if (!mounted) _taskStatusController.dispose();
    _deadlineController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  _init() async {
    if (widget.taskData.mode == Constants.add) {
      _taskStatusController.text = getTaskStatusName(_taskStatus);
    } else {
      await _getTask();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text('${widget.taskData.mode} Task'),
        actions: [
          if (widget.taskData.mode == Constants.update && !_loadingTask)
            IconButton(
              tooltip: 'Delete',
              onPressed: () async {
                setState(() {
                  _submitting = true;
                });

                showInfoMessage(
                  context,
                  message: 'Deleting Task',
                  onUndoPressed: () {
                    setState(() {
                      _submitting = false;
                    });
                  },
                );

                await Future.delayed(const Duration(milliseconds: 4000),
                    () async {
                  if (_submitting) {
                    await context
                        .read<TaskProvider>()
                        .deleteTask(documentId: widget.taskData.documentId!);

                    await context
                        .read<TaskProvider>()
                        .getAllTaskDocuments(reset: true);

                    showSuccessMessage(
                      context,
                      message: 'Successfully deleted task',
                    );

                    context.pop();
                  }
                });
              },
              icon: const Icon(Icons.auto_delete_outlined),
            ),
        ],
      ),
      body: !_loadingTask
          ? SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _taskNameController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text('Task Name'),
                        hintText: 'Enter Task Name',
                        prefixIcon: Icon(Icons.task_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Task Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    IgnorePointer(
                      ignoring: widget.taskData.mode == Constants.add,
                      child: DropdownMenu<TaskStatus>(
                        width: MediaQuery.of(context).size.width - 24,
                        initialSelection: _taskStatus,
                        controller: _taskStatusController,
                        label: const Text('Task Status'),
                        leadingIcon: Icon(getTaskStatusIcon(_taskStatus)),
                        inputDecorationTheme: const InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        dropdownMenuEntries: TaskStatus.values
                            .map(
                              (taskStatus) => DropdownMenuEntry(
                                label: getTaskStatusName(taskStatus),
                                value: taskStatus,
                              ),
                            )
                            .toList(),
                        onSelected: (TaskStatus? status) {
                          setState(() {
                            _taskStatus = status ?? TaskStatus.notStarted;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _deadlineController,
                      readOnly: true,
                      onTap: () async {
                        _deadline = await _showDateTimePicker(_deadline);

                        if (_deadline != null) {
                          _deadlineController.text =
                              DateFormat('dd/MM/yyyy hh:mm a')
                                  .format(_deadline!);
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('Deadline'),
                        hintText: 'Select Deadline',
                        prefixIcon: Icon(Icons.timer_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.priority_high_outlined),
                      title: const Text('Important'),
                      shape: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      trailing: Switch(
                        value: _isImportant,
                        onChanged: (bool value) {
                          setState(() {
                            _isImportant = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _remarksController,
                      maxLines: 4,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        label: Text('Remarks'),
                        hintText: 'Enter Remarks',
                        prefixIcon: Icon(Icons.feed_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _submitting
                        ? const CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: () => _submit(),
                            icon: Icon(
                              widget.taskData.mode == Constants.add
                                  ? Icons.post_add_outlined
                                  : Icons.edit_note_outlined,
                            ),
                            label: const Text('Submit'),
                            style: ElevatedButton.styleFrom(
                                fixedSize: const Size(120, 40)),
                          )
                  ],
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<DateTime?> _showDateTimePicker([DateTime? initialDateTime]) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 10),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        initialDateTime ?? selectedDate,
      ),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }

  Future<void> _getTask() async {
    try {
      setState(() {
        _loadingTask = true;
      });

      final documentId = widget.taskData.documentId;

      if (documentId == null) {
        showErrorMessage(
          context,
          message: 'Something went wrong. Please try again later',
        );
        debugPrint('Document Id can\'t be null');
        return;
      }

      final taskData =
          await context.read<TaskProvider>().getTask(documentId: documentId);

      _taskNameController.text = taskData.taskName;
      _taskStatus = taskData.taskStatus;
      _taskStatusController.text = getTaskStatusName(_taskStatus);
      _deadline = taskData.deadline;
      _deadlineController.text = _deadline != null
          ? DateFormat('dd/MM/yyyy hh:mm a').format(_deadline!)
          : '';
      _isImportant = taskData.isImportant;
      _remarksController.text = taskData.remarks ?? '';

      setState(() {
        _loadingTask = false;
      });
    } catch (error, stackTrace) {
      showErrorMessage(context, message: error.toString());
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _submitting = true;
        });

        final remarks = _remarksController.text.trim();

        if (widget.taskData.mode == Constants.add) {
          final data = Task(
            taskName: _taskNameController.text.trim(),
            taskStatus: _taskStatus,
            createdAt: DateTime.now(),
            createdBy: '',
            deadline: _deadline,
            isImportant: _isImportant,
            remarks: remarks.isNotEmpty ? remarks : null,
          );

          await context.read<TaskProvider>().addTask(taskData: data);
        } else {
          final existingData = await context
              .read<TaskProvider>()
              .getTask(documentId: widget.taskData.documentId!);

          final data = Task(
            taskName: _taskNameController.text.trim(),
            taskStatus: _taskStatus,
            createdAt: existingData.createdAt,
            createdBy: existingData.createdBy,
            deadline: _deadline,
            isImportant: _isImportant,
            remarks: remarks.isNotEmpty ? remarks : null,
          );

          await context.read<TaskProvider>().updateTask(
                documentId: widget.taskData.documentId!,
                taskData: data,
              );
        }

        await context.read<TaskProvider>().getAllTaskDocuments(reset: true);

        showSuccessMessage(
          context,
          message: 'Successfully ${widget.taskData.mode.toLowerCase()}ed task',
        );

        context.pop();
      } catch (error, stackTrace) {
        setState(() {
          _submitting = false;
        });
        showErrorMessage(context, message: error.toString());
        debugPrint('Error $error occurred at stackTrace $stackTrace');
      }
    }
  }
}
