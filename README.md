# NirwanaGrid ⚡
<p align="center">
  <img src="assets/images/logo.png" alt="NirwanaGrid Logo" width="150"/>
</p>

<p align="center">
  A full-stack IoT application for smart home energy management, built with Flutter.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase">
  <img src="https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white" alt="AWS">
  <img src="https://img.shields.io/badge/MQTT-6F0000?style=for-the-badge&logo=mqtt&logoColor=white" alt="MQTT">
</p>

---

## 📖 About The Project

**NirwanaGrid** is a comprehensive IoT solution designed to help users monitor, manage, and optimize their home energy consumption. This application provides a seamless interface to interact with smart devices, offering real-time data analytics and remote control capabilities.

The goal of this project is to empower homeowners with the tools they need to make informed decisions about their energy usage, ultimately helping them save money and reduce their environmental impact.

## ✨ Key Features

* **⚡ Real-Time Monitoring:** Track live energy consumption of connected appliances.
* **📱 Remote Device Control:** Toggle smart devices (lights, ACs, plugs) on or off from anywhere.
* **📊 Consumption Analytics:** View historical data, identify high-usage devices, and spot trends.
* **🤖 AI-Powered Insights:** (Future-proofing for your AI degree!) Receive smart suggestions to optimize energy use.
* **🔒 Secure Authentication:** User accounts and device data secured with Firebase Auth.

## 🛠️ Tech Stack

This project is a full-stack IoT solution utilizing:

* **Frontend (Mobile App):** [Flutter](https://flutter.dev/)
* **Authentication & Database:** [Firebase](https://firebase.google.com/) (Auth & Firestore)
* **IoT Communication:** [MQTT](http://mqtt.org/)
* **Cloud & IoT Backend:** [AWS](https://aws.amazon.com/) (Specifically AWS IoT Core for MQTT broker and data processing)

## 📸 Screenshots

*(This is the most important part! Add your app screenshots here.)*

| Login Screen | Home Dashboard | Device Control |
| :---: | :---: | :---: |
| <img src="URL_TO_YOUR_SCREENSHOT" width="250" alt="Login Screen"> | <img src="URL_TO_YOUR_SCREENSHOT" width="250" alt="Home Dashboard"> | <img src="URL_TO_YOUR_SCREENSHOT" width="250" alt="Device Control"> |

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

* Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
* An IDE like VS Code or Android Studio
* A configured Firebase project
* An AWS account with IoT Core setup

### Installation

1.  **Clone the repo**
    ```sh
    git clone [https://github.com/PiyushKumar-08/Nirwanagrid-Application.git](https://github.com/PiyushKumar-08/Nirwanagrid-Application.git)
    ```
2.  **Navigate to the project directory**
    ```sh
    cd Nirwanagrid-Application
    ```
3.  **Install dependencies**
    ```sh
    flutter pub get
    ```
4.  **Configure Environment**
    * Add your `firebase_options.dart` to `lib/`
    * Add your AWS/MQTT credentials where required.
5.  **Run the app**
    ```sh
    flutter run
    ```

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 👤 Contact

Piyush Kumar - [@PiyushKumar-08](https://github.com/PiyushKumar-08)

Project Link: [https://github.com/PiyushKumar-08/Nirwanagrid-Application](https://github.com/PiyushKumar-08/Nirwanagrid-Application)