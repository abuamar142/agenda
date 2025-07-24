# Agenda - Google Calendar Manager

A Flutter application for managing Google Calendar events with OAuth authentication via Supabase.

## Features

- 🔐 OAuth authentication via Supabase
- 📅 Google Calendar integration
- 🎨 Modern Material Design UI
- 🏗️ Clean Architecture
- 🔄 GetX state management

## Tech Stack

- **Frontend**: Flutter
- **State Management**: GetX
- **Backend & Auth**: Supabase
- **Calendar API**: Google Calendar API

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.8.1)
- Android Studio / VS Code
- Supabase account

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd agenda
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Environment Setup**

   Create `.env` file:

   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/                           # Shared utilities, themes, constants
│   ├── config/                     # Environment & build configuration
│   ├── constants/                  # App constants and configuration
│   ├── di/                         # Dependency injection setup
│   ├── extensions/                 # Extension methods and utilities
│   ├── network/                    # Network layer & HTTP clients
│   ├── routes/                     # App routing configuration
│   ├── themes/                     # App themes and styling
│   └── utils/                      # Helper utilities and logging
├── features/                       # Feature modules (Clean Architecture)
│   ├── auth/                       # Authentication module
│   │   ├── data/                   # Data sources, models, repositories
│   │   ├── domain/                 # Entities, use cases, interfaces
│   │   └── presentation/           # Controllers, views, widgets
│   ├── home/                       # Home dashboard module
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── calendar/                   # Google Calendar integration
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── events/                     # Event management module
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/                         # Shared components (splash, widgets)
└── main.dart                       # App entry point
```

## Architecture

This project follows **Clean Architecture** with modular feature structure:

### Modular Design

- **Features**: Self-contained modules (auth, home, calendar, events)
- **Core**: Shared utilities and configurations
- **Clean Architecture**: Each module has 3 layers

### Three-Layer Architecture

- **Presentation**: UI and state management (GetX)
- **Domain**: Business logic and entities
- **Data**: API calls and data storage

## Development Status

- [x] ✅ Authentication with Supabase OAuth
- [x] ✅ Clean Architecture setup
- [x] ✅ GetX state management
- [x] ✅ Basic UI components
- [ ] 🚧 Google Calendar integration
- [ ] 📋 Event management
- [ ] 📝 Event templates

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/new-feature`)
3. Commit changes (`git commit -m 'Add new feature'`)
4. Push to branch (`git push origin feature/new-feature`)
5. Create Pull Request

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

**Happy Coding! 🚀**
