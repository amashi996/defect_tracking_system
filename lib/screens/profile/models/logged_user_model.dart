class Profile {
  String? userId;
  String? name; 
  String? company;
  String? website;
  String? location;
  String? status;
  List<String>? skills;
  String? bio;
  String? githubUsername;
  List<Experience>? experience;
  List<Education>? education;
  Social? social;
  DateTime? date;

  Profile({
    this.userId,
    this.name,
    this.company,
    this.website,
    this.location,
    this.status,
    this.skills,
    this.bio,
    this.githubUsername,
    this.experience,
    this.education,
    this.social,
    this.date,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userId: json['user']?['_id'],
      name: json['user']?['name'],
      company: json['company'],
      website: json['website'],
      location: json['location'],
      status: json['status'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      bio: json['bio'],
      githubUsername: json['githubusername'],
      experience: json['experience'] != null ? List<Experience>.from(json['experience'].map((x) => Experience.fromJson(x))) : null,
      education: json['education'] != null ? List<Education>.from(json['education'].map((x) => Education.fromJson(x))) : null,
      social: json['social'] != null ? Social.fromJson(json['social']) : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }
}

class Experience {
  String? title;
  String? company;
  String? location;
  DateTime? from;
  DateTime? to;
  bool? current;
  String? description;

  Experience({
    this.title,
    this.company,
    this.location,
    this.from,
    this.to,
    this.current,
    this.description,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      title: json['title'],
      company: json['company'],
      location: json['location'],
      from: DateTime.parse(json['from']),
      to: json['to'] != null ? DateTime.parse(json['to']) : null,
      current: json['current'],
      description: json['description'],
    );
  }
}

class Education {
  String? school;
  String? degree;
  String? fieldOfStudy;
  DateTime? from;
  DateTime? to;
  bool? current;
  String? description;

  Education({
    this.school,
    this.degree,
    this.fieldOfStudy,
    this.from,
    this.to,
    this.current,
    this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      school: json['school'],
      degree: json['degree'],
      fieldOfStudy: json['fieldofstudy'],
      from: DateTime.parse(json['from']),
      to: json['to'] != null ? DateTime.parse(json['to']) : null,
      current: json['current'],
      description: json['description'],
    );
  }
}

class Social {
  String? youtube;
  String? twitter;
  String? linkedin;

  Social({
    this.youtube,
    this.twitter,
    this.linkedin,
  });

  factory Social.fromJson(Map<String, dynamic> json) {
    return Social(
      youtube: json['youtube'],
      twitter: json['twitter'],
      linkedin: json['linkedin'],
    );
  }
}
