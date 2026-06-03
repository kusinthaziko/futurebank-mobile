# App Progress

## Status: In Progress

## Stack
- Flutter (Android + iOS)
- Package ID: com.futurebank.app
- State: Riverpod + flutter_bloc (coach screen only)
- Navigation: go_router
- GraphQL: graphql_flutter
- Local DB: Drift (SQLite)
- Auth: flutter_secure_storage + local_auth

## Specs Location
All specs are in `../specs/app/`. Read them before touching any feature.

## Feature Modules (all in `lib/features/`)
| Feature | Status |
|---|---|
| `auth` | ⬜ not started |
| `onboarding` | ⬜ not started |
| `dashboard` | ⬜ not started |
| `accounts` | ⬜ not started |
| `transactions` | ⬜ not started |
| `loans` | ⬜ not started |
| `social` | ⬜ not started |
| `challenges` | ⬜ not started |
| `ai_coach` | ⬜ not started |
| `profile` | ⬜ not started |
| `admin` | ⬜ not started |

## Completed
- [x] Flutter scaffold (Android + iOS)
- [x] Package ID set to com.futurebank.app
- [x] pubspec.yaml — all 2026 dependencies, flutter pub get succeeded
- [x] Folder structure (core/, features/)
- [x] Design system — colors, dimensions, typography, theme, FBButton, FBCard, FBInput, FBSkeletonLoader, FBAvatar
- [x] GraphQL client with WebSocket support and Riverpod provider
- [x] Router — all routes, bottom nav shell, auth redirect guards
- [x] Auth provider — JWT secure storage, login/logout
- [x] Onboarding screen — 3 slides, dot indicator
- [x] Login screen — email/password, error handling
- [x] Register screen — full validation, inline errors
- [x] Dashboard screen — balance card, quick actions, health score, recent transactions
- [x] Accounts screen — list with gradient savings card
- [x] Transaction history screen — list with credit/debit colors
- [x] Loans screen — eligibility card, loan list with status
- [x] Loan apply screen — 3-step wizard (amount, period, review)
- [x] Social screen — groups tab + challenges tab
- [x] AI Coach screen — chat interface, voice input, suggested prompts
- [x] Profile screen — health score breakdown, blockchain DID, logout
- [x] flutter analyze — 0 errors

## Next Steps
1. Download and add fonts (ClashDisplay, Inter) to assets/fonts/
2. Point API_URL to backend (use --dart-define at run time)
3. Test on device: `flutter run --dart-define=API_URL=http://YOUR_IP:4000/api/graphql`
4. Add Cloudinary KYC upload flow
5. Add real-time subscriptions (balance, notifications)

## Run Commands
```bash
# Development
flutter run --dart-define=API_URL=http://localhost:4000/api/graphql \
            --dart-define=WS_URL=ws://localhost:4000/socket/websocket

# Start backend first
cd ../backend && mix phx.server
```

## Architecture Rules (READ BEFORE CODING)
- Feature-first folder structure: `features/{name}/data|domain|presentation`
- Riverpod for all state — no setState outside widgets
- No hardcoded strings — use constants
- All tokens stored in flutter_secure_storage, never SharedPreferences
- Money displayed as Decimal, never double
- GenUI only in ai_coach feature — no other screen uses it
- Bloc used only in ai_coach — everything else uses Riverpod
- GraphQL subscriptions for real-time (balance, transactions, notifications)

## Commit Convention
- `feat(feature): description` e.g. `feat(auth): add login screen`
- `fix(feature): description`
- `chore: description`
- `docs: description`
