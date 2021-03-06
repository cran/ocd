#' Parkfield seismic sensor data
#'
#' Processed data from 39 ground motion sensors at 13 stations near
#' Parkfield, California from 2.00-2.16am on December 23, 2004, with
#' an earthquake measured at duration magnitude 1.47Md hit near
#' Atascadero, California at 02:09:54.01.
#'
#' @docType data
#'
#' @usage data(ParkfieldSensors)
#'
#' @format A matrix with 39 columns and 14998 rows, with each column
#' corresponding to a sensor and each row corresponding to a time
#' after 2am. Column names corresponds to names of the sensors and row
#' names are number of seconds after 2am.
#'
#' @keywords datasets
#'
#' @source HRSN (2014), High Resolution Seismic Network.
#' UC Berkeley Seismological Laboratory. Dataset. doi:10.7932/HRSN.
#'
#' @examples
#' data(ParkfieldSensors)
#' head(ParkfieldSensors)
#'
#' \dontrun{
#' plot(c(0, nrow(ParkfieldSensors) * 0.064), c(0, ncol(ParkfieldSensors)+1),
#'      pch=' ', xlab='seconds after 2004-12-23 02:00:00',
#'      ylab='sensor measurements')
#' x <- as.numeric(rownames(ParkfieldSensors))
#' for (j in 1:ncol(ParkfieldSensors)){
#'   y <- ParkfieldSensors[, j]
#'   y <- (y - max(ParkfieldSensors)) / diff(range(ParkfieldSensors)) + 0.5 + j
#'   points(x, y, pch='.')
#' }
#' abline(v = 9 * 60 + 54.01, col='blue', lwd=2, lty=3) # earthquake time
#'
#' library(magrittr)
#' p <- ncol(ParkfieldSensors)
#' train_ind <- as.numeric(rownames(ParkfieldSensors)) <= 240
#' train <- ParkfieldSensors[train_ind, ]
#' test <- ParkfieldSensors[!train_ind, ]
#'
#' # tuning parameters
#' gamma <- 24 * 60 * 60 / 0.064 # patience = 1 day
#' beta <- 150
#'
#' # use theoretical thresholds suggested in Chen, Wang and Samworth (2020)
#' psi <- function(t){p - 1 + t + sqrt(2 * (p - 1) * t)}
#' th_diag <- log(24*p*gamma*log2(4*p))
#' th_off_s <- 8*log(24*p*gamma*log2(2*p))
#' th_off_d <- psi(th_off_s/4)
#' thresh <- setNames(c(th_diag, th_off_d, th_off_s), c('diag', 'off_d', 'off_s'))
#'
#' # initialise ocd detector
#' detector <- ChangepointDetector(dim=p, method='ocd', beta=beta, thresh=thresh)
#'
#' # use training data to update baseline mean and standard deviation
#' detector %<>% setStatus('estimating')
#' for (i in 1:nrow(train)) {
#'   detector %<>% getData(train[i, ])  
#' }  
#'
#' # find changepoint in the test data
#' detector %<>% setStatus('monitoring')
#' for (i in 1:nrow(test)) {
#'   detector %<>% getData(test[i, ])
#'   if (is.numeric(detector %>% status)) break
#' }
#'
#' if (is.numeric(detector %>% status)) {
#'   time_declared <- 240 + detector %>% status * 0.064
#'   abline(v = time_declared, col='orange', lwd=2, lty=3) # detection time
#'   cat('Change detected', time_declared, 'seconds after 2am.\n')
#' }
#' }
"ParkfieldSensors"
