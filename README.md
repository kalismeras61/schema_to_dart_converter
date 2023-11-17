# AppSync, Firebase Dart Class Converter

A command-line application that converts an AppSync schema into Dart classes, facilitating the integration of AppSync data with Dart or Flutter applications.

## Features

- **AppSync to Dart Conversion**: Converts AppSync schema files into Dart class files.
- **Firebase Schema Support**: Additionally supports the conversion of Firebase-compatible Dart classes.

## Requirements

- **Dart SDK**: Required for running Dart scripts. [Install Dart SDK](https://dart.dev/get-dart).
- **Node.js and npm**: Necessary for Firebase conversion. [Download Node.js](https://nodejs.org/).

## Installation

Clone the repository to your local machine:

```bash
git clone [https://github.com/kalismeras61/schema_to_dart_converter](https://github.com/kalismeras61/schema_to_dart_converter)
cd appsync-to-dart
```

## Usage

### Standard AppSync Schema Conversion

#### Step 1: Export Your Data

On the Appsync console, navigate to your Api and select api, then to the Schema tab export your schema`schema.json` in the `lib/input` folder of your project.

To convert an AppSync schema to Dart classes:

```bash
dart run bin/main.dart --g class
```

This command reads the AppSync schema file and generates Dart classes in the specified output directory.

### Firebase Schema Conversion

#### Step 1: Export Your Data

On the Firebase console, navigate to your project settings, then to the Service account tab. Generate a new private key and save it as `exportedDB.json` in the `lib/input` folder of your project.

#### Step 2: Run Conversion Command

To convert Firebase-compatible Dart classes:

```bash
dart run bin/main.dart --g class --firebase
```

This command automatically generates `firebase.json` from Firestore data and then converts it into Dart classes.

## Output

The generated Dart classes will be stored in the designated output directory. For Firebase schema conversion, you can find your Firebase data models within these individual class files.

## Contributing

Contributions to the AppSync Dart Class Converter are welcome. Please read our contributing guidelines and submit pull requests to our repository.
