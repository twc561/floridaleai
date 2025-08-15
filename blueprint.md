# Blueprint

## Overview

This document outlines the plan for developing a new feature for the application. The goal of this document is to provide a clear and concise overview of the project, including its purpose, scope, and features.

## Current Project: Law Enforcement Assistant App

### Purpose and Capabilities

The Law Enforcement Assistant App is a mobile application designed to provide law enforcement officers with quick access to relevant legal information, tools for field operations, and resources for training and reporting.

### Style, Design, and Features

*   **UI/UX:** The app will feature a modern, intuitive interface with a dark theme suitable for use in various lighting conditions. It will use the Material Design 3 component library for a consistent and professional look. The layout will be adaptive, ensuring usability on both phones and tablets.
*   **Core Features:**
    *   **Home Screen:** A dashboard providing quick access to frequently used tools and recent updates.
    *   **Search:** A powerful search function to quickly find statutes, case law, and training materials.
    *   **Statute & Case Law Reference:** A browsable and searchable database of relevant laws and legal precedents.
    *   **Field Sobriety Test (FST) Toolkit:** Step-by-step guides and timers for conducting standardized field sobriety tests (HGN, Walk-and-Turn, One-Leg Stand).
    *   **Crash Scene Helper:** Tools for accident investigation, including a speed calculator and checklists.
    *   **Language Helper:** A translation tool with common phrases for communicating with non-native English speakers.
    *   **Report Assistant:** A feature to help officers write accurate and comprehensive reports, potentially using generative AI to summarize events.
    *   **Field Simulator:** An AI-powered training module that presents officers with realistic scenarios to test their knowledge and decision-making skills.
    *   **AI Search and Seizure Advisor:** An AI-powered tool to provide guidance on search and seizure scenarios, powered by the Gemini API.
    *   **Favorites & Recents:** Allow users to save frequently accessed items and view their history.
*   **Navigation:** The app will use a bottom navigation bar for primary navigation between the main sections (Home, Search, Favorites, More). A nested routing system will handle navigation within each section.

## Current Task: Implement Real AI in Search and Seizure Advisor

### Plan and Steps

1.  **Add Dependencies:** Add `firebase_core` and `firebase_ai` to the `pubspec.yaml` file.
2.  **Initialize Firebase:** Ensure Firebase is initialized in the `main.dart` file.
3.  **Create Gemini Service:** Create a `GeminiService` to handle communication with the Gemini API.
4.  **Connect UI to Service:** Update the `AiSearchAdvisorScreen` to use the `GeminiService` to get real-time advice.
5.  **Update Blueprint:** Update the `blueprint.md` to reflect the new implementation.

### Work Done

*   Added `firebase_core` and `firebase_ai` to `pubspec.yaml`.
*   Ensured Firebase is initialized in `main.dart`.
*   Created the `GeminiService` and connected it to the Gemini API.
*   Updated the `AiSearchAdvisorScreen` to use the `GeminiService` and display markdown responses.
*   Updated the `blueprint.md` file.
