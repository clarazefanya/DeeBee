import 'dart:async';

import 'package:deebee_user/components/components_admin.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/module_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/enums/home_mode_model.dart';
import 'package:deebee_user/models/enums/progress_status.dart';
import 'package:deebee_user/models/module_model.dart';
import 'package:deebee_user/services/progress_service.dart';
import 'package:deebee_user/views/home/banner_carousel.dart';
import 'package:deebee_user/views/home/chapter_select.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key, required this.mode, this.onRefresh});

  final HomeMode mode;
  final VoidCallback? onRefresh;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  //test var admin
  bool isPublished = false;

  //Ambil userId n role dari SharedPreferences
  final int? currentUserId = PreferenceHandler.userId;
  final String? currentRole = PreferenceHandler.role;

  // helper get modul status n progress
  Future<Map<String, dynamic>> _getModuleData(int moduleId) async {
    final progressService = ProgressService();

    final status = await progressService.getModuleStatus(
      currentUserId!,
      moduleId,
    );

    final progress = await progressService.getModuleProgress(
      currentUserId!,
      moduleId,
    );

    return {'status': status, 'progress': progress};
  }

  //Future untuk modul
  late Future<List<ModuleModel>> _modulesFuture;

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

    //refresh modul
    _modulesFuture = ModuleRepository().getModules();
  }

  @override
  void dispose() {
    timer?.cancel();
    pageControl.dispose();
    super.dispose();
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
                future: ProgressService().getOverallProgress(currentUserId!),
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
                    //blm tersedia
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Fitur ini belum tersedia pada MVP"),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12),
              ], //...[ ] artinya memasukkan beberapa widget sekaligus ke dalam list children.

              FutureBuilder<List<ModuleModel>>(
                future: _modulesFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final modules = snapshot.data!;
                  if (modules.isEmpty) {
                    return const Center(child: Text("Belum ada modul"));
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: modules.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      //start card module
                      // var ambil data kolom modules
                      final module = modules[index];

                      // status card
                      return FutureBuilder<Map<String, dynamic>>(
                        future: _getModuleData(module.id!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          final status =
                              snapshot.data!['status'] as ProgressStatus;

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
                                        moduleId: module.id!,
                                        moduleName: module.moduleName,
                                      ),
                                    );
                                  } else {
                                    await context.push(
                                      ChapterSelect(
                                        mode: HomeMode.user,
                                        moduleId: module.id!,
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
                                    side: BorderSide(
                                      color: AppColors.borderCream,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      backgroundColor:
                                                          const Color(
                                                            0xFFF9ECDB,
                                                          ),
                                                      color: isStatus == "c"
                                                          ? AppColors
                                                                .statusCompleted
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                )
                                                          : AppColors
                                                                .statusInProgress
                                                                .withValues(
                                                                  alpha: 0.5,
                                                                ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            999,
                                                          ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),

                                                  Text(
                                                    "${(progress * 100).toInt()}%",
                                                  ),
                                                ],
                                              ),

                                              //row edit delete publish utk admin
                                              if (widget.mode ==
                                                  HomeMode.admin) ...[
                                                SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    ButtonActionAdmin(
                                                      text: isPublished
                                                          ? "Unpublish"
                                                          : "Publish",
                                                      bgColor: isPublished
                                                          ? Colors.transparent
                                                          : AppColors
                                                                .primaryCream,
                                                      onPressed: () {
                                                        //blm tersedia
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              "Fitur ini belum tersedia pada MVP",
                                                            ),
                                                          ),
                                                        );
                                                        // setState(() {
                                                        //   isPublished =
                                                        //       !isPublished;
                                                        // });
                                                      },
                                                    ),
                                                    SizedBox(width: 5),
                                                    ButtonActionAdmin(
                                                      text: "Edit",
                                                      bgColor: AppColors
                                                          .blueComponent,
                                                      onPressed: () {
                                                        //blm tersedia
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              "Fitur ini belum tersedia pada MVP",
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    SizedBox(width: 5),
                                                    ButtonActionAdmin(
                                                      text: "Delete",
                                                      bgColor: AppColors
                                                          .redComponent,
                                                      onPressed: () {
                                                        //blm tersedia
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              "Fitur ini belum tersedia pada MVP",
                                                            ),
                                                          ),
                                                        );
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
