# Red2Green

Red2Green is a community-driven Flutter application for reporting civic cleanliness issues, coordinating NGO-led cleanup events, and enabling volunteer collaboration through realtime event chat.

## Core Features
- Issue reporting with image capture, location, category, and severity.
- Realtime issue watch feed with status filters.
- Map-based event discovery and issue interaction.
- NGO claim and resolution workflow with proof images.
- Event-centric group chat for volunteers and organizers.

## Technology Stack
- Frontend: Flutter + Provider
- Backend services: Firebase Authentication + Cloud Firestore
- Media pipeline: Cloudinary image upload

## Documentation
Production-grade documentation is available under the docs folder:
- [Frontend Architecture and Delivery](docs/FRONTEND_DOCUMENTATION.md)
- [Backend Architecture and Operations](docs/BACKEND_DOCUMENTATION.md)
- [Firestore Schema and Governance](docs/DATABASE_SCHEMA.md)
- [Security and Compliance Baseline](docs/SECURITY_AND_COMPLIANCE.md)
- [Operations Runbook](docs/OPERATIONS_RUNBOOK.md)
- [Deployment and Release Guide](docs/DEPLOYMENT_AND_RELEASE.md)
- [Documentation Index](docs/README.md)

## Getting Started
1. Install Flutter SDK and platform toolchains.
2. Run dependency installation:
	- flutter pub get
3. Configure Firebase for your target platform.
4. Run the app:
	- flutter run

## Notes
- Firebase configuration is loaded from lib/firebase_options.dart.
- Production hardening should include secure media upload signing and strict Firestore security rules.
