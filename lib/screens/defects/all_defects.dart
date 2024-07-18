import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';

class AllDefectsPage extends StatefulWidget {
  const AllDefectsPage({super.key});

  @override
  State<AllDefectsPage> createState() => _AllDefectsPageState();
}

class _AllDefectsPageState extends State<AllDefectsPage> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        body: Center(
          child: Text('all defects'),
        ),
        pageTitle: Text('All defects'),
        showBackButton: false);
  }
}
