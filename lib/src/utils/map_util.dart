import 'package:url_launcher/url_launcher.dart';

//https://stackoverflow.com/questions/47046637/open-google-maps-app-if-available-with-flutter
class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    Uri googleUrl =
        Uri.parse('google.navigation:q=$latitude,$longitude&mode=d');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
