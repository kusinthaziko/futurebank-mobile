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

## Next Steps (in order)
1. Add all dependencies to pubspec.yaml
2. Set up folder structure (core/, features/, assets/)
3. Implement design system (tokens, components)
4. Implement auth feature
5. Implement onboarding
6. Implement dashboard
7. Implement accounts + transactions
8. Implement loans
9. Implement social + challenges
10. Implement AI coach with GenUI
11. Implement profile + passport

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
