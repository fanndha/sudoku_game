/// File: lib/features/leaderboard/presentation/pages/leaderboard_page.dart
/// Main page untuk Leaderboard

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/leaderboard_bloc.dart';
import '../bloc/leaderboard_event.dart';
import '../bloc/leaderboard_state.dart';
import '../widgets/leaderboard_filter.dart';
import '../widgets/leaderboard_header.dart';
import '../widgets/leaderboard_item.dart';
import '../widgets/user_rank_card.dart';

class LeaderboardPage extends StatefulWidget {
  final String initialDifficulty;

  const LeaderboardPage({
    Key? key,
    this.initialDifficulty = 'easy',
  }) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String _selectedDifficulty = 'easy';
  String _selectedFilter = 'all_time';

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = widget.initialDifficulty;
    _loadLeaderboard();
  }

  void _loadLeaderboard() {
    context.read<LeaderboardBloc>().add(
          LoadLeaderboard(
            difficulty: _selectedDifficulty,
            filter: _selectedFilter,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.leaderboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<LeaderboardBloc>().add(
                    const RefreshLeaderboard(),
                  );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Difficulty Selector
          _buildDifficultySelector(),
          
          // Filter Tabs
          LeaderboardFilter(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
              context.read<LeaderboardBloc>().add(
                    ChangeLeaderboardFilter(filter),
                  );
            },
          ),
          
          // Leaderboard Content
          Expanded(
            child: BlocConsumer<LeaderboardBloc, LeaderboardState>(
              listener: (context, state) {
                if (state is LeaderboardUpdateSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Leaderboard berhasil diperbarui!'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (state is LeaderboardUpdateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is LeaderboardLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LeaderboardError) {
                  return _buildError(state.message);
                } else if (state is LeaderboardLoaded) {
                  return _buildLeaderboard(state);
                } else if (state is LeaderboardUpdating) {
                  return _buildLeaderboardWithLoading(state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildDifficultyChip('easy', 'Mudah'),
          const SizedBox(width: 8),
          _buildDifficultyChip('medium', 'Sedang'),
          const SizedBox(width: 8),
          _buildDifficultyChip('hard', 'Sulit'),
          const SizedBox(width: 8),
          _buildDifficultyChip('expert', 'Ahli'),
        ],
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty, String label) {
    final isSelected = _selectedDifficulty == difficulty;
    return Expanded(
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedDifficulty = difficulty);
            context.read<LeaderboardBloc>().add(
                  ChangeLeaderboardDifficulty(difficulty),
                );
          }
        },
        selectedColor: AppColors.getDifficultyColor(difficulty),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : null,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLeaderboard(LeaderboardLoaded state) {
    if (state.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LeaderboardBloc>().add(const RefreshLeaderboard());
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top 3 Podium
          if (state.topThree.isNotEmpty) ...[
            LeaderboardHeader(entries: state.topThree),
            const SizedBox(height: 16),
          ],
          
          // User Rank Card
          if (state.userRank != null) ...[
            UserRankCard(entry: state.userRank!),
            const SizedBox(height: 16),
          ],
          
          // Leaderboard List
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.entries.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return LeaderboardItem(entry: state.entries[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardWithLoading(LeaderboardUpdating state) {
    return Stack(
      children: [
        // Show current leaderboard
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (state.currentUserRank != null) ...[
              UserRankCard(entry: state.currentUserRank!),
              const SizedBox(height: 16),
            ],
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.currentEntries.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return LeaderboardItem(entry: state.currentEntries[index]);
                },
              ),
            ),
          ],
        ),
        // Loading overlay
        Container(
          color: Colors.black26,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada data leaderboard',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jadilah yang pertama!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadLeaderboard,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}