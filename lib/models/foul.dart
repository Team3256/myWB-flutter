class Foul {
  String reason;
  double time;

  Foul(this.time, this.reason);

  Map toJson() {
    Map map = new Map();
    map["time"] = this.time;
    map["reason"] = this.reason;
    return map;
  }
}