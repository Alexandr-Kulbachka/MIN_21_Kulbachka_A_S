import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/navigation/route_generator.dart';
import 'app/services/admin_account_code_service.dart';
import 'app/services/account_service.dart';
import 'app/services/help_requests_service.dart';
import 'app/services/staff_service.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountService()),
        ChangeNotifierProvider(create: (_) => AdminAccountCodeService()),
        ChangeNotifierProvider(create: (_) => HelpRequestsService()),
        ChangeNotifierProvider(create: (_) => StaffService()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
