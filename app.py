notepad app/app.py
Se abrirá una nueva ventana en blanco del Bloc de notas.

Copia literalmente todo este código de la aplicación web:

Python
from flask import Flask, render_template_string

app = Flask(__name__)

@app.route('/')
def home():
    html_layout = """
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Proyecto Final - Servicio Telematico</title>
        <style>
            body { font-family: 'Arial', sans-serif; background-color: #0f172a; color: #f8fafc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
            .card { background-color: #1e293b; padding: 40px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.3); text-align: center; max-width: 450px; }
            h1 { color: #38bdf8; font-size: 24px; margin-bottom: 10px; }
            p { color: #94a3b8; font-size: 16px; line-height: 1.5; }
            .badge { display: inline-block; background-color: #10b981; color: white; padding: 6px 16px; border-radius: 20px; font-weight: bold; margin-top: 15px; font-size: 14px; }
        </style>
    </head>
    <body>
        <div class="card">
            <h1>🚀 Servicio Telemático de Producción</h1>
            <p>Infraestructura deployed automáticamente con Terraform y orquestada de forma persistente mediante Docker Compose en AWS.</p>
            <div class="badge">Estado: Totalmente Funcional</div>
        </div>
    </body>
    </html>
    """
    return render_template_string(html_layout)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)