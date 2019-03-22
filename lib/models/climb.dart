class Climb {
  double time;
  double cycleTime;
  int habLevel;
  bool canSupport;
  bool dropped;

  Climb(this.time, this.cycleTime, this.habLevel, this.canSupport, this.dropped);

  Map toJson() {
    Map map = new Map();
    map["time"] = this.time;
    map["cycleTime"] = this.cycleTime;
    map["habLevel"] = this.habLevel;
    map["canSupport"] = this.canSupport;
    map["dropped"] = this.dropped;
    return map;
  }
}