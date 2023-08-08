# Signals and Noise

Introduces students to the difference between signals and noise, and the signal-to-noise ratio as a measure of the quality of a spectrum. The use of signal averaging, moving average filters, and Savitzky-Golay filters as computational methods for improving the signal-to-noise ratio are introduced. The application uses a database that contains 64 visible spectra of a blue dye; students can download the data as a .csv file.

To run locally, install the packages shiny and shinythemes (if not already installed), and enter the following two lines into the console:

library(shiny)

shiny::runGitHub("Noise","dtharvey")
