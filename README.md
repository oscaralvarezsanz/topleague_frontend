# TopLeague Frontend ⚽

[![Flutter Web Deployment](https://github.com/oscaralvarezsanz/topleague_frontend/actions/workflows/flutter_github_pages.yaml/badge.svg)](https://github.com/oscaralvarezsanz/topleague_frontend/actions/workflows/flutter_github_pages.yaml)

A modern, responsive web application built with [Flutter](https://flutter.dev/) to interact with the [TopLeague REST API](https://github.com/oscaralvarezsanz/topleague). 

This frontend provides a beautiful Dark Mode interface to manage football leagues, teams, players, matches, and player statistics (participations).

## 🤖 Built with Antigravity

This entire application was developed through **AI-assisted pair programming** using the **Antigravity** agent by Google DeepMind. The application architecture, dark theme UI design, and features were generated from conversational prompts and iterations, showcasing the power of agentic AI in rapid software development.

## 🚀 Live Demo

You can try the live web version of the application here:
👉 **[TopLeague Frontend Demo](https://oscaralvarezsanz.github.io/topleague_frontend/)**

## ✨ Features

*   **🏆 Leagues Management**: View and create football leagues in a grid layout.
*   **🛡️ Teams Management**: Browse teams associated with their respective leagues, complete with custom shields and stats.
*   **🏃 Players Roster**: Detailed player cards including positions, jersey numbers, and quick access to individual stats.
*   **📅 Matchdays & Games**: View live match scoreboards with beautiful gradient headers.
*   **📊 Player Participations**: Add and track detailed player performance per game (goals, assists, yellow/red cards, and starter status).
*   **🎨 Premium UI/UX**: Custom dark theme with deep orange accents, gradient backgrounds, and responsive layouts that look great on both desktop and mobile web.

## 🛠️ Technology Stack

*   **Framework**: [Flutter](https://flutter.dev/) (Web)
*   **Language**: Dart
*   **State Management**: `provider`
*   **API Client**: Generated using OpenAPI Generator (`openapi_generator_cli`) from the backend's `api.yaml`.
*   **CI/CD**: GitHub Actions for automated deployment to GitHub Pages.

## 🔗 Backend Connection

This frontend is designed to consume the **TopLeague** backend API. 
To see how the backend is structured or to run it locally, visit the backend repository:
👉 [https://github.com/oscaralvarezsanz/topleague](https://github.com/oscaralvarezsanz/topleague)

## 💻 Local Development

If you want to run this project locally:

1.  Make sure you have [Flutter installed](https://docs.flutter.dev/get-started/install).
2.  Clone this repository:
    ```bash
    git clone https://github.com/oscaralvarezsanz/topleague_frontend.git
    cd topleague_frontend
    ```
3.  Get the dependencies:
    ```bash
    flutter pub get
    ```
4.  Run the app (select Chrome or Edge as the target):
    ```bash
    flutter run -d chrome
    ```
