# Task Logger

Task logging app that can create, update, delete, view task while offline and sync locally mutated data online through the Task Logger API endpoint once the device is online

## Prerequisites

**Flutter**
- 3.29.3 on stable channel

**Dart**
- 3.7.2

**Secrets and Keystore**

This project includes `*.secrets`, `*.jks`, `key.properties` in the repository since this is just an exercise.

**Setup your secrets**

Update the contents of `.secrets/local.secrets`, and add the other `*.secrets` file for each of your environment.

**Generate code**

Run the following commands to generate code. If you use `fvm`, just append `fvm` before the `flutter` command.

```sh
# Run this command if appropriate
flutter pub get

# Run this command one time
flutter pub global activate intl_utils

# Run this command to generate localization files. If you use android studio `Flutter Intl` plugin, you can skip this step.
flutter pub global run intl_utils:generate

# Run this command whenever you use `build_runner`
flutter pub run build_runner build --delete-conflicting-outputs

# you can also run the build_runner command via `yarn` or `npm`. See `package.json` 
yarn build-runner:build:conflict

# to watch file changes and automatically re-generate files
yarn build-runner:watch:conflict

# or when you are using npm
npm run build-runner:build:conflict

# to watch file changes and automatically re-generate files
npm run build-runner:watch:conflict
```

**Running the App**

After running the above command, you can now run the app by running the following script.

```sh
# Production
fvm flutter run --dart-define-from-file=.secrets/prod.secrets

#local
fvm flutter run --dart-define-from-file=.secrets/local.secrets
```


**Test and Test Coverage**

The project uses mockito for testing and test_cov_console for test coverage.
To execute flutter test and test coverage, just run the following command.
Note: omit `fvm` from the command if you do not use flutter version manager

```sh
  fvm flutter test --coverage && fvm flutter pub run test_cov_console
```

if you have npm or yarn installed,

```sh
   npm run test:coverage
   
   # via yarn
   yarn test:coverage
```

**Git Hooks**

For the git hooks, the project uses husky to run linting and formatting checks before committing. see `.husky/pre-commit`.
If you use `fvm`, just append `fvm` before the `dart` command as you can see in the `pre-commit` script.

From this,
```sh
 dart run lint_staged
```

to

```sh
 fvm dart run lint_staged
```