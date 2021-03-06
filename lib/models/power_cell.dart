class PowerCell {
  String matchID = "";
  String teamID = "";
  String dropLocation = "";
  double pickupTime = 0.0;
  double cycleTime = 0.0;

  @override
  String toString() {
    return "$teamID SHOT POWER CELL INTO $dropLocation @ $pickupTime IN $cycleTime";
  }

  Map<String, dynamic> toJson() =>
      {
        'matchID': matchID,
        'teamID': teamID,
        'dropLocation': dropLocation,
        'pickupTime': pickupTime,
        'cycleTime': cycleTime,
      };
}