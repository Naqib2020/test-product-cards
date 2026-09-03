# Contributing

Thank you for improving Product Card Atlas.

## Development

1. Fork the repository and create a focused branch.
2. Run `flutter pub get`.
3. Keep demo data local and free of customer or production information.
4. Add tests for behavior changes.
5. Run the complete quality suite before opening a pull request:

```bash
dart format --output=none --set-exit-if-changed lib test
bash scripts/check_repository_hygiene.sh
flutter analyze
flutter test
flutter build web --release
```

Pull requests should explain the problem, the chosen approach, and the checks
that were run. Keep unrelated changes in separate pull requests.
