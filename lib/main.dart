import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps/res/routes/app_pages.dart';
import 'package:google_maps/res/routes/app_routes.dart';
import 'package:google_maps/viewmodel/current_location_viewmodel.dart';
import 'package:google_maps/viewmodel/marker_viewmodel.dart';
import 'package:google_maps/viewmodel/polygoneviewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CurrentLocationViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => MarkerViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => PolyLinesViewModel(),
        )
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        routes: AppPages.routes,
        initialRoute: AppRoutes.initial,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
