import 'package:location/location.dart';

class _LocationService {
  Future<List<String>?> getLocationMapData({required Function givePermission}) async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        //permission denied code
        givePermission.call();

        return null;
      }
    }
    //return ['28.7041','77.1025'];
   // return ['23.16899290332625','75.78657699012938'];
   // return ['19.076','72.8777'];

    _locationData = await location.getLocation();
    return [_locationData.latitude.toString(),_locationData.longitude.toString()];
  }
}

final locationService = _LocationService();

