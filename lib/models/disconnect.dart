class Disconnect {
  double startTime;
  double duration;

  Disconnect(this.startTime, this.duration);

  Map toJson() {
    Map map = new Map();
    map["startTime"] = this.startTime;
    map["duration"] = this.duration;
    return map;
  }
}