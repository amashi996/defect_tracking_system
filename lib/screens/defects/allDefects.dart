import 'package:defect_tracking_system/screens/defects/providers/defect_provider.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefectsPage extends StatefulWidget {
  const DefectsPage({super.key});

  @override
  _DefectsPageState createState() => _DefectsPageState();
}

class _DefectsPageState extends State<DefectsPage> {
  int _currentPage = 0;
  late Future<void> _fetchDefectsFuture;

  @override
  void initState() {
    super.initState();
    _fetchDefectsFuture =
        Provider.of<DefectsProvider>(context, listen: false).fetchDefects();
  }

  Widget searchBar() {
    final searchController = TextEditingController();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defectsProvider = Provider.of<DefectsProvider>(context);

    return AppScaffold(
      pageTitle: const Text('All Defects'),
      showBackButton: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                searchBar(),
                const SizedBox(width: 16),
                IconButton(
                    onPressed: () {
                      // Implement filter functionality
                      print('filter');
                    },
                    icon: const Icon(Icons.filter_list)),
                IconButton(
                    onPressed: () {
                      // Refresh defects
                      setState(() {
                        _fetchDefectsFuture =
                            defectsProvider.fetchDefects();
                      });
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder(
                future: _fetchDefectsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    if (defectsProvider.defects.isEmpty) {
                      return const Center(child: Text('No defects found.'));
                    }

                    return PaginatedDataTable(
                      header: const Text('All Defects'),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Defect ID',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Defect Title',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Assignee',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        /*DataColumn(
                          label: Text(
                            'Created Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),*/
                        
                        DataColumn(
                          label: Text(
                            'Actions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      actions: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            // Navigate to add defect page (not implemented here)
                          },
                          label: const Text('Add Defect'),
                        ),
                      ],
                      source: DefectDataTableSource(
                          defectsProvider.defects, context),
                      rowsPerPage: defectsProvider.defects.length < 10
                          ? defectsProvider.defects.length
                          : 10,
                      onPageChanged: (pageIndex) {
                        setState(() {
                          _currentPage = pageIndex;
                        });
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DefectDataTableSource extends DataTableSource {
  final List<Defect> defects;
  final BuildContext context;

  DefectDataTableSource(this.defects, this.context);

  @override
  DataRow getRow(int index) {
    final defect = defects[index];
    return DataRow(cells: [
      DataCell(Text(defect.id)),
      DataCell(Text(defect.defectTitle)),
      DataCell(Text(defect.defectStatus)),
      DataCell(Text(defect.assignedTo)),
      //DataCell(Text(defect.createdDate.toString())),
      DataCell(
        ElevatedButton(
          onPressed: () {
            // Implement navigation to defect detail page
            // Navigator.of(context).pushNamed(
            //   DefectDetailPage.routeName,
            //   arguments: defect.id,
            // );
          },
          child: const Text('Manage'),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => defects.length;

  @override
  int get selectedRowCount => 0;
}
