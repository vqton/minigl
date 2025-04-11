import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minigl/app/theme/app_theme.dart';
import 'package:minigl/app_router.dart';
import 'package:minigl/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minigl/logic/transaction_bloc/transaction_bloc.dart';
import 'package:minigl/logic/budget_bloc/budget_bloc.dart';
import 'package:minigl/logic/category_bloc/category_bloc.dart';
import 'package:logger/logger.dart';

// Logger instance for logging events
final Logger logger = Logger();

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator
  logger.i("Initializing service locator...");
  try {
    await setupLocator();
    logger.i("Service locator initialized successfully");
  } catch (e) {
    logger.e("Failed to initialize service locator", error: e);
    return; // Exit if service locator fails
  }

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.i("Building MaterialApp");

    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(
          create: (_) => getIt<TransactionBloc>(),
        ),
        BlocProvider<BudgetBloc>(
          create: (_) => getIt<BudgetBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          create: (_) => getIt<CategoryBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Pocket Bookkeeper',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Automatically adapt to system theme
        initialRoute: AppRoutes.dashboard,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,

        // Localization support
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('es', ''), // Spanish
          Locale('fr', ''), // French
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          logger.i("Selected locale: ${locale?.languageCode}");
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first; // Default to the first supported locale
        },
      ),
    );
  }
}