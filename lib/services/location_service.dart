import 'package:location/location.dart';

class _LocationService {
  Future<List<String>?> getLocationMapData() async {
    Location location = new Location();

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
        return null;
      }
    }

    _locationData = await location.getLocation();

    print(_locationData);



    _locationData.longitude.toString();

    String locationMapString  = 'https://maps.googleapis.com/maps/api/staticmap?center=${_locationData.latitude.toString()},${_locationData.longitude.toString()}&zoom=15&size=500x500&markers=color:blue%7Clabel:S%7C6.36,106.5&key=AIzaSyDz2IXMpRsaHZ35YdXPTr0gPNx9D1oy4nY';

    print(locationMapString);


    return [locationMapString,_locationData.latitude.toString(),_locationData.longitude.toString()];

    //https://maps.googleapis.com/maps/api/staticmap?center=6.3,106.5&zoom=15&size=500x500&markers=color:blue%7Clabel:S%7C6.36,106.5&key=AIzaSyDz2IXMpRsaHZ35YdXPTr0gPNx9D1oy4nY


  }
}



final locationService = _LocationService();

