# Monorepo CRM Analytics

- frontend/: Vite + React + TypeScript
- backend/: Go + Gin
- ai-service/: Servicio local de IA (Ollama)
- db/: SQL de ejemplo para PostgreSQL
- docker-compose.yml: Orquestación de servicios

## Primeros pasos

1. Levanta la base de datos y servicios:

```sh
docker-compose up --build
```

2. Accede a:
- Frontend: http://localhost:5173
- Backend: http://localhost:8080
- AI Service: http://localhost:8000 (o puerto Ollama)

3. Modifica los servicios según tus necesidades.
