<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="https://extranet.who.int/goarn/sites/default/files/go.data_.png" alt="Logo"  height="80">
  </a>

  <h3 align="center">Go.Data Guatemala</h3>

  <p align="center">
    Transformación, manipulación y visualización de los datos de la implementación de GoData en Guatemala para el rastreo de casos y contactos COVID-19.
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Tabla de contenidos</summary>
  <ol>
    <li>
      <a href="#sobre-el-proyecto">Sobre el proyecto</a>
      <ul>
        <li><a href="#desarrollado-con">Desarrollado con</a></li>
      </ul>
    </li>
    <li>
      <a href="#antes-de-empezar">Antes de empezar</a>
      <ul>
        <li><a href="#prerequisitos">Prerequisitos</a></li>
        <li><a href="#instalacion">Instalación</a></li>
      </ul>
    </li>
    <li><a href="#uso">Uso</a>
      <ul>
        <li><a href="#script-de-automatización">Script de automatización</a></li>
        <li><a href="#dashboard">Dashboard</a></li>
      </ul>
    </li>
    <li><a href="#contacto">Contacto</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## Sobre el proyecto

[![Product Name Screen Shot][product-screenshot]]()

En Guatemala se realizó un proyecto piloto para el rastreo y seguimiento domiciliar o teléfonico de casos y contactos COVID-19 utilizando [Go.Data](https://www.who.int/godata). Para el seguimiento de contactos se utilizo la sección de seguimiento de contactos de la plataforma. Mientras que para los casos se utilizó la flexibilidad de los cuestionarios para implementar la estrategía de seguimientos.

Para analizar y reportar los resultados del proyecto se generó un tablero a partir de la informacion de los casos y contactos. En este tablero ademas se agrego una sección de informes para reportar los resultados del proyecto. Finalmente se agrego una herramienta que ayuda al personal a asignar los casos a seguir a los distintos reastreadores de manera automática y resume la información necesaria para realizar el mismo.

Automatizar el proceso de obtención, transformación y actualización de datos en el tablero era una necesidad. Por lo que se genero un script con todo el flujo de trabajo necesario para correr el proceso de ETL completo.

### Desarrollado con

* [R](https://www.r-project.org/)
* [ShinyApps](https://www.shinyapps.io/)
* [shinydashboard](https://rstudio.github.io/shinydashboard/)
* [Go.Data](https://www.who.int/godata)



<!-- GETTING STARTED -->
## Antes de empezar

Se debe tener un usuario en Go.Data sin restricciones de acceso para utilizar el script `rastreoConsolidation.R` encargado de todo el proceso de ETL.

### Prerequisitos

* R
  ```sh
  sudo apt-get install r-base
  ```

### Instalación

1. Clonar el repositorio
   ```sh
   git clone https://github.com/Oliversinn/godata-guatemala.git
   ```
2. Instalar los paquetes de R
   ```sh
   cd godata-guatemala
   Rscript scripts/installPackages.R
   ```
3. Conectar con [ShinyApps](https://shiny.rstudio.com/articles/shinyapps.html)
   ```R
   rsconnect::setAccountInfo(name="<ACCOUNT>", token="<TOKEN>", secret="<SECRET>")
   ```

<!-- USAGE EXAMPLES -->
## Uso

### Script de automatización

El unico script que hay que correr es el `rastreoConsolidation.R`. En el hay que configurar lo credenciales y los IDs de los brotes e idiomas que se quieran utilizar de la plataforma Go.Data. Dichos campos están representados con "xxxxxxxx" al clonar este repositorio por seguridad. Al correr este script este descarga las bases de datos y al transformarlas las guarda en `DashboardRastreo/data` para que el tablero las pueda usar.

* Ejecutar el script
   ```sh
   Rscript scripts/rastreoConsolidation.R > logs/rastreoUpdate-$(date +\%F-\%T).log 2>&1
   ```

Las ejecuciones del script generan un log en la carpeta `logs/` para tener registro del proceso de cada ejecución. Asi se ve una corrida exitosa:
[![Log][log]]()

### Tablero

Para ver el funcionamiento del tablero se puede correr abriendolo desde RStudio o se puede correr el siguiente comando agregando la ruta al tablero `DashboardRastreo`

* Correr el tablero
   ```sh
   R -e "shiny::runApp('ruta/a/DashboardRastreo')"
   ```

<!-- CONTACT -->
## Contacto

[Oliver Mazariegos](https://mazariegos.gt/) - olivera@mazariegos.gt

Repo Link: [https://github.com/Oliversinn/godata-guatemala](https://github.com/Oliversinn/godata-guatemala)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[product-screenshot]: assets/dashboard.png
[log]: assets/log.png