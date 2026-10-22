import 'dart:async';

import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/components/components_admin.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/firebase/module_repository_firebase.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/enums/home_mode_model.dart';
import 'package:deebee_user/models/module_model_firebase.dart';
import 'package:deebee_user/services/progress_service.dart';
import 'package:deebee_user/views/home/banner_carousel.dart';
import 'package:deebee_user/views/home/module_list.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key, required this.mode, this.onRefresh});

  final HomeMode mode;
  final VoidCallback? onRefresh;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  //Ambil userUid n role dari SharedPreferences
  final String? currentUserUid = PreferenceHandler.userUid;
  final String? currentRole = PreferenceHandler.role;

  //panggil repo, textfield controller
  final _moduleRepo = ModuleRepositoryFirebase();
  final _moduleNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  //variable dots carousel
  final PageController pageControl = PageController();
  Timer? timer;
  int currentPage = 0;

  //init
  @override
  void initState() {
    super.initState();

    //auto slide carousel
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      if (!pageControl.hasClients) return;
      currentPage++;

      if (currentPage > 2) {
        currentPage = 0;
      }

      pageControl.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pageControl.dispose();
    super.dispose();
    _moduleNameController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // CAROUSEL
        SizedBox(
          height: 180,

          child: PageView(
            controller: pageControl,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            //banner
            children: [banner1(), banner2(), banner3()],
          ),
        ),
        SizedBox(height: 12),
        //dots carousel
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentPage == index
                    ? AppColors.primaryHoney
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(999),
              ),
            );
          }),
        ),

        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PROGRESS BAR PERJALANAN BELAJARMU
              //future builder
              FutureBuilder<double>(
                future: ProgressService().getOverallProgress(currentUserUid!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final progress = snapshot.data!;

                  //card
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCream,
                      // color: AppColors.primaryHoney.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryHoney),
                    ),
                    //column tulisan dan progress bar
                    child: Column(
                      children: [
                        //row text dan angka progress
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //column main text dan subtext
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Perjalanan Belajarmu",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  "Progress belajar SQL",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              "${(progress * 100).toInt()}%",
                              style: TextStyle(
                                color: progress >= 1.0
                                    ? AppColors.statusCompleted
                                    : AppColors.statusInProgress,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFEBDFCE),
                          color: progress >= 1.0
                              ? AppColors.statusCompleted.withValues(alpha: 0.5)
                              : AppColors.statusInProgress.withValues(
                                  alpha: 0.5,
                                ),
                          borderRadius: BorderRadius.circular(9999),
                          minHeight: 16,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 24),

              // MODUL
              Text(
                "Modul",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 12),

              //button create modul utk admin
              if (widget.mode == HomeMode.admin) ...[
                ButtonCreateAdmin(
                  text: "Buat Modul Baru",
                  onPressed: () {
                    _showModuleBottomSheet();
                  },
                ),
                SizedBox(height: 12),
              ], //...[ ] artinya memasukkan beberapa widget sekaligus ke dalam list children.
              // LIST MODUL
              ModuleList(
                key: ValueKey(widget.mode),
                mode: widget.mode,
                currentUserUid: currentUserUid!,
                onRefresh: widget.onRefresh,
              ),
            ],
          ),
        ),
      ],
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
                              ? "Modul berhasil dibuat"
                              : "Modul berhasil diperbarui",
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
}
