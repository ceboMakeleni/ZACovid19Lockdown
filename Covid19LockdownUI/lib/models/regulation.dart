import 'package:flutter/material.dart';

class RegulationLookup {
  List<Regulation> regulation;

  RegulationLookup({this.regulation});

  RegulationLookup.fromJson(Map<String, dynamic> json) {
    if (json['Regulation'] != null) {
      regulation = new List<Regulation>();
      json['Regulation'].forEach((v) {
        regulation.add(new Regulation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.regulation != null) {
      data['Regulation'] = this.regulation.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Regulation {
  int id;
  String restrictionName;
  String restrictionIcon;

  Regulation({this.id, this.restrictionName, this.restrictionIcon});

  Regulation.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    restrictionName = json['RestrictionName'];
    restrictionIcon = json['RestrictionIcon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['RestrictionName'] = this.restrictionName;
    data['RestrictionIcon'] = this.restrictionIcon;
    return data;
  }

  IconData getRestrictionIcon() {
    switch (this.restrictionIcon) {
      case 'Agriculture':
        {
          return Icons.terrain;
        }
        break;

      case 'Electricity':
        {
          return Icons.offline_bolt;
        }
        break;
      case 'Manufacturing':
        {
          return Icons.memory;
        }
        break;
      case 'Construction':
        {
          return Icons.build;
        }
        break;

      case 'Wholesale':
        {
          return Icons.store_mall_directory;
        }
        break;
      case 'Information':
        {
          return Icons.dvr;
        }
        break;
      case 'Media':
        {
          return Icons.videocam;
        }
        break;

      case 'Financial':
        {
          return Icons.monetization_on;
        }
        break;
      case 'Accommodation':
        {
          return Icons.hotel;
        }
        break;
      case 'Transport':
        {
          return Icons.directions_bus;
        }
        break;
      case 'Mining':
        {
          return Icons.landscape;
        }
        break;
      case 'Repair':
        {
          return Icons.healing;
        }
        break;
      case 'Supply':
        {
          return Icons.settings_input_component;
        }
        break;
      case 'Domestic':
        {
          return Icons.home;
        }
        break;
      case 'Public':
        {
          return Icons.public;
        }
        break;
      case 'Health':
        {
          return Icons.local_hospital;
        }
        break;
      case 'Education':
        {
          return Icons.library_books;
        }
        break;
      case 'Education':
        {
          return Icons.library_books;
        }
        break;
      case 'Movement':
        {
          return Icons.directions_walk;
        }
        break;
      default:
        {
          return Icons.do_not_disturb;
        }
    }
  }
}
