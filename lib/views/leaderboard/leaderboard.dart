import 'package:deebee_user/components/components.dart';
import 'package:deebee_user/constants/colors.dart';
import 'package:deebee_user/database/preference_handler.dart';
import 'package:deebee_user/database/repository/firebase/user_repository_firebase.dart';
import 'package:deebee_user/models/user_model_firebase.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // panggil user repo firebase
    final UserRepositoryFirebase userRepository = UserRepositoryFirebase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DeebeeAppbar(),
      // BODY (Hero + Scrollable Content)
      body: FutureBuilder<List<UserModelFirebase>>(
        future: userRepository.getLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return _buildEmptyState();
          }

          return CustomScrollView(
            slivers: [
              // Yellow Hero Area
              SliverToBoxAdapter(
                child: Container(
                  // width: double.infinity,
                  // color: AppColors.primaryHoney, // Honey Amber Yellow
                  // padding: const EdgeInsets.symmetric(
                  //   vertical: 32,
                  //   horizontal: 16,
                  // ),
                  height: 130,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryHoney,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Leaderboard',
                        style: TextStyle(
                          color: AppColors.primaryBlack,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Top Karyawan Terbaik',
                        style: TextStyle(
                          color: AppColors.borderBrown,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Ranking List Content Container
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildRankingRow(users[index], index + 1);
                  }, childCount: users.length),
                ),
              ),
            ],
          );
        },
      ), //custscrollview
    );
  }

  // Widget Row Ranking sesuai spesifikasi mobile-friendly (bukan spreadsheet)
  Widget _buildRankingRow(UserModelFirebase user, int rank) {
    final username = user.name;
    final xp = user.xp;
    final isCurrentUser = user.uid == PreferenceHandler.userUid;

    // Definisikan warna medali untuk Top 3
    Color? medalColor;
    if (rank == 1) medalColor = const Color(0xFFFFD700); // Gold / Emas
    if (rank == 2) medalColor = const Color(0xFFC0C0C0); // Silver / Perak
    if (rank == 3) medalColor = const Color(0xFFCD7F32); // Bronze / Perunggu

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primaryCream : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser ? AppColors.borderBrown : AppColors.borderCream,
          width: isCurrentUser ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: Rank (Circle/Angka biasa) + Username
          Row(
            children: [
              SizedBox(
                width: 36, // Sedikit diperlebar agar circle tidak terpotong
                height: 36,
                child: rank <= 3
                    ? Container(
                        decoration: BoxDecoration(
                          color: medalColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          rank.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white, // Angka putih di dalam lingkaran metalik
                          ),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Text(
                          rank.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlack,
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                width: 12,
              ), // Jarak disesuaikan pasca perubahan circle
              Text(
                username,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.w500,
                  color: AppColors.primaryBlack,
                ),
              ),
            ],
          ),
          // Kanan: XP Value
          Text(
            '$xp XP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCurrentUser
                  ? AppColors.borderBrown
                  : AppColors.primaryBlack.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Opsional untuk Empty State jika data kosong
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logodb2-transparan.png",
              height: 100,
              width: 100,
            ),
            Text('Belum ada ranking tersedia.'),
          ],
        ),
      ),
    );
  }
}
