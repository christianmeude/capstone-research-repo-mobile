# NUcleus Mobile - Research Repository App

NUcleus is the central hub for academic research and collaboration at National University. This mobile application allows students to browse, submit, and manage their research papers and capstone projects.

## 📱 Features

* **Student Dashboard**: View research stats, analytics, and quick actions.
* **Browse Repository**: Access published papers from the university database.
* **Research Submission**: Submit PDF research papers directly from your device.
* **Secure Authentication**: JWT-based login and registration (Student Role).
* **My Submissions**: Track the status of your submitted papers (Pending, Approved, etc.).
* **Profile Management**: View student details and program information.

## 🛠 Tech Stack

* **Framework**: Flutter (Dart)
* **Architecture**: Feature-First Architecture
* **Backend**: Node.js, Express (See `capstone-nucleus-backend`)
* **Database**: Supabase (PostgreSQL)
* **State Management**: `setState` (Migrating to Provider/Riverpod recommended for scale)

## 🚀 Getting Started

1.  **Clone the repository**
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Configure API**:
    * Open `lib/core/services/api_service.dart`
    * Set `baseUrl` to your backend URL (Use `10.0.2.2:5000` for Android Emulator)
4.  **Run the App**:
    ```bash
    flutter run
    ```

## 👥 Authors

* **Christian Meude** - Lead Developer
* **Malfoy De Vera** - UI/UX Designer

---
*Capstone Project 2026 - BS Information Technology*