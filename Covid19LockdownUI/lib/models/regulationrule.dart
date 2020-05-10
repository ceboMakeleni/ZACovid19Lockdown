class RegulationRulesLookup {
  List<RegulationRule> regulationRule;

  RegulationRulesLookup({this.regulationRule});

  RegulationRulesLookup.fromJson(Map<String, dynamic> json) {
    if (json['RegulationRule'] != null) {
      regulationRule = new List<RegulationRule>();
      json['RegulationRule'].forEach((v) {
        regulationRule.add(new RegulationRule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.regulationRule != null) {
      data['RegulationRule'] =
          this.regulationRule.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegulationRule {
  int id;
  int regulationId;
  int regulationRuleLevel;
  List<String> regulationRules;

  RegulationRule(
      {this.id,
      this.regulationId,
      this.regulationRuleLevel,
      this.regulationRules});

  RegulationRule.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    regulationId = json['RegulationId'];
    regulationRuleLevel = json['RegulationRuleLevel'];
    regulationRules = json['RegulationRules'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['RegulationId'] = this.regulationId;
    data['RegulationRuleLevel'] = this.regulationRuleLevel;
    data['RegulationRules'] = this.regulationRules;
    return data;
  }
}
