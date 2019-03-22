class AutoLine {
  int habLevel;
  double time;
  bool crossed;

  AutoLine(this.habLevel, this.time, this.crossed);

  Map toJson() {
    Map map = new Map();
    map["habLevel"] = this.habLevel;
    map["time"] = this.time;
    map["crossed"] = this.crossed;
    return map;
  }
}