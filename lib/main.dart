import 'package:flutter/material.dart';
import 'package:open_sisfo_laundry/providers/item_provider.dart';
import 'package:open_sisfo_laundry/providers/terima_provider.dart';
import 'package:open_sisfo_laundry/res/sizes.dart';
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
        appBarTheme: AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          toolbarHeight: kToolbarHeight + 1,
        ),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(
            vertical: size14,
            horizontal: size16,
          ),
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
        buttonTheme: ButtonThemeData(
          padding: EdgeInsets.symmetric(horizontal: size20, vertical: size16),
          buttonColor: Colors.amber,
        ),
        listTileTheme: ListTileThemeData(
          // contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: 0, vertical: -2),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          linearMinHeight: 1,
        ),
      ),
      home: DaftarBarangScreen(),
    );
  }
}
