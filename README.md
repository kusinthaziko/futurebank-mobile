<h1 align="center">futureBank — Mobile App</h1>

<p align="center">
  <strong>Flutter campus financial super-app for Android & iOS</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/flutter-3.31-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/dart-3.11-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/target-android_|_ios-success" alt="Platforms"/>
  <img src="https://img.shields.io/badge/tests-49_✔️-success" alt="Tests"/>
</p>

---

## 📋 Overview

futureBank is a campus-native financial super-app. This Flutter application connects students with modern financial tools — savings accounts, peer transfers, micro-loans, group savings, AI-powered financial coaching, and a blockchain-anchored financial passport that graduates own forever.

**Key features:**
- Beautiful, modern UI with custom design system
- Student registration with institution selection
- Real-time balance and transaction updates via WebSocket
- AI financial coach with personalized advice (powered by Cerebras/Gemini)
- Peer-to-peer transfers and deposits
- Micro-loan applications with AI risk scoring
- Group savings circles and financial challenges
- Financial health score with detailed breakdown
- Blockchain DID and financial passport
- Offline-first architecture with local caching
- Biometric authentication and auto-lock security

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.31 |
| **Language** | Dart 3.11 |
| **State Management** | Riverpod 2.6 (AI Coach: flutter_bloc) |
| **Navigation** | go_router 14 (with auth guards) |
| **API Layer** | graphql_flutter 5.2 (queries, mutations, subscriptions) |
| **Local DB** | Drift (SQLite) for offline cache |
| **Auth** | flutter_secure_storage + JWT decoding |
| **Security** | local_auth (biometrics) + flutter_windowmanager |
| **Charts** | fl_chart |
| **Animations** | Lottie |
| **GenUI** | genui for AI-generated UI components |
| **QR** | mobile_scanner + qr_flutter |
| **PDF** | pdf + printing |
| **Voice** | speech_to_text |

---

## 📁 Project Structure

```
app/
├── lib/
│   ├── main.dart                        # App entry point + lifecycle observer
│   ├── core/
│   │   ├── design_system/               # Design tokens & components
│   │   │   ├── tokens/                  # Colors, typography, spacing
│   │   │   ├── components/              # FBButton, FBCard, FBInput, etc.
│   │   │   └── theme.dart               # Material theme configuration
│   │   ├── graphql/
│   │   │   └── client.dart              # GraphQL client + certificate pinning
│   │   ├── router/
│   │   │   └── router.dart              # go_router config + route guards
│   │   ├── providers/
│   │   │   ├── auth_provider.dart       # Auth state management
│   │   │   ├── security_provider.dart   # Auto-lock + biometrics
│   │   │   ├── subscription_manager.dart # WebSocket retry logic
│   │   │   └── subscription_providers.dart # Real-time data streams
│   │   ├── services/
│   │   │   ├── security_service.dart    # Screenshot prevention
│   │   │   ├── biometric_service.dart   # Fingerprint/Face ID
│   │   │   └── cache_service.dart       # TTL-based caching
│   │   ├── storage/
│   │   │   └── app_database.dart        # Drift SQLite schema
│   │   ├── utils/
│   │   │   ├── error_utils.dart         # Error message formatting
│   │   │   ├── validators.dart          # Input validation
│   │   │   └── formatters.dart          # Currency, date formatting
│   │   └── widgets/
│   │       ├── error_view.dart          # Error state widget
│   │       └── offline_banner.dart      # Connectivity indicator
│   └── features/
│       ├── splash/                      # Animated splash screen
│       ├── onboarding/                  # 3-slide intro (Lottie)
│       ├── auth/                        # Login, register, KYC, biometrics
│       ├── dashboard/                   # Home screen with balance card
│       ├── accounts/                    # Accounts, transfers, deposits
│       ├── transactions/                # History, filters, AI search
│       ├── loans/                       # Apply, track, repay
│       ├── social/                      # Groups, challenges, leaderboard
│       ├── ai_coach/                    # AI chat + GenUI widgets
│       ├── profile/                     # Settings, passport, badges
│       └── admin/                       # Finance manager panel
├── assets/
│   ├── fonts/                           # Clash Display + Inter
│   ├── animations/                      # Lottie .json files
│   └── icons/                           # Custom SVG icons
├── test/
│   ├── core/
│   │   └── error_utils_test.dart
│   ├── features/
│   │   ├── auth/                        # Auth state + notifier tests
│   │   ├── dashboard/                   # Balance card, health score widgets
│   │   ├── loans/                       # Loan status stepper
│   │   ├── transactions/                # Transaction notifier
│   │   └── ai_coach/                    # Coach catalog
│   └── helpers/
│       └── mocks.dart                   # Mock data factories
└── pubspec.yaml
```

---

## 🚀 Prerequisites

- **Flutter** 3.31+ (`flutter --version`)
- **Dart** 3.11+ (bundled with Flutter)
- **Android Studio** or **Xcode** (for device builds)
- A **physical device** or **emulator**

### Flutter Installation

```bash
# Download Flutter SDK
cd ~
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter doctor

# Enable desktop/Android/iOS as needed
flutter config --enable-android
```

---

## 🔧 Local Setup

```bash
# 1. Clone the repository
git clone https://github.com/kusinthaziko/futurebank-mobile.git
cd futurebank-mobile

# 2. Fetch dependencies
flutter pub get

# 3. Generate code (freezed models, drift, riverpod)
dart run build_runner build --delete-conflicting-outputs

# 4. Start the backend first (see backend/README.md)
#    Then run the app:
flutter run --dart-define=API_URL=http://YOUR_IP:4000/api/graphql \
            --dart-define=WS_URL=ws://YOUR_IP:4000/socket/websocket

# Replace YOUR_IP with your computer's local network IP
# so the phone can reach the backend
```

---

## 🔐 Configuration

The app reads configuration at compile time via `--dart-define` flags:

| Flag | Description | Default |
|------|-------------|---------|
| `API_URL` | GraphQL endpoint | `http://localhost:4000/api/graphql` |
| `WS_URL` | WebSocket endpoint | `ws://localhost:4000/socket/websocket` |

### Run Modes

```bash
# Development (local backend)
flutter run --dart-define=API_URL=http://192.168.1.100:4000/api/graphql \
            --dart-define=WS_URL=ws://192.168.1.100:4000/socket/websocket

# Staging (Render backend)
flutter run --dart-define=API_URL=https://futurebank-api.onrender.com/api/graphql \
            --dart-define=WS_URL=wss://futurebank-api.onrender.com/socket/websocket

# Release build
flutter build apk --release --dart-define=API_URL=https://your-api.com/api/graphql
```

---

## 📱 Features Walkthrough

### 1. Onboarding & Auth

| Screen | Description |
|--------|-------------|
| **Splash** | Animated logo, checks for existing auth token |
| **Onboarding** | 3 slides (Lottie animations) — saving, loans, financial identity |
| **Register** | Select institution, enter name/student ID/email/password |
| **Login** | Email + password (or biometric if previously enrolled) |
| **Email Verification** | 6-digit OTP sent to email |
| **Biometric Setup** | Enable fingerprint/Face ID for quick login |
| **KYC** | Upload student card or ID (Cloudinary) |

### 2. Dashboard

The home screen shows at a glance:
- **Balance card** with blur toggle (privacy mode)
- **Quick actions**: Send, Deposit, Loans, More
- **Savings goals** progress rings
- **Financial health score** arc gauge (0–1000)
- **Active challenge** with progress bar
- **AI coach nudge** with personalized insight
- **Recent transactions** (last 5, live updates)

### 3. Accounts

- **Account list** with balances per account
- **Account detail** with balance history chart and interest earned
- **Create savings goals** with target amounts and deadlines
- **Transfer** to other students by student ID or QR code
- **Deposit** money (admin confirms manually)

### 4. Transactions

- **Infinite scroll** paginated transaction list
- **Filter** by type, date range, amount
- **AI search** — natural language queries ("food expenses last month")
- **Receipt view** with shareable PDF

### 5. Loans

- **Eligibility check** with AI risk score explanation
- **Loan application** — amount, purpose, repayment period
- **Status tracker** (submitted → reviewing → approved → disbursed)
- **Repayment schedule** with one-tap payment
- **Blockchain contract hash** visible (trust signal)

### 6. Social & Challenges

- **Group savings circles** — create, invite, contribute together
- **Department leaderboard** (anonymous option)
- **Financial challenges** — streaks, savings targets
- **Badges** on profile (NFT-backed credentials)

### 7. AI Coach

- **Full chat interface** with personalized financial coaching
- **Context-aware** — knows balance, goals, spending, loans
- **Tool calling** — can check real data (balance, transactions, etc.)
- **Suggested prompts**: "How much can I save this month?"
- **Weekly insights** carousel with spending analysis
- **Voice input** supported

### 8. Profile & Passport

- **Financial health score** breakdown (savings, loans, challenges, KYC, tenure)
- **Badges and credentials** earned
- **Blockchain DID** (copyable, your decentralized identity)
- **Financial passport** — verifiable on-chain credential
- **Settings**: auto-lock timer, privacy controls

### 9. Admin Panel (Finance Managers)

- **Pending deposits** — approve or reject
- **Loan queue** — review AI scores, approve/reject with notes
- **Student search** — view any student's profile
- **Reports** — total savings, active loans, default rate, CSV export

---

## 🧪 Testing

```bash
# Run all tests (49 tests, 0 failures)
flutter test

# Run a specific test file
flutter test test/features/auth/auth_state_test.dart

# Run tests by directory
flutter test test/features/auth/

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Test Coverage

| Test File | Tests | What It Covers |
|-----------|-------|----------------|
| `auth_state_test.dart` | 8 | Sealed class constructors, equality, pattern matching |
| `auth_notifier_test.dart` | 5 | Login, logout, state transitions, storage mocking |
| `balance_card_test.dart` | 3 | Balance display, blur toggle, account info |
| `health_score_tile_test.dart` | 5 | Score rendering for each tier |
| `loan_status_stepper_test.dart` | 4 | All loan statuses with dates |
| `transaction_notifier_test.dart` | 9 | Pagination, state management, filters |
| `coach_catalog_test.dart` | 3 | Catalog item structure and schemas |
| `error_utils_test.dart` | 13 | Error message formatting, code extraction |

---

## 🏗️ Architecture

### State Management (Riverpod)

```
┌─────────────────────────────────────────────────┐
│                   UI Layer                        │
│  Screens & Widgets (ref.watch / ref.read)        │
├─────────────────────────────────────────────────┤
│               Domain Layer                        │
│  Providers (connect data to UI, business logic)   │
├─────────────────────────────────────────────────┤
│                Data Layer                         │
│  Repositories (GraphQL client + cache fallback)   │
│  Models (freezed, JSON serialization)             │
│  GraphQL (queries, mutations, subscriptions)      │
├─────────────────────────────────────────────────┤
│               Core Services                       │
│  Auth, Cache, Security, Connectivity, GraphQL     │
└─────────────────────────────────────────────────┘
```

### Offline-First Strategy

```
Request Data
    │
    ├── Cache hit (fresh within TTL) → Return cached
    ├── Cache miss → Fetch from API
    │       │
    │       ├── Success → Cache response → Return
    │       └── Error → Return stale cache (if exists)
    │                   └── No cache → Throw error
    └── Mutation → Optimistic update → Sync
```

### GraphQL Subscriptions (Real-Time)

The app maintains WebSocket connections for live updates:
- **Balance changes** — balance updates on the dashboard
- **Transaction updates** — new transactions slide in
- **Loan status changes** — approval/rejection updates
- **Notifications** — push notification badges

### Auto-Lock Security

```
App goes to background → Timer starts (5 min)
    │
App comes to foreground → Check timer
    │
    ├── < 5 min → Return to app
    └── ≥ 5 min → Lock screen → Biometric unlock
```

---

## 🏗️ Building for Distribution

### Android APK

```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (for distribution)
flutter build apk --release --dart-define=API_URL=https://your-api.com/api/graphql

# Split APK per architecture (smaller files)
flutter build apk --release --split-per-abi --dart-define=API_URL=https://your-api.com/api/graphql

# App Bundle (for Play Store)
flutter build appbundle --release --dart-define=API_URL=https://your-api.com/api/graphql
```

The APK will be at:
- `build/app/outputs/flutter-apk/app-release.apk`

### iOS (Requires macOS + Xcode)

```bash
# Open in Xcode to configure signing
open ios/Runner.xcworkspace

# Build for App Store
flutter build ios --release --dart-define=API_URL=https://your-api.com/api/graphql

# Distribute via TestFlight
# Archive in Xcode → Distribute → TestFlight
```

### Minimum Requirements

| Platform | Minimum Version |
|----------|----------------|
| Android | Android 8.0 (API 26) |
| iOS | iOS 15.0 |

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_riverpod` | ^2.6.1 | State management |
| `go_router` | ^14.6.2 | Navigation & route guards |
| `graphql_flutter` | ^5.2.0 | GraphQL client + subscriptions |
| `drift` | ^2.22.1 | Local SQLite database |
| `flutter_secure_storage` | ^9.2.2 | Encrypted token storage |
| `local_auth` | ^2.3.0 | Biometric authentication |
| `lottie` | ^3.1.0 | Lottie animations |
| `fl_chart` | ^0.69.0 | Charts and gauges |
| `freezed` | ^2.5.7 | Immutable model generation |
| `shimmer` | ^3.0.0 | Loading skeleton effects |
| `mobile_scanner` | ^5.2.3 | QR code scanning |
| `flutter_windowmanager` | ^0.2.0 | Screenshot prevention |
| `connectivity_plus` | ^7.1.1 | Network state monitoring |
| `intl` | ^0.20.2 | Currency/number formatting |

---

## 🔒 Security Features

- **Certificate pinning** — Production builds reject untrusted TLS certificates (MITM protection)
- **Screenshot prevention** — Sensitive screens hidden in app switcher (Android FLAG_SECURE)
- **Auto-lock** — App locks after 5 minutes in background, re-auth via biometrics
- **Token storage** — All tokens in `flutter_secure_storage` (Keychain/Keystore)
- **Biometric gates** — Transfers, loan applications, and settings changes require biometric confirmation
- **Offline data** — Cached data encrypted at rest via Drift
- **Session management** — Logout clears all local data and revokes sessions

---

## 📝 License

Proprietary. All rights reserved.

---

<p align="center">
  <a href="https://futurebank.app">Website</a> ·
  <a href="mailto:hello@futurebank.app">Contact</a>
</p>
