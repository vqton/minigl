import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/features/user/user_bloc.dart';
import 'package:minigl/features/user/user_event.dart';
import 'package:minigl/services/objectbox_services.dart';

import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final objectBoxService = ObjectBoxService();
  await objectBoxService.init();

  runApp(MyApp(objectBoxService));
}

class MyApp extends StatelessWidget {
  final ObjectBoxService objectBoxService;

  const MyApp(this.objectBoxService, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(objectBoxService)..add(LoadUsers()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AmazonStyleFinanceDashboard(),
      ),
    );
  }
}
