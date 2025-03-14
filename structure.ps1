# Define project root directory
$root = "lib"

# Define directories
$directories = @(
    "$root/blocs",
    "$root/models",
    "$root/services",
    "$root/screens",
    "$root/widgets"
)

# Define files
$files = @(
    "$root/blocs/transaction_bloc.dart",
    "$root/blocs/category_bloc.dart",
    "$root/blocs/budget_bloc.dart",
    "$root/models/transaction_model.dart",
    "$root/models/category_model.dart",
    "$root/models/budget_model.dart",
    "$root/services/database.dart",
    "$root/services/transaction_repository.dart",
    "$root/screens/home_screen.dart",
    "$root/screens/transaction_screen.dart",
    "$root/screens/budget_screen.dart",
    "$root/screens/category_screen.dart",
    "$root/widgets/custom_button.dart",
    "$root/widgets/transaction_card.dart",
    "$root/main.dart"
)

# Create directories
foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }
}

# Create blank files
foreach ($file in $files) {
    if (!(Test-Path $file)) {
        New-Item -ItemType File -Path $file | Out-Null
    }
}

Write-Host "Flutter project structure and blank files created successfully!" -ForegroundColor Green
