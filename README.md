<p align="center">
<h1 align="center">DP-Extras - Sistema de Extras/Livery's para Vehículos (Police/EMS/Mechanic/Sheriff...) (QBCore)</h1>

<img width="960" height="auto" align="center" alt="DP-Animations Logo" src="Images (Can Remove it if u want)/Miniaturas YT.png" />

</p>

<div align="center">

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![FiveM](https://img.shields.io/badge/FiveM-Script-important)](https://fivem.net/)
[![QBCore](https://img.shields.io/badge/QBCore-Framework-success)](<[https://qbcore-framework.github.io/qb-docs/](https://github.com/qbcore-framework)>)

</div>

<h2 align="center"> 📝 Descripción General</h2>
DP-Extras es un sistema avanzado de gestión/personalización de vehículos de trabajo, diseñado para servidores de FiveM que utilizan el framework QBCore. Este script permite a los oficiales de policía o de los jobs indicados, modificar extras, liveries, lavar y reparar sus vehículos en estaciones designadas.

<details>
<summary><h2 align="center">¿Qué es y qué hace?</h2></summary>
- Permite activar/desactivar extras de vehículos policiales.<br>
- Sistema para cambiar liveries y diseños de vehículos.<br>
- Opciones para lavar y reparar vehículos con progress bars.<br>
- Interfaz de menú intuitiva con QB-Menu.<br>
- Soporte para ambos sistemas de texto: DP-TextUI y qb-core.<br>

</details>
<details>
<summary><h2 align="center">¿Cómo funciona?</h2></summary>
- Los jugadores deben estar en un vehículo y tener el job "police" o el indicado/s en el config.lua.<br>
- Se accede al sistema mediante un marcador en la comisaría. (Ubicaciónes editables...)<br>
- Interfaz de menú con opciones para extras, liveries, lavado y reparación.<br>
- Progress bars visuales para todas las acciones.<br>
- Sincronización completa de cambios entre jugadores.<br>

</details>
<details>
<summary><h2 align="center">¿Qué te permite?</h2></summary>
✅ Gestión completa de extras de vehículos (activar/desactivar).<br>
✅ Cambio de liveries y diseños de vehículos.<br>
✅ Lavado y reparación de vehículos con animaciones.<br>
✅ Interfaz de menú moderna con QB-Menu.<br>
✅ Soporte configurable para DP-TextUI o qb-core text.<br>
✅ Tiempos configurables para todas las acciones.<br>
✅ Restricción por jobs/gangs/civil.<br>
✅ Marcador visuales.<br>

</details>
<br><br>
<h2 align="center"> 🚀 Instalación</h2>

<details>
<summary><h2 align="center">Requisitos previos</h2></summary>
- Servidor FiveM con QBCore instalado.<br>
- QB-Menu para la interfaz de menús.<br>
- Opcional: DP-TextUI para texto personalizado.<br>

</details>
<details>
<summary><h2 align="center">Pasos de instalación</h2></summary>
1. **Descargar el script** desde el repositorio oficial.<br>
2. **Colocar la carpeta** en tu servidor con el nombre exacto `DP-Extras`.<br>
   - ⚠️ El nombre debe ser exactamente este para evitar problemas.<br>
3. **Configurar** el archivo config.lua según tus necesidades.<br>

</details>
<br><br>
<h2 align="center"> ⚙️ Dependencias</h2>
El script requiere las siguientes dependencias (deben estar instaladas y configuradas):
<details>
<summary><h2 align="center"> 📦 Requisitos del Sistema</h2></summary>

| Recurso                                                                          | Descripción                   | Enlace                                                    |
| -------------------------------------------------------------------------------- | ----------------------------- | --------------------------------------------------------- |
| <img src="https://placehold.co/20x20/555555/FFFFFF?text=Q" alt="QB"> qb-core     | Framework principal           | [🔗 GitHub](https://github.com/qbcore-framework/qb-core)  |
| <img src="https://placehold.co/20x20/555555/FFFFFF?text=M" alt="Menu"> qb-menu   | Sistema de menús              | [🔗 GitHub](https://github.com/qbcore-framework/qb-menu)  |
| <img src="https://placehold.co/20x20/555555/FFFFFF?text=D" alt="DP"> DP-TextUI   | Texto personalizado (opcional)| [🔗 GitHub]()  |

<div style="margin-top: 15px; background-color: #f8f9fa; padding: 10px; border-radius: 5px; border-left: 4px solid #6c757d;">
<strong> 💡 Nota:</strong> DP-TextUI es opcional. Puedes usar el sistema de texto de qb-core cambiando Config.UseDPTextUI = false
</div>

</details>
<details>
<summary><h2 align="center">Orden recomendado en server.cfg</h2></summary>
```cfg.<br>
   ensure qb-core
   ensure qb-menu
   ensure DP-TextUI # Opcional
   ensure DP-Extras
  
</details>
<div class="alert alert-warning" style="background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 10px; margin: 15px 0; border-radius: 5px;">
 <strong> ⚠️ Nota importante:</strong>
   El script utiliza eventos del servidor para la sincronización de animaciones. Asegúrate de que ningún otro script entre en conflicto con los eventos definidos.
</div>

</details>
<br><br>
<h2 align="center"> 📂 Estructura de Archivos</h2>

<details>
<summary><h2 align="center"> 🖥️ Mostrar estructura completa y descripción</h2></summary>

DP-Extras/<br>
├── 🔵 fxmanifest.lua
├── 🔵 config.lua
├── 🔵 client.lua
└── 📖 README.md

</div>

| Archivo                    | Función Principal                   | Dependencias      |
| -------------------------- | ----------------------------------- | ----------------- |
| **fxmanifest.lua**         | Configuración principal del recurso | qb-core, qb-menu, DP-TextUI |
| **config.lua**             | Configuración completa del script   | - |
| **client.lua**             | Lógica principal del cliente        | qb-core, qb-menu, DP-TextUI (Opcional) |

> ** 💡 Datos Técnicos:** Sistema optimizado con consumo mínimo de recursos (0.00-0.01ms) y máxima compatibilidad con QBCore.

</details>
<br><br>
<h2 align="center">🛠️ Configuración</h2>
El archivo config.lua permite personalizar completamente el script.

<details>
<summary><h2 align="center">⚙️ Mostrar configuración</h2></summary>

<img width="500" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/config.png" />

| Parámetro              | Descripción                                              | Valores                           |
| ---------------------- | -------------------------------------------------------- | --------------------------------- |
| Marker                 | Configuración del marcador visual                        | Tipo, tamaño, color, posición     |
| JobRequired            | Job que puede usar el sistema                            | "police" (configurable)           |
| UseDPTextUI	         | Elegir sistema de texto                                  | true = DP-TextUI, false = qb-core |
| ProgressTimes          | Tiempos de las progress bars                             | Milisegundos para cada acción     |
| Textos personalizables | Todos los textos traducibles y modificables              | Puedes traducirlos a tu gusto     |
| Iconos Font Awesome	 | Sistema de iconos completamente personalizable           | Puedes modificarlos a tu gusto    |
| Colores configurables	 | Paleta de colores editable para marcadores y UI          | Puedes modificarlos a tu gusto    |
| Tiempos ajustables	 | Cada acción tiene su tiempo configurable individualmente | Puedes modificarlos a tu gusto    |


</details>
<br><br>
<h2 align="center"> 🎮 Uso del Sistema</h2>

<details>
<summary><h2 align="center"> Para los que tengan el job</h2></summary>

1. **Ir a la comisaría** - Ubicación: vector3(422.14, -1022.70, 28.57)<br>
2. **Subirse a un vehículo policial**<br>
3. **Acercarse al marcador negro**<br>
4. **Presionar E para abrir el menú**<br>
4. **Seleccionar opción deseada:**<br>
🎨 Livery's: Cambiar diseños del vehículo<br>
⚙️ Extras: Activar/desactivar extras<br>
🧼 Lavar: Limpiar el vehículo<br>
🔧 Reparar: Reparar el vehículo<br>

</details>
<br><br>
<h2 align="center"> 🖼️ Vistas Previas</h2>
Aquí tienes una lista de las vistas previas de tu script.

<details>
<p align="center">
<summary><h2 align="center">Menú Principal</h2></summary>

<img width="959" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/Menú Principal.png" />

</p>
</details>
<details>
<p align="center">
<summary><h2 align="center">Selección de Livery's</h2></summary>

<img width="500" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/Selección de Livery&apos;s.png" />

</p>
</details>
<details>
<p align="center">
<summary><h2 align="center">Selección de Extras</h2></summary>

<img width="500" height="auto" alt="image" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/extras.png" />

</p>
</details>
<details>
<p align="center">
<summary><h2 align="center">Video Demostrativo</h2></summary>

<a href="">
<img width="959" height="auto" alt="Video Demostrativo" style="border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);" src="Images (Can Remove it if u want)/Miniaturas YT.png" />
</a>

</p>
</details>
<br><br>
<h2 align="center"> 🔮 Posibles Mejoras Futuras</h2>
El DP-Extras es un sistema robusto, pero siempre hay espacio para mejoras:

<details>
<summary><h2 align="center">🚧 Ideas en desarrollo</h2></summary>

| IDEA                               | EXPLICACIÓN                                                                                 |
| ---------------------------------- | ------------------------------------------------------------------------------------------- |
| **Múltiples ubicaciones**          | Añadir más estaciones de servicio en diferentes comisarías.                                 |
| **Sistema de permisos**            | Diferentes niveles de acceso según rango policial.                                          |
| **Costes económicos**              | Implementar costes por lavado/reparación usando dinero de sociedad                          |
| **Más vehículos**                  | Extender funcionalidad a otros jobs (mecánicos, EMS, etc.)                                  |
| **Animaciones personalizadas**     | Añadir animaciones durante las acciones de lavado/reparación                                |
| **Sistema de sonidos**             | Efectos de sonido durante las acciones                                                      |
| **Compatibilidad multi-framework** | Soporte para ESX y otros frameworks                                                         |

</details>

Autor: DP-Scripts<br>
Versión: 1.0.0