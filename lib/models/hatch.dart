class Hatch {
  String pickup;
  String dropOff;
  double pickupTime;
  double cycleTime;
  String gamePart;

  Hatch(this.pickup, this.dropOff, this.pickupTime, this.cycleTime, this.gamePart);

  Map toJson() {
    Map map = new Map();
    map["pickup"] = this.pickup;
    map["dropOff"] = this.dropOff;
    map["pickupTime"] = this.pickupTime;
    map["cycleTime"] = this.cycleTime;
    return map;
  }
}