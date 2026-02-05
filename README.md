# StreakQuest

A premium, offline-first Gamified Habit & Finance Tracker built with Flutter.

## Features
- **Habit Tracking**: Flexible frequencies (Daily, Weekly, Custom), Streak calculation.
- **Gamification**: XP System, Levels, Coins, and Achievements.
- **Finance**: Expense/Income tracking, Balance dashboard.
- **Premium UI**: Material 3, Dark/Light Mode, Animations (`flutter_animate`).

## getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the App**:
   ```bash
   flutter run
   ```

## Architecture
This project follows **Clean Architecture**:
- `lib/data`: Data sources (SQLite), Models, Repositories.
- `lib/domain`: Pure business logic (Gamification rules).
- `lib/presentation`: UI (Screens, Widgets) and State Management (Riverpod).

## Key Files
- `lib/main.dart`: App entry point.
- `lib/core/theme/app_theme.dart`: Premium design system.
- `lib/data/database/database_helper.dart`: Database setup.
- `lib/presentation/providers`: Riverpod providers linking UI and Logic.
