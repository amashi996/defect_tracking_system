import 'package:defect_tracking_system/utils/app_scafold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:defect_tracking_system/screens/reviews/providers/review_provider.dart';
import 'package:defect_tracking_system/screens/profile/providers/achievement_provider.dart';
import 'package:defect_tracking_system/screens/profile/providers/badge_provider.dart';
import 'package:defect_tracking_system/screens/profile/providers/user_achievement_provider.dart';
import 'package:defect_tracking_system/screens/profile/providers/user_badge_provider.dart';
import 'package:defect_tracking_system/screens/profile/providers/logged_user_provider.dart';
import 'package:defect_tracking_system/screens/profile/models/logged_user_model.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch reviews when the profile page is loaded
    Future.microtask(() {
      Provider.of<ReviewProvider>(context, listen: false)
          .fetchReceivedReviews();
      Provider.of<ReviewProvider>(context, listen: false).fetchSentReviews();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackButton: false,
      pageTitle: const Text('User Profile'),
      body: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.person), text: 'My Profile'),
              Tab(icon: Icon(Icons.reviews), text: 'My Reviews'),
              Tab(icon: Icon(Icons.badge), text: 'My Badges'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            MyProfileTab(),
            MyReviewsTab(),
            MyBadgesTab(),
          ],
        ),
      ),
    );
  }
}

class MyProfileTab extends StatelessWidget {
  const MyProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<ProfileProvider>(context, listen: false).fetchLoggedUserProfile(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              Profile? profile = profileProvider.profile;

              if (profile == null) {
                return const Center(child: Text('Profile data not available.'));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBasicInformationSection(context, profile),
                      _buildEducationSection(context, profile),
                      _buildExperienceSection(context, profile),
                      _buildSkillsSection(context, profile),
                      _buildSocialLinksSection(context, profile),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget content, bool initiallyExpanded = false}) {
    return ExpansionTile(
      initiallyExpanded: initiallyExpanded,
      title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      children: [content],
    );
  }

  Widget _buildBasicInformationSection(BuildContext context, Profile profile) {
    return _buildSection(
      context,
      title: 'Basic Information',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildField('Name', profile.name)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('GitHub Username', profile.githubUsername)), // Added GitHub Username field
              
            ],
          ),
          const SizedBox(height: 16), // Added space below the content
          Row(
            children: [
              Expanded(child: _buildField('Location', profile.location ?? 'N/A')),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Website', profile.website)), // Added Website field
            ],
          ),
          const SizedBox(height: 16), // Added space below the content
          Row(
            children: [
              Expanded(child: _buildField('Member Since', profile.date?.toLocal().toString().split(' ')[0])), // Added Location field
              Expanded(child: Container()), // Empty Expanded to keep alignment consistent
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }


  Widget _buildExperienceSection(BuildContext context, Profile profile) {
    return _buildSection(
      context,
      title: 'Experience',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: profile.experience!.map((exp) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildField('Title', exp.title)),
                      Expanded(child: Container()), // Empty Expanded to keep alignment consistent
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildField('Company', exp.company)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildField('Location', exp.location)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildField('From', exp.from?.toLocal().toString().split(' ')[0] ?? '')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildField('To', exp.to?.toLocal().toString().split(' ')[0] ?? 'Present')),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEducationSection(BuildContext context, Profile profile) {
    return _buildSection(
      context,
      title: 'Education',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: profile.education!.map((edu) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildField('School', edu.school)),
                      Expanded(child: Container()), // Empty Expanded to keep alignment consistent
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildField('Degree', edu.degree)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildField('Field of Study', edu.fieldOfStudy)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildField('From', edu.from?.toLocal().toString().split(' ')[0] ?? '')),
                      const SizedBox(width: 16),
                      Expanded(child: _buildField('To', edu.to?.toLocal().toString().split(' ')[0] ?? 'Present')),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildField(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Reduced font size for labels
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(BuildContext context, Profile profile) {
    String skillsText = profile.skills!.join(', ');

    return _buildSection(
      context,
      title: 'Skills',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skills TextFormField with bottom padding
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextFormField(
              initialValue: _formatSkillsText(skillsText),
              readOnly: true,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatSkillsText(String skillsText) {
    List<String> skills = skillsText.split(', ');
    List<String> rows = [];
    int i = 0;

    while (i < skills.length) {
      String rowText = skills.skip(i).take(10).join(', ');
      rows.add(rowText);
      i += 10;
    }

    return rows.join('\n');
  }

  Widget _buildSocialLinksSection(BuildContext context, Profile profile) {
    return _buildSection(
      context,
      title: 'Social Links',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSocialLinkField('LinkedIn', profile.social?.linkedin ?? 'N/A'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialLinkField('Twitter', profile.social?.twitter ?? 'N/A'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSocialLinkField('YouTube', profile.social?.youtube ?? 'N/A'),
              ),
              Expanded(
                child: Container(), // Empty Expanded to keep alignment consistent
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinkField(String label, String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Reduced font size for labels
        const SizedBox(height: 8),
        TextFormField(
          initialValue: url,
          readOnly: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class MyReviewsTab extends StatefulWidget {
  const MyReviewsTab({super.key});

  @override
  _MyReviewsTabState createState() => _MyReviewsTabState();
}

class _MyReviewsTabState extends State<MyReviewsTab> {
  int receivedPage = 1;
  int sentPage = 1;

  bool receivedExpanded = true;
  bool sentExpanded = false;

  @override
  Widget build(BuildContext context) {
    final receivedReviews = context.watch<ReviewProvider>().receivedReviews;
    final sentReviews = context.watch<ReviewProvider>().sentReviews;

    return ListView(
      children: [
        ExpansionTile(
          leading: Icon(Icons.reviews,
              color: receivedExpanded ? Colors.blue : Colors.black),
          title: Text(
            'Received Reviews',
            style:
                TextStyle(color: receivedExpanded ? Colors.blue : Colors.black),
          ),
          initiallyExpanded: receivedExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              receivedExpanded = expanded;
            });
          },
          children: [
            if (receivedReviews.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Sorry, you did not receive any reviews from other users yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              PaginatedReviews(
                reviews: receivedReviews
                    .map((review) => ReviewItem(
                          reviewerName: review.reviewerName,
                          reviewerEmail: review.reviewerEmail,
                          reviewerAvatar: review.reviewerAvatar,
                          reviewText: review.reviewText,
                        ))
                    .toList(),
                currentPage: receivedPage,
                onPageChanged: (page) {
                  setState(() {
                    receivedPage = page;
                  });
                },
              ),
          ],
        ),
        ExpansionTile(
          leading: Icon(Icons.send,
              color: sentExpanded ? Colors.blue : Colors.black),
          title: Text(
            'Sent Reviews',
            style: TextStyle(color: sentExpanded ? Colors.blue : Colors.black),
          ),
          initiallyExpanded: sentExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              sentExpanded = expanded;
            });
          },
          children: [
            if (sentReviews.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Oops, you did not send any reviews for any user yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              PaginatedReviews(
                reviews: sentReviews
                    .map((review) => ReviewItem(
                          reviewerName: review.reviewerName,
                          reviewerEmail: review.reviewerEmail,
                          reviewerAvatar: review.reviewerAvatar,
                          reviewText: review.reviewText,
                        ))
                    .toList(),
                currentPage: sentPage,
                onPageChanged: (page) {
                  setState(() {
                    sentPage = page;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }
}

class PaginatedReviews extends StatelessWidget {
  final List<ReviewItem> reviews;
  final int currentPage;
  final Function(int) onPageChanged;

  const PaginatedReviews({
    super.key,
    required this.reviews,
    required this.currentPage,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    const int reviewsPerPage = 5;
    int totalPages = (reviews.length / reviewsPerPage).ceil();
    int startIndex = (currentPage - 1) * reviewsPerPage;
    int endIndex = (startIndex + reviewsPerPage).clamp(0, reviews.length);

    List<ReviewItem> currentReviews = reviews.sublist(startIndex, endIndex);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: currentReviews.length,
          itemBuilder: (context, index) {
            final review = currentReviews[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(review.reviewerAvatar),
              ),
              title: Text('${review.reviewerName} (${review.reviewerEmail})'),
              subtitle: Text(review.reviewText),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              return GestureDetector(
                onTap: () {
                  onPageChanged(index + 1);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: currentPage == index + 1 ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class MyBadgesTab extends StatelessWidget {
  const MyBadgesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of sub-tabs
      child: Column(
        children: [
          Container(
            color: Colors.white, // Background color for the TabBar
            child: const TabBar(
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events, color: Colors.amber), // Icon for Achievements
                      SizedBox(width: 8.0),
                      Text('My Achievements'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.blue), // Icon for Badges
                      SizedBox(width: 8.0),
                      Text('My Badges'),
                    ],
                  ),
                ),
              ],
              labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold), // Same style as main titles
              indicatorColor: Colors.blue,
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                // Content for My Achievements
                MyAchievementsContent(),
                // Content for My Badges
                MyBadgesContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyAchievementsContent extends StatelessWidget {
  const MyAchievementsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Provider.of<AchievementProvider>(context, listen: false).fetchAchievements(),
        Provider.of<UserAchievementProvider>(context, listen: false).fetchUserAchievements(),
      ]),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Consumer<UserAchievementProvider>(
                      builder: (ctx, userAchievementProvider, _) {
                        final earnedAchievements = userAchievementProvider.userAchievements;
                        return ExpansionTile(
                          leading: const Icon(Icons.star, color: Colors.amber),
                          title: const Text(
                            'Earned Achievements',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          initiallyExpanded: true,
                          children: earnedAchievements.isEmpty
                              ? [
                                  const Center(child: Text('No achievements earned yet.'))
                                ]
                              : [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    itemCount: earnedAchievements.length,
                                    itemBuilder: (ctx, index) {
                                      final achievement = earnedAchievements[index];
                                      return Card(
                                        elevation: 4.0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.emoji_events,
                                                color: Colors.amber,
                                                size: 32.0,
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                achievement.name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 14.0),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                achievement.description,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 12.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 12.0),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.black,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                ),
                                                onPressed: (){},
                                                child: const Text('Achievement Earned'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                        );
                      },
                    ),
                    const SizedBox(height: 16.0,),
                    Consumer<AchievementProvider>(
                      builder: (ctx, achievementProvider, _) {
                        final achievements = achievementProvider.achievements;
                        return ExpansionTile(
                          leading: const Icon(Icons.star_border, color: Colors.grey),
                          title: const Text(
                            'Pending Achievements',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: achievements.length,
                              itemBuilder: (ctx, index) {
                                final achievement = achievements[index];
                                return Card(
                                  elevation: 4.0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.emoji_events,
                                          color: Colors.amber,
                                          size: 32.0,
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          achievement.name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 14.0),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          achievement.description,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12.0),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12.0),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            foregroundColor: Colors.black,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onPressed: null,
                                          child: const Text('Pending Achievement'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class MyBadgesContent extends StatelessWidget {
  const MyBadgesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        Provider.of<UserBadgeProvider>(context, listen: false).fetchBadges(),
        Provider.of<BadgeProvider>(context, listen: false).fetchBadges(),
      ]),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Consumer<UserBadgeProvider>(
                      builder: (ctx, userBadgeProvider, _) {
                        final earnedBadges = userBadgeProvider.userBadges;
                        return ExpansionTile(
                          leading: const Icon(Icons.card_giftcard, color: Colors.blue),
                          title: const Text(
                            'Earned Badges',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          initiallyExpanded: true,
                          children: earnedBadges.isEmpty
                              ? [
                                  const Center(child: Text('No badges earned yet.'))
                                ]
                              : [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 5,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    itemCount: earnedBadges.length,
                                    itemBuilder: (ctx, index) {
                                      final badge = earnedBadges[index];
                                      return Card(
                                        elevation: 4.0,
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 40.0,
                                                backgroundImage: badge.icon.isNotEmpty
                                                    ? NetworkImage(badge.icon)
                                                    : const AssetImage('assets/placeholder.png')
                                                        as ImageProvider,
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                badge.name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 14.0),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                badge.description,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 12.0),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                               const SizedBox(height: 12.0),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.black,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(8.0),
                                                  ),
                                                ),
                                                onPressed: (){},
                                                child: const Text('Badge Earned'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                        );
                      },
                    ),
                    Consumer<BadgeProvider>(
                      builder: (ctx, badgeProvider, _) {
                        final badges = badgeProvider.badges;
                        return ExpansionTile(
                          leading: const Icon(Icons.card_giftcard_outlined, color: Colors.grey),
                          title: const Text(
                            'Pending Badges',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: badges.length,
                              itemBuilder: (ctx, index) {
                                final badge = badges[index];
                                return Card(
                                  elevation: 4.0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 40.0,
                                          backgroundImage: badge.icon.isNotEmpty
                                              ? NetworkImage(badge.icon)
                                              : const AssetImage('assets/placeholder.png')
                                                  as ImageProvider,
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          badge.name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold, fontSize: 14.0),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          badge.description,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 12.0),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12.0),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            foregroundColor: Colors.black,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          onPressed: null,
                                          child: const Text('Pending Badge'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class ReviewItem {
  final String reviewerName;
  final String reviewerEmail;
  final String reviewerAvatar;
  final String reviewText;

  ReviewItem({
    required this.reviewerName,
    required this.reviewerEmail,
    required this.reviewerAvatar,
    required this.reviewText,
  });
}
