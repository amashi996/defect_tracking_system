import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: const Text('Gamified Progress Tracking'),
      showBackButton: false,
      // Scaffold(
      //   appBar: AppBar(
      //     automaticallyImplyLeading: false,
      //     title: const Text('Gamified Progress Tracking'),
      //     actions: [
      //       IconButton(
      //         icon: const Icon(Icons.person),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Row: Gamified Progress Tracking and View My Reviews
            Row(
              children: [
                // Gamified Progress Tracking
                Expanded(
                  child: Container(
                    color: Colors.purple[100],
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gamified Progress Tracking',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.star, size: 40.0, color: Colors.amber),
                            Icon(Icons.verified,
                                size: 40.0, color: Colors.blue),
                            Icon(Icons.check_circle,
                                size: 40.0, color: Colors.green),
                            Icon(Icons.shield,
                                size: 40.0, color: Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('View More'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // View My Reviews
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'View My Reviews',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        const Card(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Review 1'),
                            trailing: Icon(Icons.thumb_up, color: Colors.blue),
                          ),
                        ),
                        const Card(
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Review 2'),
                            trailing: Icon(Icons.thumb_up, color: Colors.blue),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('View More'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Recent Defects
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Recent Defects',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('Defect ID')),
                      DataColumn(label: Text('Defect Description')),
                      DataColumn(label: Text('Priority')),
                      DataColumn(label: Text('Severity')),
                      DataColumn(label: Text('Assignee')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('1')),
                        const DataCell(Text('XXXXXXXXXXXXXXXXXXXXXXXXX')),
                        const DataCell(Text('XXX')),
                        const DataCell(Text('XXX')),
                        const DataCell(Text('XXX')),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {},
                            ),
                          ],
                        )),
                      ]),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/all-defects');
                      },
                      child: const Text('View More'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       TextButton(onPressed: () {}, child: Text('Contact')),
      //       TextButton(onPressed: () {}, child: Text('Terms')),
      //       TextButton(onPressed: () {}, child: Text('Privacy')),
      //     ],
      //   ),
      // ),
    );
  }
}
