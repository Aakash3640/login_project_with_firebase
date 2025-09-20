# Login Project with Firebase

A Flutter application that implements user authentication using Firebase. Users can register, login, and logout using email/password.  



---

## Features

- User registration with email & password  
- Login / logout functionality  
- Firebase as backend for authentication  
- Basic form validation (email format, password strength, etc.)  
- UI that works on both Android & iOS  

---

## Prerequisites

Before you begin, ensure you have:

- Flutter installed (version stable)  
- Dart SDK  
- An IDE (VSCode, Android Studio, IntelliJ etc.)  
- An emulator or physical device for Android/iOS  
- A Firebase account  

---

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/Aakash3640/login_project_with_firebase.git
   ```


 2. Navigate into the project directory:

     ```bash
     cd login_project_with_firebase
     ```

3. Get the Flutter packages:

   ```bash
   flutter pub get
   ```


---

## Firebase Setup

To get the authentication working locally, you need to set up Firebase:

1. Go to the Firebase Console and create a new project.

2. Add an Android app and/or iOS app to your project.

  - For Android: you’ll need the package name, SHA-1 (optional but recommended)

  - For iOS: you’ll need the bundle identifier

3. Download the google-services.json (Android) or GoogleService-Info.plist (iOS) file(s).

4. Place them in the respective folders in your Flutter project:

  - android/app/ → google-services.json
  - ios/Runner/ → GoogleService-Info.plist

5. In the Firebase console, enable Email/Password authentication (or other auth providers if you choose)


---

## Usage

1. Open the app.

2. If you don’t have an account, go to “Register” / “Sign Up” screen.

3. Enter valid email & password and submit.

4. If successful, you’ll be directed to a home/main screen.

5. To exit / logout, use the logout option in the app.


   
