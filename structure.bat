:: Create directory structure
mkdir lib\blocs
mkdir lib\blocs\transaction
mkdir lib\models
mkdir lib\views
mkdir lib\widgets
mkdir lib\services
mkdir lib\utils

:: Create empty files
type nul > lib\main.dart

:: BLOC files
type nul > lib\blocs\transaction\transaction_bloc.dart
type nul > lib\blocs\transaction\transaction_event.dart
type nul > lib\blocs\transaction\transaction_state.dart
type nul > lib\blocs\bloc_observer.dart

:: Model files
type nul > lib\models\transaction.dart

:: View files
type nul > lib\views\home_page.dart
type nul > lib\views\add_transaction_page.dart
type nul > lib\views\settings_page.dart

:: Service files
type nul > lib\services\transaction_service.dart

:: Utils files
type nul > lib\utils\app_colors.dart
type nul > lib\utils\currency_formatter.dart
type nul > lib\utils\constants.dart

:: Widget files
type nul > lib\widgets\transaction_list_item.dart
type nul > lib\widgets\balance_card.dart
type nul > lib\widgets\category_selector.dart