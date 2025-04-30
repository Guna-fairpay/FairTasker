enum FlavorType {
  debug,
  production
}

class Flavor {
  final FlavorType type;
  Flavor(this.type);

  static Flavor debug = Flavor(FlavorType.debug);
  static Flavor production = Flavor(FlavorType.production);

  String get _tasker => switch(type) {
    FlavorType.debug => "https://apidevfairtasker.fairreturns.in/",
    FlavorType.production => "https://apitaskmanager.fairreturns.com/",
  };

  String get _portalUrl => switch(type) {
    FlavorType.debug => "https://apiorgportal.fairreturns.in/",
    FlavorType.production => "https://apiorg.fairreturns.com/",
  };

  String get _devReturns => switch(type){
    FlavorType.debug => "https://phase1.fairreturns.in/",
    FlavorType.production => "https://fairreturns.com/",
  };

  String get _baseUrl => "${_tasker}api/";
  String get _orgUrl => "${_portalUrl}api/";
  String get _storageUrl => "${_devReturns}storage/";
  String get _fairReturnsUrl => "${_devReturns}api/";
  String get _attachmentUrl => _tasker;

  bool get isDebug => type == FlavorType.debug;
  bool get isProduction => type == FlavorType.production;

  String get baseUrl => _baseUrl;
  String get portalUrl => _orgUrl;
  String get storageUrl => _storageUrl;
  String get returnsUrl => _fairReturnsUrl;
  String get attachmentUrl => _attachmentUrl;
}