import 'package:defect_tracking_system/screens/leaderboard/providers/leaderboard_provider.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  late Future<void> _fetchLeaderboardFuture;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardFuture =
        Provider.of<LeaderboardProvider>(context, listen: false)
            .fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = Provider.of<LeaderboardProvider>(context);

    return AppScaffold(
      pageTitle: const Text('Leaderboard'),
      showBackButton: false,
      body: FutureBuilder(
        future: _fetchLeaderboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: leaderboardProvider.leaderboard.length,
              itemBuilder: (context, index) {
                final entry = leaderboardProvider.leaderboard[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(entry.avatar, scale: 1),
                  ),
                  title: Text(entry.name),
                  subtitle: Text(entry.email),
                  trailing: Text('Points: ${entry.totalPoints}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}