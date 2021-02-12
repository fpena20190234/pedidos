import 'package:flutter/material.dart';

import '../Widgets/navigation_bloc.dart';
import '../Pages/consumos.dart';
class MyAccountsPage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: DataTableDemo(),

    );
  }
}
