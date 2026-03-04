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
}
