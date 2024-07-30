import 'package:defect_tracking_system/screens/defects/providers/defect_detail_provider.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefectFormScreen extends StatefulWidget {
  const DefectFormScreen({super.key});

  @override
  _DefectFormScreenState createState() => _DefectFormScreenState();
}

class _DefectFormScreenState extends State<DefectFormScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DefectDetailProvider>(context, listen: false)
          .fetchDefectDetails(
              ModalRoute.of(context)!.settings.arguments.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: true,
      pageTitle: const Text('Defect Form'),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: newDefectDetailViewForm(
              context, ModalRoute.of(context)!.settings.arguments.toString())),
    );
  }

  Widget newDefectDetailViewForm(BuildContext context, String defectId) {
    return FutureBuilder(
        future: Provider.of<DefectDetailProvider>(context, listen: false)
            .fetchDefectDetails(defectId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Consumer<DefectDetailProvider>(
            builder: (context, value, child) {
              DefectDetail? defectDetail = value.defect;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: (viewDefectDetailForm(defectDetail!, context)),
              );
            },
          );
        });
  }
}

Widget viewDefectDetailForm(DefectDetail defect, BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final defectProvider = Provider.of<DefectDetailProvider>(context);
  return Form(
    key: formKey,
    child: SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            initialValue: defect.defectTitle,
            decoration: const InputDecoration(labelText: 'Defect Title'),
            onSaved: (value) {
              defect.defectTitle = value!;
            },
          ),
          DropdownButtonFormField<String>(
            value: defect.defectStatus,
            decoration: const InputDecoration(labelText: 'Status'),
            items: [
              'New',
              'In Progress',
              'Resolved',
              'Failed',
              'Closed',
              'Reopen'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              defect.defectStatus = value!;
            },
          ),
          DropdownButtonFormField<String>(
            value: defect.defectPriority,
            decoration: const InputDecoration(labelText: 'Priority'),
            items: ['High', 'Medium', 'Low'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              defect.defectPriority = value!;
            },
          ),
          DropdownButtonFormField<String>(
            value: defect.defectSeverity,
            decoration: const InputDecoration(labelText: 'Severity'),
            items:
                ['Critical', 'Major', 'Minor', 'Cosmetic'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              defect.defectSeverity = value!;
            },
          ),
          TextFormField(
            initialValue: defect.defectDescription,
            decoration: const InputDecoration(labelText: 'Defect Description'),
            onSaved: (value) {
              defect.defectDescription = value!;
            },
          ),
          TextFormField(
            initialValue: defect.reproduceSteps,
            decoration: const InputDecoration(labelText: 'Steps to Reproduce'),
            onSaved: (value) {
              defect.reproduceSteps = value!;
            },
          ),
          TextFormField(
            initialValue: defect.expectedResult,
            decoration: const InputDecoration(labelText: 'Expected Result'),
            onSaved: (value) {
              defect.expectedResult = value!;
            },
          ),
          TextFormField(
            initialValue: defect.actualResult,
            decoration: const InputDecoration(labelText: 'Actual Result'),
            onSaved: (value) {
              defect.actualResult = value!;
            },
          ),
          TextFormField(
            initialValue: defect.assignee,
            decoration: const InputDecoration(labelText: 'Assignee'),
            onSaved: (value) {
              defect.assignee = value!;
            },
          ),
          TextFormField(
            initialValue: defect.reporter,
            decoration: const InputDecoration(labelText: 'Reporter'),
            onSaved: (value) {
              defect.reporter = value!;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                defectProvider.updateDefect(defect);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Defect Updated')),
                );
              }
            },
            child: const Text('Save'),
          ),
          const SizedBox(height: 20),
          const Text('Comments'),
          ...defect.defectComment.map((comment) {
            return ListTile(
              title: Text(comment.defectComment),
              subtitle: Text(comment.user),
            );
          }),
          ElevatedButton(
            onPressed: () {
              final newComment = Comment(
                user: 'userId',
                defectComment: 'New Comment',
                commentDate: DateTime.now(),
                commentAttachment: [],
              );
              defectProvider.addComment(newComment);
            },
            child: const Text('Add Comment'),
          ),
          const SizedBox(height: 20),
          const Text('Attachments'),
          ...defect.defectAttachment.map((attachment) {
            return ListTile(
              title: Text(attachment.fileName),
              subtitle: Text(attachment.url),
            );
          }),
          ElevatedButton(
            onPressed: () {
              final newAttachment = Attachment(
                fileName: 'fileName',
                mimetype: 'image/jpeg',
                size: 12345,
                url: 'https://example.com',
              );
              defectProvider.addAttachment(newAttachment);
            },
            child: const Text('Add Attachment'),
          ),
        ],
      ),
    ),
  );
}
