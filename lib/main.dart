import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/providers/item_provider.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/screens/barang_screens/daftar_barang_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ItemProvider()),
      ChangeNotifierProvider(create: (context) => TerimaProvider()),
    ],
    child: const MyApp(),
  ));
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
