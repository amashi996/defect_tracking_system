import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  final List<Map<String, dynamic>> _leaderBoard = const [
    {
      'name': 'Lee Chen',
      'stars': 10,
      'level': 3,
      'rank': 1,
      'icon': Icons.emoji_events,
    },
    {
      'name': 'Roger Bin',
      'stars': 8,
      'level': 2,
      'rank': 2,
      'icon': Icons.emoji_events,
    },
    {
      'name': 'Linda Chu and Carl Pei',
      'stars': 6,
      'level': 2,
      'rank': 3,
      'icon': Icons.emoji_events,
    },
    {
      'name': 'Anna Mung',
      'stars': 4,
      'level': 1,
      'rank': 4,
      'icon': Icons.emoji_events,
    },
    {
      'name': 'Lindsey',
      'stars': 3,
      'level': 1,
      'rank': 5,
      'icon': Icons.emoji_events,
    },
    {
      'name': 'Jie Lie',
      'stars': 2,
      'level': 1,
      'rank': 6,
      'icon': Icons.emoji_events,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: const Text('Leader Board'),
      showBackButton: false,
      // appBar: AppBar(
      //   title: const Text('Leader Board'),
      //   actions: [
      //     TextButton(
      //       onPressed: () {},
      //       child: const Text(
      //         'Insert as slide',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LeaderboardCard(
                  icon: _leaderBoard[1]['icon'],
                  name: _leaderBoard[1]['name'],
                  stars: _leaderBoard[1]['stars'],
                  level: _leaderBoard[1]['level'],
                  rank: _leaderBoard[1]['rank'],
                ),
                LeaderboardCard(
                  icon: _leaderBoard[0]['icon'],
                  name: _leaderBoard[0]['name'],
                  stars: _leaderBoard[0]['stars'],
                  level: _leaderBoard[0]['level'],
                  rank: _leaderBoard[0]['rank'],
                  isWinner: true,
                ),
                LeaderboardCard(
                  icon: _leaderBoard[2]['icon'],
                  name: _leaderBoard[2]['name'],
                  stars: _leaderBoard[2]['stars'],
                  level: _leaderBoard[2]['level'],
                  rank: _leaderBoard[2]['rank'],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _leaderBoard.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(_leaderBoard[index]['icon']),
                    ),
                    title: Text(_leaderBoard[index]['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${_leaderBoard[index]['stars']} stars'),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, color: Colors.yellow),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderboardCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final int stars;
  final int level;
  final int rank;
  final bool isWinner;

  const LeaderboardCard({
    super.key,
    required this.icon,
    required this.name,
    required this.stars,
    required this.level,
    required this.rank,
    this.isWinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWinner ? Colors.yellow[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('Level $level'),
          const SizedBox(height: 10),
          Text('$stars stars'),
        ],
      ),
    );
  }
}
