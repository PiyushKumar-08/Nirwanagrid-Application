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

| Login Page | Home Dashboard |
| :---: | :---: |
| <img src="https://private-user-images.githubusercontent.com/113303813/515321267-3494a6a9-7191-4b73-9f4a-025a35b912cb.jpg?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjM0MDI0MzIsIm5iZiI6MTc2MzQwMjEzMiwicGF0aCI6Ii8xMTMzMDM4MTMvNTE1MzIxMjY3LTM0OTRhNmE5LTcxOTEtNGI3My05ZjRhLTAyNWEzNWI5MTJjYi5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUxMTE3JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MTExN1QxNzU1MzJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT01ZjI5YjE3ZDk4MGY2YThhNGNlODY4YjliOTY0YWU2NDYxYzE5NDMyNzMzODU0NTcxZTAwMmU1ODVjNDE4ODFmJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.Xx0B-SWyhgjsMgQz5Og7NR_kF8I6PbjWDoRqiq9YCxs" width="250" alt="Login Screen"> | <img src="https://private-user-images.githubusercontent.com/113303813/515321268-c1bd234d-422b-4349-bbc5-aac25b78f3d5.jpg?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjM0MDI0MzIsIm5iZiI6MTc2MzQwMjEzMiwicGF0aCI6Ii8xMTMzMDM4MTMvNTE1MzIxMjY4LWMxYmQyMzRkLTQyMmItNDM0OS1iYmM1LWFhYzI1Yjc4ZjNkNS5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUxMTE3JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MTExN1QxNzU1MzJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT1mMTliMjQ5Nzk4ZTI1MDEzOWU5NTZjMjYwNDI1MzE3MjBiODY3ZjU3NTY3MzI3YTY3N2Y4ZGMyNzlhMTczZjMyJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.UoXBn527ZDkLF6TVxP_78-P7NEk8Vt68gPGQ19P1Mmg" width="250" alt="Home Dashboard"> |

| Settings Page | Chatbot |
| :---: | :---: |
| <img src="https://private-user-images.githubusercontent.com/113303813/515321270-2aacd31a-1a1a-4cbe-8aad-cc23a5dec356.jpg?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjM0MDI0MzIsIm5iZiI6MTc2MzQwMjEzMiwicGF0aCI6Ii8xMTMzMDM4MTMvNTE1MzIxMjcwLTJhYWNkMzFhLTFhMWEtNGNiZS04YWFkLWNjMjNhNWRlYzM1Ni5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUxMTE3JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MTExN1QxNzU1MzJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT05NDZmYjgzNzA4ZWY5MGFiZmIxMjQ3MDFiOTc3ZTc0ODE1YTI3NDZjYjg4MzUyNzJkNDEyODkzYjliMmVjODBlJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.N1qRS_sPQBRHO24Pfmtb1iRI8-qELwiKL55E99KD_M4" width="250" alt="Settings Page"> | <img src="https://private-user-images.githubusercontent.com/113303813/515321269-0194db72-9cad-47f4-b3d2-81959fd86e92.jpg?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjM0MDI0MzIsIm5iZiI6MTc2MzQwMjEzMiwicGF0aCI6Ii8xMTMzMDM4MTMvNTE1MzIxMjY5LTAxOTRkYjcyLTljYWQtNDdmNC1iM2QyLTgxOTU5ZmQ4NmU5Mi5qcGc_WC1BbXotQWxnb3JpdGhtPUFXUzQtSE1BQy1TSEEyNTYmWC1BbXotQ3JlZGVudGlhbD1BS0lBVkNPRFlMU0E1M1BRSzRaQSUyRjIwMjUxMTE3JTJGdXMtZWFzdC0xJTJGczMlMkZhd3M0X3JlcXVlc3QmWC1BbXotRGF0ZT0yMDI1MTExN1QxNzU1MzJaJlgtQW16LUV4cGlyZXM9MzAwJlgtQW16LVNpZ25hdHVyZT00ZjRjOWNkMmYwNzdmYTQwMzdmZjVjZGRhYjIzMTc2ZTgxOGMzOTMwNmEzNGEyZjA0NTA5YTMwYjliNWIyMmIzJlgtQW16LVNpZ25lZEhlYWRlcnM9aG9zdCJ9.0WvOOkMYGXLzVY3H2TE21ZarF6ygXYMu9n9BA49TQhw" width="250" alt="Chatbot"> |


## 👤 Contact

Piyush Kumar - [@PiyushKumar-08](https://github.com/PiyushKumar-08)

Project Link: [https://github.com/PiyushKumar-08/Nirwanagrid-Application](https://github.com/PiyushKumar-08/Nirwanagrid-Application)