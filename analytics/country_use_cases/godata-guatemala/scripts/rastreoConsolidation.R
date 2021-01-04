###################################################################################################
url <- "https://godata.com/api/"                   # <--------------------- insert instance url here, don't forget the slash at end !
username <- "xxxxxxxx"                           # <--------------------- insert your username for signing into Go.Data webapp here
password <- "xxxxxxxx"                           # <--------------------- insert your password for signing into Go.Data webapp here
outbreak_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx"   # <--------------------- insert your outbreak ID here
language_id = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx'   # <--------------------- insert your language ID here
###################################################################################################

setwd("~/Documents/MSPAS")

# packages for this script
packages = c("httr","xml2","readr","data.table","dplyr","jsonlite","magrittr","sqldf",'tidyr','rsconnect')

# check if packages are installed
package.check = lapply(
  packages,
  FUN = function(x) {
    if (! suppressMessages(require(x,character.only = TRUE))) {
      install.packages(x, dependencies = TRUE)
      suppressMessages(library(x, character.only = TRUE))
    }
  }
)

httr::set_config(config(ssl_verifypeer = FALSE))
options(dplyr.summarise.inform = FALSE)
options(warn=-1)

# Login para generar el token de autentificación
loginURL = paste(url,'users/login', sep = '')
## Credentials
loginBody = list(
  email = username,
  password = password
)
write('Haciendo login...',stdout())
## Post
login = POST(loginURL, body = loginBody, encode = 'json')
## token
token = content(login)$id
userID = content(login)$userId
write('Login Exitoso!',stdout())
# Activating outbreaks
## Seting user URL
activateURL = paste(url,
                    'users/',
                    userID,
                    sep=""
)
## Set outbreak ID and language ID
activeBody = list(
  activeOutbreakId = outbreak_id,
  languageId = language_id
)  
write('Activando brote de rastreo...', stdout())
##  activate outbreak of cases to download and language
activeOutbreak = PATCH(activateURL,body = activeBody, add_headers(Authorization =token) ,encode = 'json')
write('Brote activado!',stdout())

# Downloading outbreak cases
## Setting months to download
meses = seq(from=as.Date("2020-08-12"), to=Sys.Date(), by='month')
meses_inicio = seq(from=as.Date("2020-08-01"), to=Sys.Date(), by='month')
meses_final = seq(as.Date('2020-09-01'), by='month', length = length(meses))-1
meses_inicio[1] = as.Date("2020-08-12")
meses_final[length(meses)] = Sys.Date()
meses_inicio = format(meses_inicio, '%Y-%m-%dT00:00:00.000Z')
meses_inicio = gsub(":","%3A",meses_inicio)
meses_final = format(meses_final, '%Y-%m-%dT23:59:59.999Z')
meses_final = gsub(":","%3A",meses_final)

## Set URL of outbreak cases using question variable names
caseURL = paste(url,
                'outbreaks/',
                outbreak_id,
                '/cases/export?filter=%7B%22where%22%3A%7B%22and%22%3A%5B%7B%22createdAt%22%3A%7B%22between%22%3A%5B%22',
                meses_inicio[1],'%22,%22',meses_final[1],
                '%22%5D%7D%7D%5D,%22useQuestionVariable%22%3A%20true%7D%7D',
                '&type=csv&access_token=',
                token,
                sep="")


## Download outbreak cases
write(paste0('Descargando casos creados desde el ',format(as.Date(meses_inicio[1]),'%d-%m-%Y'),' al ',format(as.Date(meses_final[1]),'%d-%m-%Y'),'...'),stdout())
outbreakCases = GET(caseURL)
cases = data.table(suppressMessages(content(outbreakCases, guess_max = 50000)))

# Base data transformation
cases_clean = cases %>%
  select(`Date of reporting` = `Fecha de notificación`, 
         Sexo, 
         `Años Años De Edad` = `Edad Años De Edad`, 
         Clasificación,  
         `Fue Un Contacto` = `Era un contacto`, 
         `Fecha De Convertirse En Caso` = `Fecha de convertirse en caso`,
         Tipo, 
         Ocupación, 
         `Condición del Paciente`,
         `Fecha de condición`, 
         `Direcciones Ubicación [1]`,
         `Direcciones Ubicación [1] Localización Geográfica De Nivel [3]` = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [3]`, 
         dms = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [5]`, 
         area_salud = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [3]`,
         `Direcciones Número De Teléfono [1]`,
         `Direcciones Comunidad, aldea o zona [1]`, 
         `Creado En`, 
         `Estado de seguimiento` = estado_de_seguimiento_1,
         `Resultado de la muestra.` = FE12103resultado_de_la_muestra, 
         `¿Se tomó una muestra respiratoria?` = FE121se_tomo_una_muestra_respiratoria,
         `Clínicas Temporales`=clinicas_temporales,
         `Carné De Identidad` = ID, 
         hospitalizado = FE130la_persona_fue_hospitalizada) %>%
  mutate(Sexo = toupper(Sexo),
         Sexo = ifelse(is.na(Sexo),"SIN DATOS",Sexo),
         Sexo = ifelse(Sexo == "MASCULILNO", "MASCULINO",Sexo),
         Sexo = ifelse(Sexo == "MSCULINO", "MASCULINO",Sexo),
         Sexo = ifelse(Sexo == "MASCULINIO", "MASCULINO",Sexo),
         Sexo = ifelse(Sexo == "MASCULLINO", "MASCULINO",Sexo),
         Sexo = ifelse(Sexo == "M", "MASCULINO",Sexo),
         Sexo = ifelse(Sexo == "F", "FEMENINO",Sexo),
         Sexo= factor(Sexo,levels=c("MASCULINO", "FEMENINO", "SIN DATOS")),
         grupo_etario = case_when(`Años Años De Edad` < 10 ~ "0-9 años",
                                  `Años Años De Edad` >= 10 & `Años Años De Edad` < 20 ~ "10-19 años",
                                  `Años Años De Edad` >= 20 & `Años Años De Edad` < 30 ~ "20-29 años",
                                  `Años Años De Edad` >= 30 & `Años Años De Edad` < 40 ~ "30-39 años",
                                  `Años Años De Edad` >= 40 & `Años Años De Edad` < 50 ~ "40-49 años",
                                  `Años Años De Edad` >= 50 & `Años Años De Edad` < 60 ~ "50-59 años",
                                  `Años Años De Edad` >= 60 & `Años Años De Edad` < 70 ~ "60-69 años",
                                  `Años Años De Edad` >= 70 & `Años Años De Edad` < 80 ~ "70-79 años",
                                  `Años Años De Edad` >= 80 ~ "80+ años",
                                  is.na(`Años Años De Edad`) ~"SIN DATOS"),
         grupo_etario = factor(grupo_etario,
                               levels = c("0-9 años","10-19 años","20-29 años","30-39 años",
                                          "40-49 años","50-59 años","60-69 años","70-79 años",
                                          "80+ años","SIN DATOS")),
         `Date of reporting` = as.Date(`Date of reporting`),
         `Fecha De Convertirse En Caso` = as.Date(`Fecha De Convertirse En Caso`),
         `Fecha de condición` = as.Date(`Fecha de condición`),
         `Direcciones Número De Teléfono [1]` = ifelse(is.na(`Direcciones Número De Teléfono [1]`),'NO CONTACTABLE','CONTACTABLE'),
         area_salud = case_when(area_salud == "DAS Alta Verapáz" ~ "DAS Alta Verapaz",
                           area_salud %like% 'DAS' ~ area_salud,
                           area_salud %like% 'SIN DATO' ~ area_salud,
                           T ~ 'SIN DATO'),
         area_salud = toupper(area_salud),
         dms = case_when(dms %like% 'DMS' ~ dms,
                    T ~ "SIN DATO"),
         dms = toupper(dms),
         Clasificación = toupper(Clasificación),
         `Creado En` = as.Date(`Creado En`),
         `Estado de seguimiento` = case_when(`Estado de seguimiento` == 1 ~ "Activo",
                                             `Estado de seguimiento` == 2 ~ "Recuperado",
                                             `Estado de seguimiento` == 3 ~ "Imposible de contactar",
                                             `Estado de seguimiento` == 4 ~ "Perdido",
                                             `Estado de seguimiento` == 5 ~ case_when(Clasificación == "PROBABLE" ~ 'Fallecido',
                                                                                      hospitalizado == 1 ~ 'Hospitalizado',
                                                                                      T ~ "Hospitalizados/Fallecidos"),
                                             `Estado de seguimiento` == 6 ~ "Concluído por otra razón",
                                             is.na(`Estado de seguimiento`) ~ "Sin estado de seguimiento"),
         `Estado de seguimiento` = factor(`Estado de seguimiento`, levels = c("Activo","Recuperado","Imposible de contactar",
                                                                              'Perdido',"Fallecido", "Hospitalizado", "Hospitalizados/Fallecidos","Concluído por otra razón",
                                                                              "Sin estado de seguimiento")),
         `Clínicas Temporales` = case_when(`Clínicas Temporales` == 1 ~ "CBR ZONA 7",
                                           `Clínicas Temporales` == 5 ~ "CBR ZONA 6",
                                           `Clínicas Temporales` == 4 ~ "CBR ZONA 12",
                                           `Clínicas Temporales` == 2 ~ "CBR ZONA 18")) %>%
  rename(`Fecha de notificación` = `Date of reporting`,
         Edad = `Años Años De Edad`,
         Teléfono = `Direcciones Número De Teléfono [1]`,
         Condicion = `Condición del Paciente`,
         zona = `Direcciones Comunidad, aldea o zona [1]`) 

reportCases = cases %>%
  select(
    `Carné De Identidad` = ID,
    `Creado En`,
    Clasificación,
    edad = `Edad Años De Edad`,
    `Teléfono` = `Direcciones Número De Teléfono [1]`,
    `Estado De Embarazo`,
    fecha_es,
    `Estado de seguimiento` = estado_de_seguimiento_1,
    starts_with('seguimiento_'),
    starts_with('fecha_s'),
    starts_with('por_que_'),
    presenta_sintomas_s1 = presenta_sintomas,
    presenta_sintomas_s2 = ha_presentado_sintomas_s2,
    starts_with('presenta_sintomas_s'),
    contains('enfermedades_asociadas'),
    otra_enfermedad = FE11301especifique,
    hospitalizado = FE130la_persona_fue_hospitalizada
  ) %>%
  unite('comorbilidades', c(contains('enfermedades_asociadas'),otra_enfermedad),sep = ', ',na.rm = T) %>%
  mutate(
    fecha_s1 = case_when(is.na(fecha_s1_s) ~ as.Date(fecha_s1_n), T ~ as.Date(fecha_s1_s)),
    fecha_s2 = case_when(is.na(fecha_s2_s) ~ as.Date(fecha_s2_n), T ~ as.Date(fecha_s2_s)),
    fecha_s3 = case_when(is.na(fecha_s3_s) ~ as.Date(fecha_s3_n), T ~ as.Date(fecha_s3_s)),
    fecha_s4 = case_when(is.na(fecha_s4_s) ~ as.Date(fecha_s4_n), T ~ as.Date(fecha_s4_s)),
    fecha_s5 = case_when(is.na(fecha_s5_s) ~ as.Date(fecha_s5_n), T ~ as.Date(fecha_s5_s)),
    fecha_s6 = case_when(is.na(fecha_s6_s) ~ as.Date(fecha_s6_n), T ~ as.Date(fecha_s6_s)),
    fecha_s7 = case_when(is.na(fecha_s7_s) ~ as.Date(fecha_s7_n), T ~ as.Date(fecha_s7_s)),
    fecha_s8 = case_when(is.na(fecha_s8_s) ~ as.Date(fecha_s8_n), T ~ as.Date(fecha_s8_s)),
    fecha_s9 = case_when(is.na(fecha_s9_s) ~ as.Date(fecha_s9_n), T ~ as.Date(fecha_s9_s)),
    fecha_s10 = case_when(is.na(fecha_s10_s) ~ as.Date(fecha_s10_n), T ~ as.Date(fecha_s10_s)),
    fecha_s11 = case_when(is.na(fecha_s11_s) ~ as.Date(fecha_s11_n), T ~ as.Date(fecha_s11_s)),
    fecha_s12 = case_when(is.na(fecha_s12_s) ~ as.Date(fecha_s12_n), T ~ as.Date(fecha_s12_s)),
    fecha_s13 = case_when(is.na(fecha_s13_s) ~ as.Date(fecha_s13_n), T ~ as.Date(fecha_s13_s)),
    fecha_s14 = case_when(is.na(fecha_s14_s) ~ as.Date(fecha_s14_n), T ~ as.Date(fecha_s14_s)),
    maxDate = apply(across(starts_with('fecha_s')),1,max, na.rm = T),
    comorbilidades = gsub('14', 'Otro', comorbilidades),
    comorbilidades = gsub('11', 'Obesidad', comorbilidades),
    comorbilidades = gsub('10', 'Disfuón Neuromuscular', comorbilidades),
    comorbilidades = gsub('9', 'Cardiopatía Crónica (hipertensión arterial)', comorbilidades),
    comorbilidades = gsub('8', 'Enfermedad Hepática Crónica', comorbilidades),
    comorbilidades = gsub('7', 'Tratamiento Con Corticosteroides', comorbilidades),
    comorbilidades = gsub('6', 'Inmunosupresión', comorbilidades),
    comorbilidades = gsub('5', 'Asma', comorbilidades),
    comorbilidades = gsub('4', 'Cáncer', comorbilidades),
    comorbilidades = gsub('3', 'Insuficiencia Renal Crónica', comorbilidades),
    comorbilidades = gsub('2', 'Enfermedad Pulmonar Obstructiva Crónica', comorbilidades),
    comorbilidades = gsub('1', 'Diabetes Mellitus', comorbilidades),
    `Teléfono` = ifelse(is.na(`Teléfono`),'NO CONTACTABLE','CONTACTABLE'),
    `Creado En` = as.Date(`Creado En`),
    Clasificación = toupper(Clasificación),
    `Estado de seguimiento` = case_when(`Estado de seguimiento` == 1 ~ "Activo",
                                        `Estado de seguimiento` == 2 ~ "Recuperado",
                                        `Estado de seguimiento` == 3 ~ "Imposible de contactar",
                                        `Estado de seguimiento` == 4 ~ "Perdido",
                                        `Estado de seguimiento` == 5 ~ case_when(Clasificación == "PROBABLE" ~ 'Fallecido',
                                                                                 hospitalizado == 1 ~ 'Hospitalizado',
                                                                                 T ~ "Hospitalizados/Fallecidos"),
                                        `Estado de seguimiento` == 6 ~ "Concluído por otra razón",
                                        is.na(`Estado de seguimiento`) ~ "Sin estado de seguimiento"),
    `Estado de seguimiento` = factor(`Estado de seguimiento`, levels = c("Activo","Recuperado","Imposible de contactar",
                                                                         'Perdido',"Fallecido", "Hospitalizado", "Hospitalizados/Fallecidos","Concluído por otra razón",
                                                                         "Sin estado de seguimiento"))
  ) %>%
  select(!ends_with('_s')) %>%
  select(!ends_with('_n')) %>%
  filter(
    Clasificación != 'NO ES UN CASO (DESCARTADO)',
    Clasificación != 'SOSPECHOSO E'
  )

reportCases = reportCases %>%
  gather(ultimoSeguimiento, val, starts_with('seguimiento_')) %>%
  filter(!is.na(val)) %>%
  group_by(`Carné De Identidad`) %>%
  summarise(ultimoSeguimiento = last(val)) %>%
  left_join(reportCases, ., by = 'Carné De Identidad')

reportCases = reportCases %>%
  gather(ultimoPorque, val, starts_with('por_que_')) %>%
  filter(!is.na(val)) %>%
  group_by(`Carné De Identidad`) %>%
  summarise(ultimoPorque = last(val)) %>%
  left_join(reportCases, ., by = 'Carné De Identidad')

reportCases = reportCases %>%
  gather(ultimoSintoma, val, starts_with('presenta_sintomas_s')) %>%
  filter(!is.na(val)) %>%
  group_by(`Carné De Identidad`) %>%
  summarise(ultimoSintoma = last(val)) %>%
  left_join(reportCases, ., by = 'Carné De Identidad')

write('Casos descargados!',stdout())

# Data transformation for all months
for (i in c(2:length(meses))) {
  mesi = meses_inicio[i]
  mesf = meses_final[i]
  caseURL = paste(url,
                  'outbreaks/',
                  outbreak_id,
                  '/cases/export?filter=%7B%22where%22%3A%7B%22and%22%3A%5B%7B%22createdAt%22%3A%7B%22between%22%3A%5B%22',
                  mesi,'%22,%22',mesf,
                  '%22%5D%7D%7D%5D,%22useQuestionVariable%22%3A%20true%7D%7D',
                  '&type=csv&access_token=',
                  token,
                  sep="")
  write(paste0('Descargando casos creados desde el ',format(as.Date(mesi),'%d-%m-%Y'),' al ',format(as.Date(mesf),'%d-%m-%Y'),'...'),stdout())
  
  
  outbreakCases = GET(caseURL)
  cases = data.table(suppressMessages(content(outbreakCases, guess_max = 50000)))
  
  cases_clean2 = cases %>%
    select(`Date of reporting` = `Fecha de notificación`, 
           Sexo, 
           `Años Años De Edad` = `Edad Años De Edad`, 
           Clasificación,  
           `Fue Un Contacto` = `Era un contacto`, 
           `Fecha De Convertirse En Caso` = `Fecha de convertirse en caso`,
           Tipo, 
           Ocupación, 
           `Condición del Paciente`,
           `Fecha de condición`, 
           `Direcciones Ubicación [1]`,
           `Direcciones Ubicación [1] Localización Geográfica De Nivel [3]` = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [3]`, 
           dms = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [5]`, 
           area_salud = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [3]`,
           `Direcciones Número De Teléfono [1]`,
           `Direcciones Comunidad, aldea o zona [1]`, 
           `Creado En`, 
           `Estado de seguimiento` = estado_de_seguimiento_1,
           `Resultado de la muestra.` = FE12103resultado_de_la_muestra, 
           `¿Se tomó una muestra respiratoria?` = FE121se_tomo_una_muestra_respiratoria,
           `Clínicas Temporales`=clinicas_temporales,
           `Carné De Identidad` = ID, 
           hospitalizado = FE130la_persona_fue_hospitalizada) %>%
    mutate(Sexo = toupper(Sexo),
           Sexo = ifelse(is.na(Sexo),"SIN DATOS",Sexo),
           Sexo = ifelse(Sexo == "MASCULILNO", "MASCULINO",Sexo),
           Sexo = ifelse(Sexo == "MSCULINO", "MASCULINO",Sexo),
           Sexo = ifelse(Sexo == "MASCULINIO", "MASCULINO",Sexo),
           Sexo = ifelse(Sexo == "MASCULLINO", "MASCULINO",Sexo),
           Sexo = ifelse(Sexo == "M", "MASCULINO",Sexo),
           Sexo = ifelse(Sexo == "F", "FEMENINO",Sexo),
           Sexo= factor(Sexo,levels=c("MASCULINO", "FEMENINO", "SIN DATOS")),
           grupo_etario = case_when(`Años Años De Edad` < 10 ~ "0-9 años",
                                    `Años Años De Edad` >= 10 & `Años Años De Edad` < 20 ~ "10-19 años",
                                    `Años Años De Edad` >= 20 & `Años Años De Edad` < 30 ~ "20-29 años",
                                    `Años Años De Edad` >= 30 & `Años Años De Edad` < 40 ~ "30-39 años",
                                    `Años Años De Edad` >= 40 & `Años Años De Edad` < 50 ~ "40-49 años",
                                    `Años Años De Edad` >= 50 & `Años Años De Edad` < 60 ~ "50-59 años",
                                    `Años Años De Edad` >= 60 & `Años Años De Edad` < 70 ~ "60-69 años",
                                    `Años Años De Edad` >= 70 & `Años Años De Edad` < 80 ~ "70-79 años",
                                    `Años Años De Edad` >= 80 ~ "80+ años",
                                    is.na(`Años Años De Edad`) ~"SIN DATOS"),
           grupo_etario = factor(grupo_etario,
                                 levels = c("0-9 años","10-19 años","20-29 años","30-39 años",
                                            "40-49 años","50-59 años","60-69 años","70-79 años",
                                            "80+ años","SIN DATOS")),
           `Date of reporting` = as.Date(`Date of reporting`),
           `Fecha De Convertirse En Caso` = as.Date(`Fecha De Convertirse En Caso`),
           `Fecha de condición` = as.Date(`Fecha de condición`),
           `Direcciones Número De Teléfono [1]` = ifelse(is.na(`Direcciones Número De Teléfono [1]`),'NO CONTACTABLE','CONTACTABLE'),
           area_salud = case_when(area_salud == "DAS Alta Verapáz" ~ "DAS Alta Verapaz",
                                  area_salud %like% 'DAS' ~ area_salud,
                                  area_salud %like% 'SIN DATO' ~ area_salud,
                                  T ~ 'SIN DATO'),
           area_salud = toupper(area_salud),
           dms = case_when(dms %like% 'DMS' ~ dms,
                           T ~ "SIN DATO"),
           dms = toupper(dms),
           Clasificación = toupper(Clasificación),
           `Creado En` = as.Date(`Creado En`),
           `Estado de seguimiento` = case_when(`Estado de seguimiento` == 1 ~ "Activo",
                                               `Estado de seguimiento` == 2 ~ "Recuperado",
                                               `Estado de seguimiento` == 3 ~ "Imposible de contactar",
                                               `Estado de seguimiento` == 4 ~ "Perdido",
                                               `Estado de seguimiento` == 5 ~ case_when(Clasificación == "PROBABLE" ~ 'Fallecido',
                                                                                        hospitalizado == 1 ~ 'Hospitalizado',
                                                                                        T ~ "Hospitalizados/Fallecidos"),
                                               `Estado de seguimiento` == 6 ~ "Concluído por otra razón",
                                               is.na(`Estado de seguimiento`) ~ "Sin estado de seguimiento"),
           `Estado de seguimiento` = factor(`Estado de seguimiento`, levels = c("Activo","Recuperado","Imposible de contactar",
                                                                                'Perdido',"Fallecido", "Hospitalizado", "Hospitalizados/Fallecidos","Concluído por otra razón",
                                                                                "Sin estado de seguimiento")),
           `Clínicas Temporales` = case_when(`Clínicas Temporales` == 1 ~ "CBR ZONA 7",
                                             `Clínicas Temporales` == 5 ~ "CBR ZONA 6",
                                             `Clínicas Temporales` == 4 ~ "CBR ZONA 12",
                                             `Clínicas Temporales` == 2 ~ "CBR ZONA 18")) %>%
    rename(`Fecha de notificación` = `Date of reporting`,
           Edad = `Años Años De Edad`,
           Teléfono = `Direcciones Número De Teléfono [1]`,
           Condicion = `Condición del Paciente`,
           zona = `Direcciones Comunidad, aldea o zona [1]`) 
  
  reportCases2 = cases %>%
    select(
      `Carné De Identidad` = ID,
      dms = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [5]`, 
      area_salud = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [3]`,
      `Creado En`,
      Clasificación,
      `¿Se tomó una muestra respiratoria?` = FE121se_tomo_una_muestra_respiratoria,
      edad = `Edad Años De Edad`,
      `Teléfono` = `Direcciones Número De Teléfono [1]`,
      `Estado De Embarazo`,
      fecha_es,
      `Estado de seguimiento` = estado_de_seguimiento_1,
      starts_with('seguimiento_'),
      starts_with('fecha_s'),
      starts_with('por_que_'),
      presenta_sintomas_s1 = presenta_sintomas,
      presenta_sintomas_s2 = ha_presentado_sintomas_s2,
      starts_with('presenta_sintomas_s'),
      contains('enfermedades_asociadas'),
      otra_enfermedad = FE11301especifique,
      hospitalizado = FE130la_persona_fue_hospitalizada
    ) %>%
    unite('comorbilidades', c(contains('enfermedades_asociadas'),otra_enfermedad),sep = ', ',na.rm = T) %>%
    mutate(
      fecha_s1 = case_when(is.na(fecha_s1_s) ~ as.Date(fecha_s1_n), T ~ as.Date(fecha_s1_s)),
      fecha_s2 = case_when(is.na(fecha_s2_s) ~ as.Date(fecha_s2_n), T ~ as.Date(fecha_s2_s)),
      fecha_s3 = case_when(is.na(fecha_s3_s) ~ as.Date(fecha_s3_n), T ~ as.Date(fecha_s3_s)),
      fecha_s4 = case_when(is.na(fecha_s4_s) ~ as.Date(fecha_s4_n), T ~ as.Date(fecha_s4_s)),
      fecha_s5 = case_when(is.na(fecha_s5_s) ~ as.Date(fecha_s5_n), T ~ as.Date(fecha_s5_s)),
      fecha_s6 = case_when(is.na(fecha_s6_s) ~ as.Date(fecha_s6_n), T ~ as.Date(fecha_s6_s)),
      fecha_s7 = case_when(is.na(fecha_s7_s) ~ as.Date(fecha_s7_n), T ~ as.Date(fecha_s7_s)),
      fecha_s8 = case_when(is.na(fecha_s8_s) ~ as.Date(fecha_s8_n), T ~ as.Date(fecha_s8_s)),
      fecha_s9 = case_when(is.na(fecha_s9_s) ~ as.Date(fecha_s9_n), T ~ as.Date(fecha_s9_s)),
      fecha_s10 = case_when(is.na(fecha_s10_s) ~ as.Date(fecha_s10_n), T ~ as.Date(fecha_s10_s)),
      fecha_s11 = case_when(is.na(fecha_s11_s) ~ as.Date(fecha_s11_n), T ~ as.Date(fecha_s11_s)),
      fecha_s12 = case_when(is.na(fecha_s12_s) ~ as.Date(fecha_s12_n), T ~ as.Date(fecha_s12_s)),
      fecha_s13 = case_when(is.na(fecha_s13_s) ~ as.Date(fecha_s13_n), T ~ as.Date(fecha_s13_s)),
      fecha_s14 = case_when(is.na(fecha_s14_s) ~ as.Date(fecha_s14_n), T ~ as.Date(fecha_s14_s)),
      maxDate = apply(across(starts_with('fecha_s')),1,max, na.rm = T),
      comorbilidades = gsub('14', 'Otro', comorbilidades),
      comorbilidades = gsub('11', 'Obesidad', comorbilidades),
      comorbilidades = gsub('10', 'Disfuón Neuromuscular', comorbilidades),
      comorbilidades = gsub('9', 'Cardiopatía Crónica (hipertensión arterial)', comorbilidades),
      comorbilidades = gsub('8', 'Enfermedad Hepática Crónica', comorbilidades),
      comorbilidades = gsub('7', 'Tratamiento Con Corticosteroides', comorbilidades),
      comorbilidades = gsub('6', 'Inmunosupresión', comorbilidades),
      comorbilidades = gsub('5', 'Asma', comorbilidades),
      comorbilidades = gsub('4', 'Cáncer', comorbilidades),
      comorbilidades = gsub('3', 'Insuficiencia Renal Crónica', comorbilidades),
      comorbilidades = gsub('2', 'Enfermedad Pulmonar Obstructiva Crónica', comorbilidades),
      comorbilidades = gsub('1', 'Diabetes Mellitus', comorbilidades),
      `Teléfono` = ifelse(is.na(`Teléfono`),'NO CONTACTABLE','CONTACTABLE'),
      `Creado En` = as.Date(`Creado En`),
      area_salud = case_when(area_salud == "DAS Alta Verapáz" ~ "DAS Alta Verapaz",
                             area_salud %like% 'DAS' ~ area_salud,
                             area_salud %like% 'SIN DATO' ~ area_salud,
                             T ~ 'SIN DATO'),
      area_salud = toupper(area_salud),
      dms = case_when(dms %like% 'DMS' ~ dms,
                      T ~ "SIN DATO"),
      dms = toupper(dms),
      Clasificación = toupper(Clasificación),
      `Estado de seguimiento` = case_when(`Estado de seguimiento` == 1 ~ "Activo",
                                          `Estado de seguimiento` == 2 ~ "Recuperado",
                                          `Estado de seguimiento` == 3 ~ "Imposible de contactar",
                                          `Estado de seguimiento` == 4 ~ "Perdido",
                                          `Estado de seguimiento` == 5 ~ case_when(Clasificación == "PROBABLE" ~ 'Fallecido',
                                                                                   hospitalizado == 1 ~ 'Hospitalizado',
                                                                                   T ~ "Hospitalizados/Fallecidos"),
                                          `Estado de seguimiento` == 6 ~ "Concluído por otra razón",
                                          is.na(`Estado de seguimiento`) ~ "Sin estado de seguimiento"),
      `Estado de seguimiento` = factor(`Estado de seguimiento`, levels = c("Activo","Recuperado","Imposible de contactar",
                                                                           'Perdido',"Fallecido", "Hospitalizado", "Hospitalizados/Fallecidos","Concluído por otra razón",
                                                                           "Sin estado de seguimiento"))
    ) %>%
    select(!ends_with('_s')) %>%
    select(!ends_with('_n')) %>%
    filter(
      Clasificación != 'NO ES UN CASO (DESCARTADO)',
      Clasificación != 'SOSPECHOSO E'
    )
  
  reportCases2 = reportCases2 %>%
    gather(ultimoSeguimiento, val, starts_with('seguimiento_')) %>%
    filter(!is.na(val)) %>%
    group_by(`Carné De Identidad`) %>%
    summarise(ultimoSeguimiento = last(val)) %>%
    left_join(reportCases2, ., by = 'Carné De Identidad')
  
  reportCases2 = reportCases2 %>%
    gather(ultimoPorque, val, starts_with('por_que_')) %>%
    filter(!is.na(val)) %>%
    group_by(`Carné De Identidad`) %>%
    summarise(ultimoPorque = last(val)) %>%
    left_join(reportCases2, ., by = 'Carné De Identidad')
  
  reportCases2 = reportCases2 %>%
    gather(ultimoSintoma, val, starts_with('presenta_sintomas_s')) %>%
    filter(!is.na(val)) %>%
    group_by(`Carné De Identidad`) %>%
    summarise(ultimoSintoma = last(val)) %>%
    left_join(reportCases2, ., by = 'Carné De Identidad')
  
  write('Casos descargados!',stdout())
  
  cases_clean = dplyr::bind_rows(cases_clean,cases_clean2)
  reportCases = dplyr::bind_rows(reportCases,reportCases2)
  
  
}

# Downloading outbreak contacts
## Set URL of of outbreak contacts
contactsURL = paste(url,
                    'outbreaks/',
                    outbreak_id,
                    '/contacts/export?type=csv&access_token=',
                    token,
                    sep="")
## Download outbreak contacts
write('Descargando contactos...',stdout())
outbreakContacts = GET(contactsURL)
contacts = data.table(suppressMessages(content(outbreakContacts, guess_max = 50000)))

contacts_clean = contacts %>%
  select(`Fecha de notificación`, 
         Sexo,
         Ocupación, 
         `Años Años De Edad)` = `Edad Edad (años)`, 
         `Fecha De Convertirse En Caso` = `Fecha de convertirse en caso`,
         Tipo, 
         `Seguimiento Seguimiento De Estatus Final` = `Seguimiento Estado final del seguimiento`, 
         `Seguimiento Comienzo Del Seguimiento` = `Seguimiento Inicio de seguimiento`, 
         `Seguimiento Final Del Seguimiento` = `Seguimiento Final Del Seguimiento`, 
         `Relación Nivel de riesgo`, 
         `Relación Personas Persona De Referencia`,
         `Direcciones Ubicación [1]`, 
         `Direcciones Ubicación [1] Localización Geográfica De Nivel [1]` = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [1]`,
         `Direcciones Ubicación [1] Localización Geográfica De Nivel [2]` = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [2]`, 
         dms = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [5]`, 
         area_salud = `Direcciones Ubicación [1]  Nivel De Localización Geográfica [3]`,
         `Direcciones Número De Teléfono [1]`,
         `Direcciones Comunidad, aldea o zona [1]`, 
         `Creado En`) %>%
  mutate(`Fecha de notificación` = as.Date(`Fecha de notificación`),
         `Creado En` = as.Date(`Creado En`),
         `Fecha De Convertirse En Caso` = as.Date(`Fecha De Convertirse En Caso`),
         Sexo = toupper(Sexo),
         Sexo = ifelse(is.na(Sexo),"SIN DATOS",Sexo),
         Sexo= factor(Sexo,levels=c("MASCULINO", "FEMENINO", "SIN DATOS")),
         grupo_etario = case_when(`Años Años De Edad)` < 10 ~ "0-9 años",
                                  `Años Años De Edad)` >= 10 & `Años Años De Edad)` < 20 ~ "10-19 años",
                                  `Años Años De Edad)` >= 20 & `Años Años De Edad)` < 30 ~ "20-29 años",
                                  `Años Años De Edad)` >= 30 & `Años Años De Edad)` < 40 ~ "30-39 años",
                                  `Años Años De Edad)` >= 40 & `Años Años De Edad)` < 50 ~ "40-49 años",
                                  `Años Años De Edad)` >= 50 & `Años Años De Edad)` < 60 ~ "50-59 años",
                                  `Años Años De Edad)` >= 60 & `Años Años De Edad)` < 70 ~ "60-69 años",
                                  `Años Años De Edad)` >= 70 & `Años Años De Edad)` < 80 ~ "70-79 años",
                                  `Años Años De Edad)` >= 80 ~ "80+ años",
                                  is.na(`Años Años De Edad)`) ~"SIN DATOS"),
         grupo_etario = factor(grupo_etario,
                               levels = c("0-9 años","10-19 años","20-29 años","30-39 años",
                                          "40-49 años","50-59 años","60-69 años","70-79 años",
                                          "80+ años","SIN DATOS")),
         `Direcciones Número De Teléfono [1]` = ifelse(is.na(`Direcciones Número De Teléfono [1]`),'NO CONTACTABLE','CONTACTABLE'),
         `Direcciones Número De Teléfono [1]` = factor(`Direcciones Número De Teléfono [1]`, levels = c('NO CONTACTABLE','CONTACTABLE')),
         area_salud = case_when(area_salud == "DAS Alta Verapáz" ~ "DAS Alta Verapaz",
                                area_salud %like% 'DAS' ~ area_salud,
                                area_salud %like% 'SIN DATO' ~ area_salud,
                                T ~ 'SIN DATO'),
         area_salud = toupper(area_salud),
         dms = case_when(dms %like% 'DMS' ~ dms,
                         T ~ "SIN DATO"),
         dms = toupper(dms),
         `Seguimiento Seguimiento De Estatus Final` = case_when(`Seguimiento Seguimiento De Estatus Final` == "Información rastreo incompleta" ~ "Información insuficiente",
                                                                T ~ `Seguimiento Seguimiento De Estatus Final`)) %>%
  rename(Edad = `Años Años De Edad)`,
         `Caso relacionado` = `Relación Personas Persona De Referencia`,
         `Status final de seguimiento` = `Seguimiento Seguimiento De Estatus Final`,
         `Inicio del seguimiento` = `Seguimiento Comienzo Del Seguimiento`,
         `Final del seguimiento` = `Seguimiento Final Del Seguimiento`,
         Teléfono = `Direcciones Número De Teléfono [1]`,
         zona = `Direcciones Comunidad, aldea o zona [1]`,
         riesgo = `Relación Nivel de riesgo`)

write('Contactos descargados!', stdout())

## Dwnload Followups
#specify date ranges, for follow up filters
date_now <- format(Sys.time(), "%Y-%m-%dT23:59:59.999Z")                  
date_5d_ago <- format((Sys.Date()-5), "%Y-%m-%dT23:59:59.999Z")
date_start = "2020-08-12T00:00:00.000Z"



# import contact follow-ups, last 21 days only to avoid system time-out 
write('Descargando seguimientos de contactos...',stdout())
response_followups <- GET(paste0(
  url,
  "outbreaks/",
  outbreak_id,
  "/follow-ups/export?type=csv&filter={%22where%22:{%22and%22:[{%22date%22:{%22between%22:[%22",
  date_start,
  "%22,%22",
  date_now,
  "%22]}}]}}&access_token=",
  token))

followups = data.table(suppressMessages(content(response_followups, guess_max = 50000)))
write('Seguimientos descargados!', stdout())
followups = followups %>%
  select(ID, `Creado En`, `Estado`)


write('Guardando bases de datos...',stdout())
write_excel_csv(cases_clean,'./DashboardRastreo/data/rastreo_cases.csv')

write_excel_csv(reportCases,'./DashboardRastreo/data/report_cases.csv')

write_excel_csv(contacts_clean,'./DashboardRastreo/data/rastreo_contacts.csv')

write_excel_csv(followups,'./DashboardRastreo/data/rastreo_followups.csv')
write('Bases de datos guardadas!',stdout())

write('Actualizando tablero...',stdout())
deployApp(paste(getwd(),'/DashboardRastreo', sep = ''), forceUpdate = TRUE, launch.browser = FALSE)



