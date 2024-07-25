import 'package:defect_tracking_system/screens/reviews/providers/review_dropdown_user_provider.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_model.dart';
import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';

class InsertReviewScreen extends StatefulWidget {
  const InsertReviewScreen({super.key});

  @override
  _InsertReviewScreenState createState() => _InsertReviewScreenState();
}

class _InsertReviewScreenState extends State<InsertReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedUser;
  String _reviewText = '';
  String _name = '';
  final String _avatar = '';
  final DateTime _reviewDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Provider.of<UserDropdownProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: const Text('Insert Review'),
      showBackButton: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Consumer<UserDropdownProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.users.isEmpty) {
                    return const CircularProgressIndicator();
                  }
                  return DropdownButtonFormField<String>(
                    value: _selectedUser,
                    hint: const Text('Select User'),
                    items: userProvider.users.map((user) {
                      return DropdownMenuItem<String>(
                        value: user.id,
                        child: Text(user.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedUser = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a user';
                      }
                      return null;
                    },
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Review Text'),
                onChanged: (value) {
                  setState(() {
                    _reviewText = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter review text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Insert the review using ReviewProvider
                    Provider.of<ReviewProvider>(context, listen: false)
                        .addReview(
                      Review(
                        id: '',
                        user: _selectedUser!,
                        reviewText: _reviewText,
                        reviewDate: _reviewDate,
                        likes: [],
                        reviewComments: [],
                        reviewerName: '',
                        reviewerEmail: '',
                        reviewerAvatar: '',
                      ),
                    );
                  }
                  Navigator.of(context).pushReplacementNamed('/reviews');
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
