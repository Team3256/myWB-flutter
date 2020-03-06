class Team {
  String id;
  String name;
  String nickname;

  Team(Map<String, dynamic> json) {
    this.id = json["id"];
    this.name = json["name"];
    this.nickname = json["nickname"];
  }
}