class Member {
  Member({
    required this.uid,
    required this.lvl,
    required this.coins,
    this.firstName,
    this.secondName,
    this.email,
    this.birthday,
    required this.name,
  });
  String uid;
  int lvl;
  int coins;
  String? firstName;
  String? secondName;
  String? email;
  String? birthday;
  String name;

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
      lvl: lvl ?? this.lvl,
      coins: coins ?? this.coins,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      email: email ?? this.email,
    );
  }
}
