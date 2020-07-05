#' Download JSON files from 'presupuestoabierto.gob.cl' by recipient identification number
#'
#' This function has been designed to download and consolidate JSON files from the
#' webpage 'presupuestoabierto.gob.cl'. The output is a data set with all the information of
#' recipients of public resources per year.
#'
#' @param ruts A vector with the 'rut' of each recipient to download.
#' @param years A vector with the years to download.
#' @param val Logical. Delete variables that contain only NA? FALSE by default.
#'
#' @author Hugo Mansilla
#'
#' @seealso \link[jsonlite]{fromJSON}
#' @seealso \link[dplyr]{select}
#'
#' @import jsonlite
#' @import dplyr
#'
#' @return Return a data set with all the information of recipients of public resources per year.
#' @export
#'
#' @examples
#' \dontrun{
#' descargar_datos_receptor(c("70005600-7","81591900-9"),c(2016,2017,2018,2019),val=TRUE)
#' }

descargar_datos_receptor <-
function(ruts,years,val=FALSE){

  # Validacion de datos.
  if (any(nchar(ruts)!=10)) {
    print("Alguno de los ruts ingresados no contiene 9 cifras.")
  }

  if (!any(grepl("-",ruts,fixed=TRUE))) {
    stop("El formato de alguno de los ruts ingresados no es valido. Recuerda agregar '-' antes del digito verificador.")
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
  recep <- list()

  for (j in 1:length(ruts)) {

    rut <- ruts[j]

    for (i in 1:length(years)) {

      year <- years[i]

      # Guardar URI
      uri[[i]] <- paste0("https://presupuestoabierto.gob.cl/api/v1/data/pagos?where={%22beneficiario%22:%22",rut,"%22,%22periodo%22:",year,"}")

      # Leer JSON
      bases[[i]] <- fromJSON(uri[[i]])

    }
    # Juntar bases de bases
    recep[[j]] <- do.call(rbind,bases)
  }

  # Consolidacion y descripcion base de datos.
  datos <- do.call(rbind,recep)

  if (val==TRUE) {
    datos <- datos %>% select(which(sapply(.,class)!="logical"))
  }

  message("Descarga finalizada!")
  message("La base de datos contiene: ", nrow(datos), " filas"," y ",ncol(datos), " columnas.")
  message("Se encontraron datos de los siguientes anios y ruts:")
  print(table(datos$periodo,datos$beneficiario))


  return(datos)
}
