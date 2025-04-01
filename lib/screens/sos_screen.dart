import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe/components/custom_button.dart';
import 'package:safe/screens/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertMessageScreen extends StatefulWidget {
  const AlertMessageScreen({super.key});

  @override
  _AlertMessageScreenState createState() => _AlertMessageScreenState();
}

class _AlertMessageScreenState extends State<AlertMessageScreen> {
  final TextEditingController textController = TextEditingController();
  final LocationService _locationService = LocationService();
  String locationMessage = "Fetching location...";
  String mapLink = "";

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await _locationService.getCurrentLocation();
      String address = await _locationService.getAddressFromCoordinates(
          position.latitude, position.longitude);
      setState(() {
        locationMessage =
            "Latitude: ${position.latitude}, \nLongitude: ${position.longitude}\nAddress: $address";
        mapLink =
            'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      });
    } catch (e) {
      setState(() {
        locationMessage = e.toString();
      });
    }
  }

  Future<void> sendSMS(String number, String message) async {
    Uri url = Uri.parse("sms:+91$number?body=$message");

    try {
      await launchUrl(url);
    } catch (e) {
      Fluttertoast.showToast(msg: "Try Again");
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Alert'),
          content: Text(
            'The following message will be sent:\n\n$message',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                Navigator.of(context).pop();
                sendSMS("1234567890", message); // Replace with your number
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Alert Message',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            Text(
              locationMessage,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: "Send Alert",
              onPressed: () {
                String finalMessage =
                    "${textController.text}\nLocation: $mapLink";
                _showAlertDialog(finalMessage);
              },
            ),
          ],
        ),
      ),
    );
  }
}