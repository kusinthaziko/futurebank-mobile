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
- [x] Design system — colors, dimensions, typography, theme, components, fonts
- [x] GraphQL client, auth provider, router with all routes + guards
- [x] All screens implemented
- [x] GenUI AI Coach — catalog (4 financial widgets), CoachBloc, CoachRepository, CoachView
- [x] Proper feature-first architecture with data/domain/presentation layers:
  - Dashboard: queries, freezed models, repository, Riverpod providers, 4 widgets, thin screen
  - Loans: queries, freezed models, repository, providers, widgets, screens
  - Accounts: queries, freezed models, repository, providers
  - Social: queries, freezed models, repository, providers
  - Profile: queries, freezed models, repository, providers
- [x] flutter analyze — 0 errors

## Next Steps
1. Download fonts if missing (ClashDisplay, Inter) — see assets/fonts/
2. Run: `flutter run --dart-define=API_URL=http://YOUR_IP:4000/api/graphql --dart-define=WS_URL=ws://YOUR_IP:4000/socket/websocket --dart-define=GEMINI_KEY=YOUR_KEY`
3. Start backend: `cd ../backend && mix phx.server`

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
