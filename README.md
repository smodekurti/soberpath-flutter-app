# Create README.md file
cat > README.md << 'EOF'
# SoberPath - Flutter Recovery Support App

A comprehensive Flutter application designed to support individuals on their sobriety and recovery journey.

## 🎯 Features

### Core Sobriety Tracking
- Days/weeks/months/years sober counter
- Customizable sobriety start date with date picker
- Real-time progress calculations

### Daily Wellness Tracking
- Mood tracking (1-10 scale) with visual indicators
- Craving level monitoring (1-10 scale)
- Daily reflection journal with history

### Milestone & Achievement System
- 8 milestone targets (1, 7, 30, 60, 90, 180, 365, 730 days)
- Visual progress bars and health benefits timeline
- Achievement celebrations and progress tracking

### Support Resources
- Crisis support contacts (988, Crisis Text Line, SAMHSA)
- Recovery resources (AA, NA, SMART Recovery)
- Coping strategies and helpful app recommendations
- Meeting finder with online and local options

## 🛠️ Technology Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **Database**: SQLite (sqflite)
- **UI Design**: Material Design 3 with custom purple theme

## 🚀 Getting Started

```bash
git clone https://github.com/smodekurti/soberpath-flutter-app.git
cd soberpath-flutter-app
flutter pub get
flutter run
