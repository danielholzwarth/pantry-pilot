.PHONY:backend

backend:
	cd backend/cmd/backend && SET JWT_KEY=secret && go run .


.PHONY:app

app:
	cd app && flutter run --debug lib/main.dart