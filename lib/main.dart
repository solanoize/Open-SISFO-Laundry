import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/screens/barang_screens/daftar_barang_screen.dart';

final Drawer drawer = Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Drawer Header'),
      ),
      ListTile(
        title: const Text('Item 1'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      )
    ],
  ),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Open SISFO Laundry',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: DaftarBarangScreen(),
    );
  }
}
