import "dart:math";
import "dart:math" as Math;

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "SharedPref.dart";
import "../Utils/LoadMarketData.dart";
import '../Utils/Convert.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

////constantes fournies par hutchinson pour les calcules
const G = 9.81;
const CONST = 2000.0;
const BELT_CONST = 0.0130741;
const BELT_WIDTH_CONST = 2.34;
const PI_DEG = 180;

enum Algo { line, curve }

class DataManager extends ChangeNotifier {
  static List fieldLong = ["mm", "inch"];
  static List fieldWeight = ["kg", "lbs"];
  static List fieldLSpeed = ["m/s", "ft/s"];
  static List fieldTorque = ["N.m", "N.ft"];

  late String _unit;
  late int _unitIndex;
  late List<double> _RollerDiametre;
  late double _rollerValue;
  late int _rollerIndex;
  late List<double> _pullyDiametre; //1.69;
  late double _pullyValue;
  late List<double> _centerDistance;
  late double _centerValue;
  late int _centerIndex;
  late int _curveAngle;
  late double _rollerAngle;
  late int _numberRollerG;
  late int _numberRollerD;
  late int _numberRoller;
  late double _weight;
  late List<String> _loadType;
  late String _typeValue;
  late int _incline;
  late double _angle;
  late double _speed;
  late String _langueValue;
  late double _teeth;
  late String _rollerMesssage;
  late bool _pianoCook;
  late bool _signalPush;
  late bool _acceptTerms;
  late bool _agreeToContacte;

  late String _company;
  late String _lastName;
  late String _firstName;
  late String _email;
  late String _number;
  late bool _validEmail;

  late String _mailLabel;

  late String
  _referenceCour; //************************************************************** */
  late double _BeltTension;
  late double _Betlwidth;

  late String _title;

  late double _rollerCopy;
  late double _pullyCopy;
  late double _centerDisCopy;

  late Future<Map<String, dynamic>> _marketData;
  late var data;

  late bool _settingPopPupSeen;

  bool _teethMessage =
      false; //**************************************************************** */

  late Algo _algo;

  late int _some;

  late String _marketValue;
  List<String> _unitList = [];

  final Map<String, List<String>> _marketToUnits = {
    'Worldwide': ['Metric', 'Imperial'],
    'American': ['Imperial'],
  };

  final Map<String, double> coef = {"Plastic": 0.04, "Carton": 0.1};

  void updateMarket(String selectedValue) {
    _marketValue = selectedValue;
    notifyListeners();
    SharedPreferenceHelper().savedMarket(selectedValue);
  }

  void updateUnitList(String value) {
    _unitList = marketToUnits[value] ?? [];
    notifyListeners();
    SharedPreferenceHelper().savedListUnit(_unitList);
  }

  /*
  getthesharedpref() async {
    await SharedPreferenceHelper().loadPianoCook();
    await SharedPreferenceHelper().loadSignalPush();
  }*/

  DataManager() {
    _unit = "Metric";
    _unitIndex = 0;
    _RollerDiametre = [48.3, 48.6, 50.0];
    _rollerValue = _RollerDiametre[2];
    _pullyDiametre = [43, 1.69];
    _pullyValue = _pullyDiametre[0];
    _rollerIndex = 2;
    InitCenterDist();
    _centerValue = _centerDistance[83];
    _centerIndex = 83;
    _numberRollerG = _numberRollerD = 15;
    _some = 0;
    _weight = 150;
    _typeValue = "Plastic";
    _incline = 0;
    _angle = Calcule_Angle(_incline);
    _speed = 1;
    _marketValue = "Worldwide";
    _langueValue = "English";
    _unitList = _marketToUnits[_marketValue] ?? [];
    _rollerAngle = 3;
    _curveAngle = 90;
    _rollerMesssage = "LOAD TO CARRY";
    _pianoCook = true;
    _signalPush = true;
    _acceptTerms = true;
    _agreeToContacte = false;
    _company = "";
    _lastName = "";
    _firstName = "";
    _email = "";
    _number = "";
    _validEmail = false;
    _mailLabel = "";

    _teeth = 1;
    _BeltTension = 0;
    _Betlwidth = 0;
    _rollerCopy = _rollerValue;
    _pullyCopy = _pullyValue;
    _centerDisCopy = _centerValue;

    _settingPopPupSeen = false;
    _title = "CONVEYDYN® WIZARD";

    updateNumberRoller();

    _algo = Algo.line;
  }

  
  Future<void> init() async {
    _marketValue = await SharedPreferenceHelper().loadMarket() ?? "Worldwide";
    print("Market value: $_marketValue");
    _langueValue = await SharedPreferenceHelper().loadLanguage() ?? "English";
    _unit = await SharedPreferenceHelper().loadUnit() ?? "Metric";
    _unitList =
        await SharedPreferenceHelper().LoadUnitList() ??
        _marketToUnits[_marketValue] ??
        [];
    _unitIndex = await SharedPreferenceHelper().LoadUnitIndex() ?? 0;
    _pianoCook = await SharedPreferenceHelper().loadPianoCook() ?? true;
    _signalPush = await SharedPreferenceHelper().loadSignalPush() ?? true;
    print("Signal push DataManager: $_signalPush");
    _acceptTerms = await SharedPreferenceHelper().loadAcceptTerms() ?? false;
    print("accept terms DataManager newwwwwww: $_acceptTerms");
    _settingPopPupSeen = await SharedPreferenceHelper().loadSettingPopupSeen() ?? false;
    print("Setting popup seen DataManager: $_settingPopPupSeen");
    _agreeToContacte =
        await SharedPreferenceHelper().loadAgreeToContact() ?? false;

    _marketData = LoadData().loadMarketData();
    
    
    List<dynamic> userData = await SharedPreferenceHelper().loadAccount();
      _company = userData[0];
      _firstName = userData[1];
      _lastName = userData[2]; 
      _email = userData[3];
    try{
      _number = userData[4]?.toString() ?? "";
    }catch(e, st){
      print("❌ Erreur dans DataManager.init: $e");
      print("📌 Stack: $st");
    }

    updateValues();
    notifyListeners();
  }

  String get unit => _unit;
  int get unitIndex => _unitIndex;
  List<double> get RollerDiametre => _RollerDiametre;
  double get rollerValue => _rollerValue;
  int get rollerIndex => _rollerIndex;
  List<double> get pullyDiametre => _pullyDiametre;
  //double get pullyValue => _pullyValue;
  double get pullyValue => _pullyDiametre[unitIndex];
  List<double> get centerDistance => _centerDistance;
  double get centerValue => _centerValue;
  int get centerIndex => _centerIndex;
  int get numberRollerG => _numberRollerG;
  int get numberRollerD => _numberRollerD;
  double get weight => _weight;
  String get typeValue => _typeValue;
  int get incline => _incline;
  double get angle => _angle;
  double get speed => _speed;
  double get rollerAngle => _rollerAngle;
  int get curveAngle => _curveAngle;
  Algo get getAlgo => _algo;

  int get numberRoller => _numberRoller;
  String get rollerMesssage => _rollerMesssage;
  String get marketValue => _marketValue;
  List<String> get unitList => _unitList;
  Map<String, List<String>> get marketToUnits => _marketToUnits;

  bool get pianoCook => _pianoCook;
  bool get signalPush => _signalPush;
  bool get acceptTerms => _acceptTerms;
  bool get agreeToContacte => _agreeToContacte;

  String get company => _company;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  String get number => _number;
  bool get validEmail => _validEmail;
  String get mailLabel => _mailLabel;

  double get BeltTension => _BeltTension;
  double get Betlwidth => _Betlwidth;
  
  double get teeth => _teeth;
  String get referenceCour => _referenceCour;

  bool get settingPopPupSeen => _settingPopPupSeen;
  String get title => _title;

  void InitCenterDist() {
    _centerDistance = List.generate(256, (i) => 50.0 + i);
    notifyListeners();
  }

  void InitRollerDM() {
    _RollerDiametre = [48.3, 48.6, 50.0];
    notifyListeners();
  }

  void updateRollerValue(double value) {
    _rollerValue = value;
    _rollerIndex = RollerDiametre.indexOf(value);
    notifyListeners();
  }

  void updateCenterValue(double value) {
    _centerValue = value;
    _centerIndex = centerDistance.indexOf(value);
    notifyListeners();
  }

  void updateNumberRollerG(int value) {
    _numberRollerG = value;
  }

  void updateNumberRollerD(int value) {
    _numberRollerD = value;
  }

  void updateTypeValue(String type) {
    _typeValue = type;
  }

  void updateMailLabel(String value) {
    _mailLabel = value;
    notifyListeners();
  }

  double Calcule_Angle(int pourcentage) {
    // Convertir le pourcentage en degrees
    double fraction = pourcentage / 100;
    double radians = asin(fraction);
    return radians;
  }

  void increaseIncline() {
    if (_incline >= 0 && _incline < 10) {
      _incline += 1;
      _angle = Calcule_Angle(_incline);
    } else
      null;
  }

  void decreaseIncline() {
    if (_incline > 0 && _incline <= 10) {
      _incline -= 1;
      _angle = Calcule_Angle(_incline);
    } else
      null;
  }

  void decreaseSpeed() {
    if (_speed > 0.1 + 1e-10 && _speed <= 3.0 + 1e-10)
      _speed -= 0.1;
    else
      null;
  }

  void increaseSpeed() {
    if (_speed >= 0.1 && _speed < 3.0)
      _speed += 0.1;
    else
      null;
  }

  void increaseCurveAngl() {
    if (_curveAngle < 180)
      _curveAngle += 1;
    else
      null;
  }

  void decreaseCurveAngl() {
    if (_curveAngle > 1)
      _curveAngle -= 1;
    else
      null;
  }

  void increaseRollerAngl() {
    if (_rollerAngle < 5 - 1e-10) {
      _rollerAngle += 0.1;
      print(_rollerAngle);
    } else
      null;
  }

  void decreaseRollerAngl() {
    if (_rollerAngle > 0.1)
      _rollerAngle -= 0.1;
    else
      null;
  }

  void updateUnit(String unit) {
    if (_unit != unit) _unit = unit;
    SharedPreferenceHelper().savedUnit(unit);
    notifyListeners();
  }

  void updateUnitIndex() {
    if (_unit == "Metric") {
      _unitIndex = 0;
    } else {
      _unitIndex = 1;
    }
    SharedPreferenceHelper().savedUnitIndex(_unitIndex);
    notifyListeners();
  }

  void updateValues() {
    if (_unit == "Imperial") {
      for (int i = 0; i < _RollerDiametre.length; i++) {
        _RollerDiametre[i] = ConvertUnit(_unit, "mm", _RollerDiametre[i]);
      }
      for (int i = 0; i < _centerDistance.length; i++) {
        _centerDistance[i] = ConvertUnit(_unit, "mm", _centerDistance[i]);
      }
    } else {
      InitRollerDM();
      InitCenterDist();
    }
    _pullyValue = _pullyDiametre[_unitIndex];
    //print("in update pullyvalue = $_pullyValue");
    _rollerValue = _RollerDiametre[_rollerIndex];
    _centerValue = _centerDistance[_centerIndex];
    notifyListeners();
  }

  void updateUnitSystem(String Unit) {
    if (Unit != _unit) {
      updateUnit(Unit);
      updateUnitIndex();
      updateValues();
    }
  }

  void updateWeightSpeed() {
    _weight = ConvertUnit(_unit, "kg", _weight);
    _speed = ConvertUnit(_unit, "m/s", _speed);
  }

  void updatePianoCook(bool value) {
    _pianoCook = value;
    SharedPreferenceHelper().savedPianoCook(value);
    notifyListeners();
  }

  void updateSignalPush(bool value) {
    _signalPush = value;
    SharedPreferenceHelper().savedSignalPush(value);
    notifyListeners();
  }

  void updateAcceptTerms(bool value) {
    _acceptTerms = value;
    SharedPreferenceHelper().savedAcceptTerms(value);
    notifyListeners();
  }

  void updateAgreeToContact(bool value) {
    _agreeToContacte = value;
    SharedPreferenceHelper().savedAgreeToContact(value);
    notifyListeners();
  }

  void increaseWeight() {
    ///double converted = ConvertUnit(_unit, "kg", _weight);
    if (_weight >= 100)
      _weight -= 50;
    else if (_weight > 10 && _weight < 100)
      _weight -= 10;
  }

  void decreaseWeight() {
    if (_weight >= 100 && _weight < 300)
      _weight += 50;
    else if (_weight >= 10 && _weight < 100)
      _weight += 10;
  }

  void updateTitle(String newtitle) {
    _title = newtitle;
    notifyListeners();
  }

  void updateFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void updateLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void updateCompany(String value) {
    _company = value;
    notifyListeners();
  }

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void updateNumber(String value) {
    _number = value;
    notifyListeners();
  }

  void updateValidEmail(bool value) {
    _validEmail = value;
    notifyListeners();
  }

  void updateTeeth(double value){
    _teeth = value;
    notifyListeners();
  }

  void updatePopupSettings(bool value){
    _settingPopPupSeen = value;
    SharedPreferenceHelper().saveSettingPopupSeen(value);
    notifyListeners();
  }

  /*
  void updateRefCourroie(double value){
    _teeth = value;
    notifyListeners();
  }*/

  //fonctions de calcules ********************************************

  double ConvertUnit(String Unit, String field, double value) {
    double converted;

    switch (Unit) {
      case "Imperial":
        {
          switch (field) {
            case "mm":
              converted = (value / 25.4 * 100).round() / 100;
              break;
            case "kg":
              converted = value * 2.20462;
            case "m/s":
              converted = value * 3.28084;
            case "N.ft":
              converted = (value * 3.28084); //nrmlm round
            default:
              converted = value;
          }
        }
      default:
        converted = value;
    }
    return converted;
  }

  /**
     * Algo calcul les sorties en fonction des entrées fournies. (voir types Inputs et Outputs)
     * Il est appelé après l'initialisation de l'application, a l'initialisation de chaque écran et après chaquie modification d'input.
     * C'est l'implémentation de l'algoritme fourni par hutchinson.
     */

  Future<void> algo() async {
    ConverttoCalcul();
    //var
    //iCopy = prepareInputs(i),
    //oCopy = validateInputs(iCopy),
    List<dynamic> geom = await getGeom();
    List<dynamic> tcs = geom.sublist(3, _algo == "curve" ? 5 : geom.length);
    var lf = loadForce(typeValue);
    print("lf $lf");
    //labelsF = labels(iCopy),
    print("tcs $tcs");

    //var bf = beltForce();
    int tmpT = 0;
    //a valeurs <=> du nombre de dents
    //_teeth = 1;
    _referenceCour = geom[2] as String;
    print("reference courroie : $_referenceCour");
    //trace(geom);
    //trace("-----------------");
    _teeth = 1;
    _teethMessage = tcs.any((t) {
      tmpT = t;
      print("t : $t");
      final r = beltForce(t) >= lf;
      print("belt force ${beltForce(t)}");
      _teeth++;
      // print("f transcouroie : ${bf(t)}, f trans charge : $lf, nombre de dents : ${oCopy.teeth}, resultat ? $r");
      return r;
    });
    print("teeth : $_teeth");
    print("tmpT rtttttttttttttttttttt: $tmpT");
    //?refLabel(iCopy, oCopy)
    //:errorLabel(labelsF("loadToHigh"));
    _BeltTension = tmpT / 2; //2*tmpT;
    _Betlwidth = ConvertUnit(
      _unit,
      "mm",
      roundToStep(_teeth * BELT_WIDTH_CONST, .1),
    ); //2*tmpT;
  }

  //extraction données géométriques d'une courroie pour un marché + un diamètre poulie + une entraxe
  Future<List<dynamic>> getGeom() async {
    final data = await _marketData;
    if (data == null || data['market'] == null) {
      throw Exception('Les données du marché ne sont pas chargées.');
    }
    final marketList = data['market'][_marketValue];
    if (marketList == null) {
      throw Exception('Aucune donnée pour la valeur de marché $_marketValue.');
    }

    final a =
        marketList.map<List<dynamic>>((e) => List<dynamic>.from(e)).toList();

    int indx = -1;

    a.any((e) {
      indx++;
      return e[0].toDouble() == _pullyCopy && e[1].toDouble() == _centerDisCopy;
    });

    return a[indx];
  }

  //on utilise dans les calcules les valeurs en Metric donc on dois les convertir avant les utilises.
  void ConverttoCalcul() {
    if (_unit == "Imperial") {
      _rollerCopy = Tools().inchToMilimeter(_rollerValue);
      _pullyCopy = Tools().inchToMilimeter(_pullyValue).roundToDouble();
      _centerDisCopy = Tools().inchToMilimeter(_centerValue).roundToDouble();
    } else {
      _rollerCopy = _rollerValue;
      _pullyCopy = _pullyValue;
      _centerDisCopy = _centerValue;
    }
  }

  /**
     * Retourne une fonction permettant de calculer la Force transmissible par une courroie en fonction du couple fourni
     * à partir des inputs déjà renseignées
     * cf Compute.algo
    */
  double beltForce(int beltTorque) {
    var exp = Math.exp(0.512 * Math.pi);
    //var dConst  = 2 *((i.d + 2.2) / CONST) * ((exp + 1) / (exp - 1)) / i.d * CONST;
    print("pulleyvalue $pullyValue");
    var r =
        (beltTorque *
            ((_pullyCopy /* + 2.2*/ ) / CONST) *
            ((exp - 1) / (exp + 1))) /
        _pullyCopy *
        CONST;
    return r;
  }

  //Force tangentielle nécessaire pour déplacer la charge
  double loadForce(String LoadType) {
    return coef[LoadType]! * _weight * G;
  }

  double getBeltTorque() {
    return (_numberRollerG + _numberRollerD) * (_teeth) * BELT_CONST;
  }

  double getLoadTorque(String LoadType) {
    var aRad = Math.atan(_incline / 100);
    return _weight *
        G *
        (_rollerCopy / CONST) *
        (Math.sin(aRad) + coef[LoadType]!);
  }

  //Le calcul du paramètre p tel que fourni par hutchinson
  int p(String LoadType) {
    var beltTorque = getBeltTorque(), loadTorque = getLoadTorque(LoadType);
    var p =
        (_speed * CONST * (beltTorque + loadTorque)) /
        (_rollerCopy); //diametre roller;
    return p.round();
  }

  double ReqTorque() {
    var res =
        ((getBeltTorque() + getLoadTorque(typeValue)) * 10).roundToDouble() /
        10;

    if (_unit == "Metric") {
      return res;
    } else {
      // Sinon, on convertit en pieds
      return ((Tools().meterToFeet(res) * 10).roundToDouble() / 10);
    }
  }

  double roundToStep(double value, double step) {
    return (value / step).round() * step;
  }

  void updateAlgo(String algo) {
    algo == "line" ? _algo = Algo.line : _algo = Algo.curve;
  }

  void updateNumberRoller() {
    _numberRoller = (_curveAngle / _rollerAngle + 1).round();
    notifyListeners();
  }

  bool validateNumR() {
    bool valide = true;
    switch (_algo) {
      case Algo.line:
        _some = _numberRollerD + _numberRollerG;
      case Algo.curve:
        _some = _numberRoller;
    }

    if (_some <= 1 || _some >= 50) {
      valide = false;
    }
    return valide;
  }

  void updateMessageRoller() {
    if (_some <= 1 || _some >= 50) {
      _some >= 50 ? _rollerMesssage = "Excessive number of rolls" : null;
      _some <= 1 ? _rollerMesssage = "Insufficient number of rolls" : null;
    } else {
      _rollerMesssage = "LOAD TO CARRY";
    }
    notifyListeners();
  }
}
