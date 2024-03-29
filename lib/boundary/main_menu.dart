// external packages
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  MainMenu({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Parker App"),
            Padding(
              padding: EdgeInsets.all(100),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.search, size: 16),
              label: Text('Search'),
              onPressed: () async {
                var error = await checkLocationService();
                // if no errors with location services
                if (error == null)
                  navigateToSearch();
                // pops up error message if navigate function returns non null string
                else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: new Text("Location Permission Issue"),
                      content: new Text(error),
                      actions: <Widget>[
                        if (error.toString().contains("denied"))
                          TextButton(
                            onPressed: () {
                              openAppSettings();
                              Navigator.pop(context, "OK");
                            },
                            child: Text("Open Settings"),
                          ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, "Cancel"),
                          child: Text("Cancel"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.bookmark_outline, size: 16),
              label: Text('Bookmarks'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  dynamic checkLocationService() async {
    bool locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationEnabled)
      return "Location services disabled, please enable location services on your smartphone for Parker to work properly";

    int count = 0;
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever)
      return "Permission denied forever, please enable permission for Parker to work properly";

    while (permission == LocationPermission.denied) {
      if (count >= 3)
        return "Permissions denied multiple times, please allow location permissions for Parker to work properly";
      await LocationPermissions().requestPermissions();
      permission = await Geolocator.checkPermission();
      count++;
    }
  }

  dynamic navigateToSearch() {}
}
