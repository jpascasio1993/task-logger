# Task Logger

Task logging app that can create, update, delete, view task while offline and sync locally mutated data online through the Task Logger API endpoint once the device is online

## Prerequisites

**IDE**
 - Android Studio Meerkat (2024.3.1) or latest
 - VSCode
 - Cursor

**Flutter**
- 3.29.3 on stable channel

**Dart**
- 3.7.2

**Pre-Built APK**

I have gone ahead building the apk with production secrets. The API url should point to the Task Logger API that I uploaded and hosted in AWS.


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

**How the app works**

The app is designed to function offline and ensures that task management operations remain smooth even without an active internet connection. The app is fully operational offline. Users can create, update, and delete tasks without needing a constant internet connection.

When the app is launched, it retrieves the latest task data from the Task Logger API, ensuring that the user starts with the most up-to-date information available from the server.

If any operation (create, update, delete) fails due to a server error or lack of internet connectivity, the failed operation is added to a sync queue. These operations are marked for later synchronization.

The app attempts to synchronize pending changes at regular intervals (currently every 2 seconds). Before each sync attempt, the app checks for internet connectivity by making a request to the `/health` endpoint on the Task Logger API.

If the connection is confirmed, it retries the queued operations until they succeed.


**Suggestions and Improvements**

I think the app would really benefit from a task search feature. Also, the current design feels a bit bland; updating the UI with more engaging visuals and a cleaner layout could make it much more appealing to use.


**Appreciation**

Using Cursor and its AI features for development has been a breeze. I've been able to leverage its AI capabilities to generate unit tests across multiple modules by following the same pattern I originally created for one—saving me from having to manually copy and paste. On top of that, the AI even suggested additional test scenarios I might have overlooked. I'm really grateful to the community, especially the team behind Cursor and the AI models powering it.


https://github.com/user-attachments/assets/02a465ab-ac50-4376-b962-1083ea557e4e



https://github.com/user-attachments/assets/99c4ae77-013f-4e6e-972d-4123accd2032



