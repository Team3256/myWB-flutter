class Version {
  int major;
  int minor;
  int patch;
  int build;

  Version(String version) {
    this.major = int.parse(version.split('.')[0]);
    this.minor = int.parse(version.split('.')[1]);
    this.patch = int.parse((version.split('.')[2]).split('+')[0]);
    this.build = int.parse((version.split('.')[2]).split('+')[1]);
  }

  @override
  String toString() {
    return "$major.$minor.$patch";
  }

  int getVersionCode() {
    return major*1000000 + minor*1000 + patch;
  }

  int getBuild() {
    return build;
  }

}