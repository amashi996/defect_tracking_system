import 'package:defect_tracking_system/screens/defects/providers/defect.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllDefectsPage extends StatefulWidget {
  const AllDefectsPage({super.key});

  @override
  _AllDefectsPageState createState() => _AllDefectsPageState();
}

class _AllDefectsPageState extends State<AllDefectsPage> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DefectProvider>(context, listen: false).fetchDefects();
    });
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
    final defectProvider = Provider.of<DefectProvider>(context);
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
                      if (kDebugMode) {
                        print('filter');
                      }
                    },
                    icon: const Icon(Icons.filter_list)),
                IconButton(
                    onPressed: () {
                      defectProvider.fetchDefects();
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<DefectProvider>(
                builder: (ctx, defectProvider, _) {
                  if (defectProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (defectProvider.defects.isEmpty) {
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
                      )),
                      DataColumn(
                          label: Text(
                        'Project Title',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Priority',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Severity',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Assignee',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                    actions: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // Navigate to add product page (not implemented here)
                        },
                        label: const Text('Add Defect'),
                      ),
                    ],
                    source:
                        DefectDataTableSource(defectProvider.defects, context),
                    rowsPerPage: defectProvider.defects.length < 10
                        ? defectProvider.defects.length
                        : 10,
                    onPageChanged: (pageIndex) {
                      setState(() {
                        _currentPage = pageIndex;
                      });
                    },
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
      DataCell(Text(defect.projectTitle)),
      DataCell(Text(defect.defectPriority)),
      DataCell(Text(defect.defectSeverity)),
      DataCell(Text(defect.assignedTo)),
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
