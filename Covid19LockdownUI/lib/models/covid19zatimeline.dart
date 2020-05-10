class ProvincialCumulativeTimeline {
  String date;
  int yYYYMMDD;
  int eC;
  int fS;
  int gP;
  int kZN;
  int lP;
  int mP;
  int nC;
  int nW;
  int wC;
  int uNKNOWN;
  int total;
  String source;

  ProvincialCumulativeTimeline(
      {this.date,
      this.yYYYMMDD,
      this.eC,
      this.fS,
      this.gP,
      this.kZN,
      this.lP,
      this.mP,
      this.nC,
      this.nW,
      this.wC,
      this.uNKNOWN,
      this.total,
      this.source});

  ProvincialCumulativeTimeline.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    yYYYMMDD = json['YYYYMMDD'];
    eC = json['EC'];
    fS = json['FS'];
    gP = json['GP'];
    kZN = json['KZN'];
    lP = json['LP'];
    mP = json['MP'];
    nC = json['NC'];
    nW = json['NW'];
    wC = json['WC'];
    uNKNOWN = json['UNKNOWN'];
    total = json['total'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['YYYYMMDD'] = this.yYYYMMDD;
    data['EC'] = this.eC;
    data['FS'] = this.fS;
    data['GP'] = this.gP;
    data['KZN'] = this.kZN;
    data['LP'] = this.lP;
    data['MP'] = this.mP;
    data['NC'] = this.nC;
    data['NW'] = this.nW;
    data['WC'] = this.wC;
    data['UNKNOWN'] = this.uNKNOWN;
    data['total'] = this.total;
    data['source'] = this.source;
    return data;
  }

  int getProvinceConfirmedCases(String provinceName) {
    switch (provinceName) {
      case 'WESTERN CAPE':
        {
          return wC;
        }
        break;
      case 'NORTHERN CAPE':
        {
          return nC;
        }
        break;
      case 'GAUTENG':
        {
          return gP;
        }
        break;
      case 'KWAZULU-NATAL':
        {
          return kZN;
        }
        break;
      case 'MPUMALANGA':
        {
          return mP;
        }
        break;
      case 'FREE STATE':
        {
          return fS;
        }
        break;
      case 'LIMPOPO':
        {
          return lP;
        }
        break;
      case 'EASTERN CAPE':
        {
          return eC;
        }
        break;
      case 'NORTH WEST':
        {
          return nW;
        }
        break;
      default:
        {
          return -1;
        }
    }
  }
}

class Covid19ZATimeline {
  String date;
  int yyyymmdd;
  int cumulativeTests;
  int recovered;
  String hospitalisation;
  int criticalIcu;
  int ventilation;
  int deaths;
  String contactsIdentified;
  String contactsTraced;
  String scannedTravellers;
  String passengersElevatedTemperature;
  String covidSuspectedCriteria;
  String source;

  Covid19ZATimeline(
      {this.date,
      this.yyyymmdd,
      this.cumulativeTests,
      this.recovered,
      this.hospitalisation,
      this.criticalIcu,
      this.ventilation,
      this.deaths,
      this.contactsIdentified,
      this.contactsTraced,
      this.scannedTravellers,
      this.passengersElevatedTemperature,
      this.covidSuspectedCriteria,
      this.source});

  Covid19ZATimeline.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    yyyymmdd = json['yyyymmdd'];
    cumulativeTests = json['cumulative_tests'];
    recovered = json['recovered'];
    hospitalisation = json['hospitalisation'];
    criticalIcu = json['critical_icu'];
    ventilation = json['ventilation'];
    deaths = json['deaths'];
    contactsIdentified = json['contacts_identified'];
    contactsTraced = json['contacts_traced'];
    scannedTravellers = json['scanned_travellers'];
    passengersElevatedTemperature = json['passengers_elevated_temperature'];
    covidSuspectedCriteria = json['covid_suspected_criteria'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['yyyymmdd'] = this.yyyymmdd;
    data['cumulative_tests'] = this.cumulativeTests;
    data['recovered'] = this.recovered;
    data['hospitalisation'] = this.hospitalisation;
    data['critical_icu'] = this.criticalIcu;
    data['ventilation'] = this.ventilation;
    data['deaths'] = this.deaths;
    data['contacts_identified'] = this.contactsIdentified;
    data['contacts_traced'] = this.contactsTraced;
    data['scanned_travellers'] = this.scannedTravellers;
    data['passengers_elevated_temperature'] =
        this.passengersElevatedTemperature;
    data['covid_suspected_criteria'] = this.covidSuspectedCriteria;
    data['source'] = this.source;
    return data;
  }
}
