import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _usernetworkid = prefs.getString('ff_usernetworkid') ?? _usernetworkid;
    });
    _safeInit(() {
      _ipPC = prefs.getString('ff_ipPC') ?? _ipPC;
    });
    _safeInit(() {
      _ivaoVatsimID = prefs.getInt('ff_ivaoVatsimID') ?? _ivaoVatsimID;
    });
    _safeInit(() {
      _SimbreifID = prefs.getInt('ff_SimbreifID') ?? _SimbreifID;
    });
    _safeInit(() {
      _generatedCode = prefs.getString('ff_generatedCode') ?? _generatedCode;
    });
    _safeInit(() {
      _savedLicenseKeyMSFS =
          prefs.getString('ff_savedLicenseKeyMSFS') ?? _savedLicenseKeyMSFS;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  int _TabNumber = 1;
  int get TabNumber => _TabNumber;
  set TabNumber(int value) {
    _TabNumber = value;
  }

  String _currentICAO = '';
  String get currentICAO => _currentICAO;
  set currentICAO(String value) {
    _currentICAO = value;
  }

  String _usernetworkid = '';
  String get usernetworkid => _usernetworkid;
  set usernetworkid(String value) {
    _usernetworkid = value;
    prefs.setString('ff_usernetworkid', value);
  }

  int _FailureSubTab = 0;
  int get FailureSubTab => _FailureSubTab;
  set FailureSubTab(int value) {
    _FailureSubTab = value;
  }

  String _PDFlinkSimbreif = '';
  String get PDFlinkSimbreif => _PDFlinkSimbreif;
  set PDFlinkSimbreif(String value) {
    _PDFlinkSimbreif = value;
  }

  double _currentHeading = 0.0;
  double get currentHeading => _currentHeading;
  set currentHeading(double value) {
    _currentHeading = value;
  }

  double _currentX = 0.0;
  double get currentX => _currentX;
  set currentX(double value) {
    _currentX = value;
  }

  double _currentZ = 0.0;
  double get currentZ => _currentZ;
  set currentZ(double value) {
    _currentZ = value;
  }

  String _SIMtime = '';
  String get SIMtime => _SIMtime;
  set SIMtime(String value) {
    _SIMtime = value;
  }

  String _SIMspeed = '';
  String get SIMspeed => _SIMspeed;
  set SIMspeed(String value) {
    _SIMspeed = value;
  }

  List<int> _ActiveFailures = [];
  List<int> get ActiveFailures => _ActiveFailures;
  set ActiveFailures(List<int> value) {
    _ActiveFailures = value;
  }

  void addToActiveFailures(int value) {
    ActiveFailures.add(value);
  }

  void removeFromActiveFailures(int value) {
    ActiveFailures.remove(value);
  }

  void removeAtIndexFromActiveFailures(int index) {
    ActiveFailures.removeAt(index);
  }

  void updateActiveFailuresAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    ActiveFailures[index] = updateFn(_ActiveFailures[index]);
  }

  void insertAtIndexInActiveFailures(int index, int value) {
    ActiveFailures.insert(index, value);
  }

  double _currentLAT = 0.0;
  double get currentLAT => _currentLAT;
  set currentLAT(double value) {
    _currentLAT = value;
  }

  double _currentLON = 0.0;
  double get currentLON => _currentLON;
  set currentLON(double value) {
    _currentLON = value;
  }

  dynamic _resultXZ;
  dynamic get resultXZ => _resultXZ;
  set resultXZ(dynamic value) {
    _resultXZ = value;
  }

  String _currentALT = '';
  String get currentALT => _currentALT;
  set currentALT(String value) {
    _currentALT = value;
  }

  String _currentSPD = '';
  String get currentSPD => _currentSPD;
  set currentSPD(String value) {
    _currentSPD = value;
  }

  String _ipPC = '';
  String get ipPC => _ipPC;
  set ipPC(String value) {
    _ipPC = value;
    prefs.setString('ff_ipPC', value);
  }

  bool _isIpValid = true;
  bool get isIpValid => _isIpValid;
  set isIpValid(bool value) {
    _isIpValid = value;
  }

  int _ivaoVatsimID = 0;
  int get ivaoVatsimID => _ivaoVatsimID;
  set ivaoVatsimID(int value) {
    _ivaoVatsimID = value;
    prefs.setInt('ff_ivaoVatsimID', value);
  }

  int _SimbreifID = 0;
  int get SimbreifID => _SimbreifID;
  set SimbreifID(int value) {
    _SimbreifID = value;
    prefs.setInt('ff_SimbreifID', value);
  }

  String _web = '';
  String get web => _web;
  set web(String value) {
    _web = value;
  }

  String _generatedCode = '';
  String get generatedCode => _generatedCode;
  set generatedCode(String value) {
    _generatedCode = value;
    prefs.setString('ff_generatedCode', value);
  }

  double _msfsaltitude = 0.0;
  double get msfsaltitude => _msfsaltitude;
  set msfsaltitude(double value) {
    _msfsaltitude = value;
  }

  double _msfsairspeed = 0.0;
  double get msfsairspeed => _msfsairspeed;
  set msfsairspeed(double value) {
    _msfsairspeed = value;
  }

  double _msfsheading = 0.0;
  double get msfsheading => _msfsheading;
  set msfsheading(double value) {
    _msfsheading = value;
  }

  double _msfslatitude = 0.0;
  double get msfslatitude => _msfslatitude;
  set msfslatitude(double value) {
    _msfslatitude = value;
  }

  double _msfslongitude = 0.0;
  double get msfslongitude => _msfslongitude;
  set msfslongitude(double value) {
    _msfslongitude = value;
  }

  double _Checklist = 1.0;
  double get Checklist => _Checklist;
  set Checklist(double value) {
    _Checklist = value;
  }

  double _RWYLENGHTtakeoff = 0.0;
  double get RWYLENGHTtakeoff => _RWYLENGHTtakeoff;
  set RWYLENGHTtakeoff(double value) {
    _RWYLENGHTtakeoff = value;
  }

  double _RWYLENGHTlading = 0.0;
  double get RWYLENGHTlading => _RWYLENGHTlading;
  set RWYLENGHTlading(double value) {
    _RWYLENGHTlading = value;
  }

  String _generateCodeMSFS = '';
  String get generateCodeMSFS => _generateCodeMSFS;
  set generateCodeMSFS(String value) {
    _generateCodeMSFS = value;
  }

  String _licenseExpiryDateMSFS = '';
  String get licenseExpiryDateMSFS => _licenseExpiryDateMSFS;
  set licenseExpiryDateMSFS(String value) {
    _licenseExpiryDateMSFS = value;
  }

  String _licenseExpiryDateXPlane = '';
  String get licenseExpiryDateXPlane => _licenseExpiryDateXPlane;
  set licenseExpiryDateXPlane(String value) {
    _licenseExpiryDateXPlane = value;
  }

  String _savedLicenseKeyMSFS = '';
  String get savedLicenseKeyMSFS => _savedLicenseKeyMSFS;
  set savedLicenseKeyMSFS(String value) {
    _savedLicenseKeyMSFS = value;
    prefs.setString('ff_savedLicenseKeyMSFS', value);
  }

  String _currentPlanTypeMSFS = '';
  String get currentPlanTypeMSFS => _currentPlanTypeMSFS;
  set currentPlanTypeMSFS(String value) {
    _currentPlanTypeMSFS = value;
  }

  int _subscriptionManagepageNumber = 0;
  int get subscriptionManagepageNumber => _subscriptionManagepageNumber;
  set subscriptionManagepageNumber(int value) {
    _subscriptionManagepageNumber = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
