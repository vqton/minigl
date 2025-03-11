# Define base directory
$baseDir = "E:\android\minigl"

# Define folder structure
$folders = @(
    "lib/core",
    "lib/features/categories/data",
    "lib/features/categories/presentation/bloc",
    "lib/features/categories/presentation",
    "lib/features/transactions/data",
    "lib/features/transactions/presentation/bloc",
    "lib/features/transactions/presentation",
    "lib/features/budgets/data",
    "lib/features/budgets/presentation/bloc",
    "lib/features/budgets/presentation",
    "lib/features/reports/data",
    "lib/features/reports/presentation/bloc",
    "lib/features/reports/presentation",
    "lib/features/app_settings/data",
    "lib/features/app_settings/presentation/bloc",
    "lib/features/app_settings/presentation"
)

# Define blank files to create
$files = @(
    "lib/core/database.dart",
    "lib/core/logger.dart",
    "lib/core/utils.dart",
    "lib/features/categories/data/category_model.dart",
    "lib/features/categories/data/category_repository.dart",
    "lib/features/categories/presentation/bloc/category_bloc.dart",
    "lib/features/categories/presentation/bloc/category_event.dart",
    "lib/features/categories/presentation/bloc/category_state.dart",
    "lib/features/categories/presentation/category_screen.dart",
    "lib/features/transactions/data/transaction_model.dart",
    "lib/features/transactions/data/transaction_repository.dart",
    "lib/features/transactions/presentation/bloc/transaction_bloc.dart",
    "lib/features/transactions/presentation/bloc/transaction_event.dart",
    "lib/features/transactions/presentation/bloc/transaction_state.dart",
    "lib/features/transactions/presentation/transaction_screen.dart",
    "lib/features/budgets/data/budget_model.dart",
    "lib/features/budgets/data/budget_repository.dart",
    "lib/features/budgets/presentation/bloc/budget_bloc.dart",
    "lib/features/budgets/presentation/bloc/budget_event.dart",
    "lib/features/budgets/presentation/bloc/budget_state.dart",
    "lib/features/budgets/presentation/budget_screen.dart",
    "lib/features/reports/data/report_model.dart",
    "lib/features/reports/data/report_repository.dart",
    "lib/features/reports/presentation/bloc/report_bloc.dart",
    "lib/features/reports/presentation/bloc/report_event.dart",
    "lib/features/reports/presentation/bloc/report_state.dart",
    "lib/features/reports/presentation/report_screen.dart",
    "lib/features/app_settings/data/settings_model.dart",
    "lib/features/app_settings/data/settings_repository.dart",
    "lib/features/app_settings/presentation/bloc/settings_bloc.dart",
    "lib/features/app_settings/presentation/bloc/settings_event.dart",
    "lib/features/app_settings/presentation/bloc/settings_state.dart",
    "lib/features/app_settings/presentation/settings_screen.dart",
    "lib/main.dart",
    "lib/app.dart",
    "lib/routes.dart",
    "lib/di.dart"
)

# Create folders
foreach ($folder in $folders) {
    $path = Join-Path -Path $baseDir -ChildPath $folder
    if (!(Test-Path $path)) {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
    }
}

# Create blank files
foreach ($file in $files) {
    $filePath = Join-Path -Path $baseDir -ChildPath $file
    if (!(Test-Path $filePath)) {
        New-Item -Path $filePath -ItemType File -Force | Out-Null
    }
}

Write-Host "Project structure created successfully in $baseDir" -ForegroundColor Green
