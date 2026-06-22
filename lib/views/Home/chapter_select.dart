import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/components/components_admin.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/chapter_repository.dart';
import 'package:deebee_user/extension/navigator.dart';
import 'package:deebee_user/models/chapter_model.dart';
import 'package:deebee_user/models/enums/home_mode_model.dart';
import 'package:deebee_user/models/enums/progress_status.dart';
import 'package:deebee_user/services/progress_service.dart';
import 'package:deebee_user/views/home/level_select.dart';
import 'package:flutter/material.dart';

class ChapterSelect extends StatefulWidget {
  const ChapterSelect({
    super.key,
    required this.mode,
    required this.moduleId,
    required this.moduleName,
  });

  final HomeMode mode;
  final int moduleId;
  final String moduleName;

  @override
  State<ChapterSelect> createState() => _ChapterSelectState();
}

class _ChapterSelectState extends State<ChapterSelect> {
  //future di chapter
  late Future<List<ChapterModel>> _chaptersFuture;

  //Ambil userID n role dari SharedPreferences
  final int? currentUserId = PreferenceHandler.userId;
  final String? currentRole = PreferenceHandler.role;

  @override
  void initState() {
    super.initState();
    _chaptersFuture = ChapterRepository().getChaptersByModule(widget.moduleId);
  }

  // helper get chapter status n progress
  Future<Map<String, dynamic>> _getChapterData(int chapterId) async {
    final progressService = ProgressService();

    final status = await progressService.getChapterStatus(
      currentUserId!,
      chapterId,
    );

    final progress = await progressService.getChapterProgress(
      currentUserId!,
      chapterId,
    );

    return {'status': status, 'progress': progress};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //button back dan row nama modul yg dipilih
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop(true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.moduleName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                //button create chapter utk admin
                if (widget.mode == HomeMode.admin) ...[
                  ButtonCreateAdmin(
                    text: "Buat Chapter Baru",
                    onPressed: () {
                      //blm tersedia
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Fitur ini belum tersedia pada MVP"),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                ],

                FutureBuilder<List<ChapterModel>>(
                  future: _chaptersFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final chapters = snapshot.data!;
                    if (chapters.isEmpty) {
                      return const Center(child: Text("Belum ada chapter"));
                    }

                    //listview chapter
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: chapters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (BuildContext context, int index) {
                        //start card chapter
                        // var ambil data kolom chapters
                        final chapter = chapters[index];

                        return FutureBuilder<Map<String, dynamic>>(
                          future: _getChapterData(chapter.id!),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox.shrink();
                            }

                            final status =
                                snapshot.data!['status'] as ProgressStatus;

                            final progress =
                                snapshot.data!['progress'] as double;

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
                                        LevelSelect(
                                          mode: HomeMode.admin,
                                          chapterId: chapter.id!,
                                          chapterName: "Chapter ${index + 1}",
                                          chapterTitle: chapter.chapterTitle,
                                          chapterLongDesc: chapter.longDesc,
                                        ),
                                      );
                                    } else {
                                      await context.push(
                                        LevelSelect(
                                          mode: HomeMode.user,
                                          chapterId: chapter.id!,
                                          chapterName: "Chapter ${index + 1}",
                                          chapterTitle: chapter.chapterTitle,
                                          chapterLongDesc: chapter.longDesc,
                                        ),
                                      );
                                      setState(() {});
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //row status bar dan chapter brp
                                          Row(
                                            children: [
                                              //chapter brp
                                              Text(
                                                "Chapter ${index + 1}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 8),

                                              //status bar
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 2,
                                                  horizontal: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        9999,
                                                      ),
                                                  color: isStatus == "c"
                                                      ? AppColors
                                                            .statusCompleted
                                                            .withValues(
                                                              alpha: 0.3,
                                                            )
                                                      : isStatus == "i"
                                                      ? AppColors
                                                            .statusInProgress
                                                            .withValues(
                                                              alpha: 0.3,
                                                            )
                                                      : AppColors.statusLocked,
                                                ),
                                                child: Text(
                                                  isStatus == "c"
                                                      ? "COMPLETED"
                                                      : isStatus == "i"
                                                      ? "IN PROGRESS"
                                                      : "LOCKED",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: isStatus == "c"
                                                        ? AppColors
                                                              .statusCompleted
                                                        : isStatus == "i"
                                                        ? AppColors
                                                              .statusInProgress
                                                        : AppColors
                                                              .primaryBlack,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),

                                          //nama chapter
                                          Text(
                                            chapter.chapterTitle,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          // SizedBox(height: 6),

                                          //desc chapter
                                          Text(
                                            chapter.shortDesc,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 16),

                                          //row progress dan angka progress
                                          Row(
                                            children: [
                                              Text(
                                                "Progress",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Spacer(),
                                              Text(
                                                "${(progress * 100).toInt()}%",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),

                                          //progress bar
                                          LinearProgressIndicator(
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

                                          //row edit delete utk admin
                                          if (widget.mode ==
                                              HomeMode.admin) ...[
                                            SizedBox(height: 6),
                                            Row(
                                              children: [
                                                ButtonActionAdmin(
                                                  text: "Edit",
                                                  bgColor:
                                                      AppColors.blueComponent,
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
                                                  bgColor:
                                                      AppColors.redComponent,
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
                                  ),
                                ),

                                //overlay locked
                                if (isStatus == "l")
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryCream
                                            .withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                      //end card chapter
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
