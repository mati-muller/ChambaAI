# ChambaAI

## Descripción
ChambaAI es una plataforma que integra generación automática de código backend (Go + Gin) y frontend (React), usando modelos LLM (Ollama) y un flujo automatizado para escribir y actualizar archivos de código en el proyecto. El sistema está compuesto por varios servicios dockerizados y permite extender endpoints de manera dinámica.

## Estructura del Proyecto
- `backend/`: Código Go (handlers, main, lógica de negocio)
- `frontend/`: Aplicación React
- `ai-service/`: Proxy Node.js para interactuar con Ollama y filtrar respuestas
- `db/`: Scripts de inicialización de base de datos
- `docker-compose.yml`: Orquestación de servicios
- `generate_llamadas.json`: Prompt y configuración para generación automática de endpoints

## Requisitos
- Docker y Docker Compose
- Go (para desarrollo local backend)
- Node.js y npm (para desarrollo local frontend)

## Instalación y Puesta en Marcha

1. **Clona el repositorio**

```sh
git clone <repo-url>
cd ChambaAI
```

2. **Configura variables de entorno**

Crea un archivo `.env` en la raíz o exporta las siguientes variables según tu entorno:
- `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` (para backend)

3. **Levanta los servicios con Docker Compose**

```sh
docker-compose up --build -d
```
Esto inicia:
- Backend Go (servidor API)
- Frontend React (Vite)
- ai-service (proxy para Ollama)
- Base de datos (Postgres)

4. **Verifica el estado de los servicios**

- Backend: http://localhost:8080/health
- Frontend: http://localhost:5173/
- Ollama: http://localhost:11434/

## Funcionalidades Principales

### 1. Generación Automática de Endpoints
- Modifica `generate_llamadas.json` para definir el prompt y archivo destino.
- Llama al endpoint de generación:

```sh
curl -X POST http://localhost:8000/api/generate \
  -H 'Content-Type: application/json' \
  -d @generate_llamadas.json
```
- El código generado se inserta como bloque adicional en el archivo destino, siguiendo la estructura y convenciones del proyecto, sin sobrescribir código existente.

### 2. Guardado de Código desde Frontend
- Endpoint backend: `POST /save-code`
- Permite guardar código en archivos bajo `frontend/src/` o `backend/` de forma segura.

### 3. Proxy de generación (ai-service)
- Filtra la respuesta de Ollama para guardar solo el bloque de código Go limpio, sin metadatos ni comentarios.
- Permite integración con cualquier modelo LLM compatible con Ollama.

### 4. Backend Go + Gin
- Handlers y endpoints RESTful para recursos como llamadas y clientes.
- Validaciones de rutas y payloads.
- Ejemplo de endpoint generado:

```go
r.POST("/save-code", func(c *gin.Context) {
    type Req struct {
        FilePath string `json:"filePath"`
        Code     string `json:"code"`
    }
    var req Req
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(400, gin.H{"error": "invalid request"})
        return
    }
    if req.FilePath == "" || req.Code == "" {
        c.JSON(400, gin.H{"error": "filePath and code required"})
        return
    }
    if !(len(req.FilePath) > 0 && (req.FilePath[:12] == "frontend/src" || req.FilePath[:7] == "backend")) {
        c.JSON(400, gin.H{"error": "invalid file path"})
        return
    }
    err := os.WriteFile(req.FilePath, []byte(req.Code), 0644)
    if err != nil {
        c.JSON(500, gin.H{"error": err.Error()})
        return
    }
    c.JSON(200, gin.H{"status": "ok"})
})
```

### 5. Frontend React
- Código fuente en `frontend/src/`
- Puede consumir los endpoints generados dinámicamente

## Notas y Consejos
- El prompt en `generate_llamadas.json` está optimizado para que Ollama genere solo bloques de código listos para pegar, sin sobrescribir el código existente.
- Si cambias la estructura de los handlers, ajusta el prompt para mantener coherencia.
- Puedes extender la lógica de generación para otros lenguajes/componentes ajustando el prompt y el filtrado en `ai-service/server.js`.

## Troubleshooting
- Si el código generado sobrescribe el archivo completo, revisa el prompt y la lógica de filtrado en `ai-service/server.js`.
- Si ai-service no puede conectarse a Ollama, asegúrate de que Ollama esté corriendo en `localhost:11434` y que el volumen `./backend` esté correctamente montado.

## Licencia
MIT
