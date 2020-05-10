class SubPlace {
  List<SubPlaceLookup> subPlaceLookup;

  SubPlace({this.subPlaceLookup});

  SubPlace.fromJson(Map<String, dynamic> json) {
    if (json['SubPlaceLookup'] != null) {
      subPlaceLookup = new List<SubPlaceLookup>();
      json['SubPlaceLookup'].forEach((v) {
        subPlaceLookup.add(new SubPlaceLookup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.subPlaceLookup != null) {
      data['SubPlaceLookup'] =
          this.subPlaceLookup.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubPlaceLookup {
  int suburbCode;
  String suburbName;
  int municipalityCode;
  String municipalityName;
  int districtCode;
  String districtName;
  int provinceCode;
  String provinceName;
  int level;

  SubPlaceLookup(
      {this.suburbCode,
      this.suburbName,
      this.municipalityCode,
      this.municipalityName,
      this.districtCode,
      this.districtName,
      this.provinceCode,
      this.provinceName,
      this.level});

  SubPlaceLookup.fromJson(Map<String, dynamic> json) {
    suburbCode = json['SuburbCode'];
    suburbName = json['SuburbName'];
    municipalityCode = json['MunicipalityCode'];
    municipalityName = json['MunicipalityName'];
    districtCode = json['DistrictCode'];
    districtName = json['DistrictName'];
    provinceCode = json['ProvinceCode'];
    provinceName = json['ProvinceName'];
    level = json['Level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SuburbCode'] = this.suburbCode;
    data['SuburbName'] = this.suburbName;
    data['MunicipalityCode'] = this.municipalityCode;
    data['MunicipalityName'] = this.municipalityName;
    data['DistrictCode'] = this.districtCode;
    data['DistrictName'] = this.districtName;
    data['ProvinceCode'] = this.provinceCode;
    data['ProvinceName'] = this.provinceName;
    data['Level'] = this.level;
    return data;
  }

  bool compareSuburbCode(SubPlaceLookup other) {
    int nameComp = this.suburbCode.compareTo(other.suburbCode);
    if (nameComp == 0) {
      return false;
    }
    return true;
  }
}
