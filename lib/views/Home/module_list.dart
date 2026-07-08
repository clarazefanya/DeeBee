import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/components/components_admin.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/firebase/module_repository_firebase.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/enums/home_mode_model.dart';
import 'package:deebee_user/models/enums/progress_status.dart';
import 'package:deebee_user/models/module_model_firebase.dart';
import 'package:deebee_user/services/progress_service.dart';
import 'package:deebee_user/views/home/chapter_select.dart';
import 'package:flutter/material.dart';

class ModuleList extends StatefulWidget {
  const ModuleList({
    super.key,
    required this.mode,
    required this.currentUserUid,
    required this.onRefresh,
  });

  final HomeMode mode;
  final String currentUserUid;
  final VoidCallback? onRefresh;

  @override
  State<ModuleList> createState() => _ModuleListState();
}

class _ModuleListState extends State<ModuleList> {
  //Ambil userUid n role dari SharedPreferences
  final String? currentUserUid = PreferenceHandler.userUid;
  final String? currentRole = PreferenceHandler.role;

  //panggil repo, textfield controller
  final _moduleRepo = ModuleRepositoryFirebase();
  final _moduleNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  //var stream
  late Stream<List<ModuleModelFirebase>> _moduleStream;

  // helper get modul status n progress
  Future<Map<String, dynamic>> _getModuleData(String moduleId) async {
    final progressService = ProgressService();

    final status = await progressService.getModuleStatus(
      currentUserUid!,
      moduleId,
    );

    final progress = await progressService.getModuleProgress(
      currentUserUid!,
      moduleId,
    );

    return {'status': status, 'progress': progress};
  }

  @override
  void initState() {
    super.initState();

    _moduleStream = widget.mode == HomeMode.admin
        ? _moduleRepo.streamAllModules()
        : _moduleRepo.streamPublishedModules();
  }

  @override
  void dispose() {
    super.dispose();
    _moduleNameController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ModuleModelFirebase>>(
      stream: _moduleStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Gagal memuat modul"));
        }
        final modules = snapshot.data ?? [];
        if (modules.isEmpty) {
          return const Center(child: Text("Belum ada modul"));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: modules.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (BuildContext context, int index) {
            //start card module
            // var ambil data kolom modules
            final module = modules[index];

            // status card
            return FutureBuilder<Map<String, dynamic>>(
              future: _getModuleData(module.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }

                final status = snapshot.data!['status'] as ProgressStatus;

                final progress = snapshot.data!['progress'] as double;

                String isStatus;

                switch (status) {
                  case ProgressStatus.completed:
                    isStatus = 'c';
                    break;

                  case ProgressStatus.inProgress:
                    isStatus = 'i';
                    break;

                  case ProgressStatus.locked:
                    isStatus = 'l';
                    break;
                }

                return Stack(
                  children: [
                    //card
                    InkWell(
                      onTap: () async {
                        // jika locked tdk bisa dipencet
                        if (status == ProgressStatus.locked) {
                          return;
                        }

                        if (widget.mode == HomeMode.admin) {
                          context.push(
                            ChapterSelect(
                              mode: HomeMode.admin,
                              moduleId: module.id,
                              moduleName: module.moduleName,
                            ),
                          );
                        } else {
                          await context.push(
                            ChapterSelect(
                              mode: HomeMode.user,
                              moduleId: module.id,
                              moduleName: module.moduleName,
                            ),
                          );
                          setState(() {});
                          widget.onRefresh?.call();
                        }
                      },
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        elevation: isStatus == "l" ? 0 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.borderCream),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //icon box
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isStatus == "c"
                                      ? AppColors.statusCompleted
                                      : isStatus == "i"
                                      ? AppColors.statusInProgress
                                      : AppColors.statusLocked,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isStatus == "c"
                                      ? Icons.check_circle_outline
                                      : isStatus == "i"
                                      ? Icons.play_arrow
                                      : Icons.lock_outline,
                                  color: isStatus == "c"
                                      ? AppColors.statusCompletedIcon
                                      : AppColors.primaryBlack,
                                ),
                              ),
                              SizedBox(width: 16),

                              //right side
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //title
                                    Text(
                                      module.moduleName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 6),

                                    //desc
                                    Text(module.description),
                                    SizedBox(height: 12),

                                    //progress bar
                                    Row(
                                      children: [
                                        Expanded(
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            minHeight: 12,
                                            backgroundColor: const Color(
                                              0xFFF9ECDB,
                                            ),
                                            color: isStatus == "c"
                                                ? AppColors.statusCompleted
                                                      .withValues(alpha: 0.5)
                                                : AppColors.statusInProgress
                                                      .withValues(alpha: 0.5),
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),

                                        Text("${(progress * 100).toInt()}%"),
                                      ],
                                    ),

                                    //row edit delete publish utk admin
                                    if (widget.mode == HomeMode.admin) ...[
                                      SizedBox(height: 6),
                                      Row(
                                        children: [
                                          ButtonActionAdmin(
                                            text: module.isPublished
                                                ? "Unpublish"
                                                : "Publish",
                                            bgColor: module.isPublished
                                                ? Colors.transparent
                                                : AppColors.primaryCream,
                                            onPressed: () async {
                                              await _moduleRepo
                                                  .updatePublishStatus(
                                                    moduleId: module.id,
                                                    isPublished:
                                                        !module.isPublished,
                                                  );

                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    module.isPublished
                                                        ? "Modul berhasil di-unpublish"
                                                        : "Modul berhasil dipublish",
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          ButtonActionAdmin(
                                            text: "Edit",
                                            bgColor: AppColors.blueComponent,
                                            onPressed: () {
                                              _showModuleBottomSheet(
                                                module: module,
                                              );
                                            },
                                          ),
                                          SizedBox(width: 5),
                                          ButtonActionAdmin(
                                            text: "Delete",
                                            bgColor: AppColors.redComponent,
                                            onPressed: () {
                                              _deleteModule(module);
                                            },
                                          ),
                                        ],
                                      ),
                                    ], //if
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    //stack locked
                    if (isStatus == "l")
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryCream.withValues(
                              alpha: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
          //end card module
        );
      },
    );
  }

  //function local utk create/edit modul
  Future<void> _showModuleBottomSheet({ModuleModelFirebase? module}) async {
    _moduleNameController.text = module?.moduleName ?? '';
    _descriptionController.text = module?.description ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module == null ? "Buat Modul Baru" : "Edit Modul",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),

                // Judul Chapter
                const Text(
                  "Nama Modul",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFieldComponent(
                  hinttext: "Masukkan nama modul",
                  textFieldCont: _moduleNameController,
                ),
                const SizedBox(height: 16),

                // Deskripsi Singkat
                const Text(
                  "Deskripsi",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                TextFieldComponent(
                  hinttext: "Masukkan deskripsi",
                  lines: 2,
                  textFieldCont: _descriptionController,
                ),
                const SizedBox(height: 24),

                ButtonComponent(
                  text: "Simpan",
                  bgcolor: AppColors.primaryHoney,
                  onPressed: () async {
                    if (module == null) {
                      //create
                      await _moduleRepo.createModule(
                        moduleName: _moduleNameController.text.trim(),
                        description: _descriptionController.text.trim(),
                      );
                    } else {
                      //edit
                      await _moduleRepo.updateModule(
                        moduleId: module.id,
                        moduleName: _moduleNameController.text.trim(),
                        description: _descriptionController.text.trim(),
                      );
                    }
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          module == null
                              ? "Chapter berhasil dibuat"
                              : "Chapter berhasil diperbarui",
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  //function local utk delete modul
  Future<void> _deleteModule(ModuleModelFirebase module) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Modul'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Yakin ingin menghapus modul ini?'),
            const Text(
              'Semua chapter, level, dan scene di dalam modul ini juga akan ikut dihapus.',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);

              context.pop();
              await _moduleRepo.deleteModuleCascade(module.id);
              if (!mounted) return;

              messenger.showSnackBar(
                const SnackBar(content: Text('Chapter berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
