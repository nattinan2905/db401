import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
  const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjczMjRhMmRlZDhiMDM1MGQzMTViZDljNDEwOGI4YWEwYjRkNDllYjg2MmY4MTkwYjU0ZDZhNzcxZWQ3MWFmZWI5ZjNlMTVkYTRhMDdjMTgxIn0.eyJhdWQiOiIyIiwianRpIjoiNzMyNGEyZGVkOGIwMzUwZDMxNWJkOWM0MTA4YjhhYTBiNGQ0OWViODYyZjgxOTBiNTRkNmE3NzFlZDcxYWZlYjlmM2UxNWRhNGEwN2MxODEiLCJpYXQiOjE2Njg5Mzg0OTUsIm5iZiI6MTY2ODkzODQ5NSwiZXhwIjoxNzAwNDc0NDk1LCJzdWIiOiIyMjczIiwic2NvcGVzIjpbXX0.QetXx_lrtozAgUm3lWNgKzjV23gblfIBjqzgoihkH4pRymViwNUzrMkg-mP3EB-dxU4l6ySqITPvjwCxYH_YboHkZlBSNxSIVEvQ3SBRJixvuxZxjgU_6b6uwpbO3dvXJw1fpxTcDrIFK7tcCFYjFnMyi9cXSualwKoCB9LJU3Vh7PNmKUuc8BIdfFs3xWvgeK44Le0yVdrWev2BCrepldgX0NB0apUqDWMDYtZ2TC_rvBlhVFKPmGnu4LbSN1ZI07-zl__JfLaVicEjf9z7pXk48XVv9gHSj_EVMdUUuQ81EYVO-HczN3UrGmAvdFcSKzg_emwSDI-HejvP0XNG5CIAdVu307vh7qcI0c3HfeRg_5rBftgIdIHDvhfzrQoixZEb7yVWgFvePdlpoRcMmjzwfPTNb7NEtNzDyfLFQeaodzYDqktm3O9l7m4nbqJ4KwgAnjN8bqL_4A29uYjyMu0oRqwft7gEbTQ29wot_sdj9e5KEXWgkNdWuAo-TYNwndU5o9J1JFbYJ-_Ualy46utNxj8TboKEjfVlek6QgwbUXYu4YtXXAngeVxgTovJa65EEDebBPyMXv6l37UXds_oTsZ1yhaxU0vhuIu6aorzZFu-lGWQ72nJq0sQvK_25AJKhxFdbECnAWUZUvCUVMrr2c7r0p693RG8scL4xrPg';

try {
  Position location = await getCurrentLocation();
  http.Response response = await http.get(
    Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'), 
    headers: {
      'accept': 'application/json',
      'authorization': 'Bearer $token',
    }
  );
if(response.statusCode == 200) {
  var result = jsonDecode(response.body)['WeatherForecasts'][0]['forecasts'][0]['data'];
  Placemark address = (await placemarkFromCoordinates(location.latitude, location.longitude)).first;
  return Weather(
    address: '${address.subLocality}\n${address.administrativeArea}',
    temperature: result['tc'],
    cond: result['cond'],
  );
} else {
  return Future.error(response.statusCode);
}
} catch (e) {
  return Future.error(e);
}
}