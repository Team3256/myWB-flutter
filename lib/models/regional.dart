class Regional {
  String key;
  String name;
  String shortName;

  Regional(this.key, this.name, this.shortName);

  toString() {
    return ("$key - $name ($shortName)");
  }
}