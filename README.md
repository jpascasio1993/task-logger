# task_logger

Task Logging System

## Prerequisites

**Flutter**
- 3.29.0 on stable channel

**Dart**
- 3.7.0

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