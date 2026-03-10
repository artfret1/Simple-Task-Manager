class Member {
  Member({
    required this.uid,
    this.firstName,
    this.secondName,
    this.email,
    this.birthday,
    required this.name,
    this.groups,
  });
  String uid;
  String? firstName;
  String? secondName;
  String? email;
  String? birthday;
  String name;
  Map<String, dynamic>? groups;

  String? get getName => firstName != null ? "$firstName $secondName" : null;

  Member copyWith({
    String? uid,
    String? name,
    int? lvl,
    int? coins,
    String? firstName,
    String? secondName,
    String? email,
  }) {
    return Member(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      email: email ?? this.email,
    );
  }
}
