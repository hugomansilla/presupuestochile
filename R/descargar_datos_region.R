#' Download JSON files from 'presupuestoabierto.gob.cl' by region
#'
#' This function has been designed to download and consolidate JSON files from the
#' webpage 'presupuestoabierto.gob.cl'. The output is a data set with all the information
#' of public resources by region of Chile per year.
#'
#' @param region A vector with the number of each region to download.
#' @param years A vector with the years to download.
#'
#' @author Hugo Mansilla
#'
#' @seealso \link[jsonlite]{fromJSON}
#' @seealso \link[dplyr]{select}
#'
#' @import jsonlite
#' @import dplyr
#'
#' @return Return a data set with all the information of public resources by region per year.
#' @export
#'
#' @examples
#' \dontrun{
#' descargar_datos_region(region=12,c(2016,2017,2018,2019,2020))
#' }

descargar_datos_region <-
function(region,years){

  # Validacion de datos.
  if (!is.numeric(region)) {
    stop("El formato de la region no es valido. Debe ser numerico")
  }

  if (!is.numeric(years)) {
    stop("El formato de los anios no es valido. Todos los anios deben ser numericos.")
  }

  if (any(nchar(years)!=4)) {
    stop("El formato de los anios no es valido. Todos los anios deben contener 4 cifras.")
  }

  # Importacion de datos en formato JSON.
  uri <- list()
  bases <- list()

  for (i in 1:length(years)) {

    year <- years[i]

    # Guardar URI
    uri[[i]] <- paste0("https://presupuestoabierto.gob.cl/api/v1/data/pagos?group-by=[%22partida%22,%22capitulo%22,%22area%22]&where={%22region%22:",region,",%22periodo%22:",year,"}")

    # Leer JSON
    bases[[i]] <- fromJSON(uri[[i]])

    # Agregar periodo y region
    bases[[i]]$periodo <- year
    bases[[i]]$region <- region

  }

  # Consolidacion bases de datos
  datos <- do.call(rbind,bases)

  message("Descarga finalizada!")
  message("La base de datos contiene: ", nrow(datos), " filas"," y ",ncol(datos), " columnas.")

  return(datos)
}
