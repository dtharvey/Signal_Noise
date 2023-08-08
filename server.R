library(shiny)
library(shinythemes)

# set colors
palette("Okabe-Ito")

# create filters
sg5 = c(-3,12,17,12,-3)/35
sg7 = c(-2,3,6,7,6,3,-2)/21
sg9 = c(-21,14,39,54,59,54,39,14,-21)/231
sg11 = c(-36,9,44,69,84,89,84,69,44,9,-36)/429
sg13 = c(-11,0,9,16,21,24,25,24,21,16,9,0,-11)/143
sg15 = c(-78,-13,42,87,122,147,162,167,162,147,122,87,42,-13,-78)/1105
sg17 = c(-21,6,7,18,27,34,39,42,43,42,39,34,27,18,7,-6,-21)/323
sg19 = c(-136,-51,24,89,144,189,224,249,264,269,264,249,224,189,144,89,24,-51, -136)/2261
sg21 = c(-171,-76,9,84,149,204,249,284,309,324,329,324,309,284,249,204,149,84,9,-76,-171)/3059
sg23 = c(-42,-21,-2,15,30,43,54,63,70,75,78,79,78,75,70,63,54,43,30,15,-2,-21,-42)/805
sg25 = c(-253,-138,-33,62,147,222,287,322,387,422,447,462,467,462,447,422,387,322,287,222,147,62,-33,-138-253)/5175
sgfilters = list(NA,NA,NA,NA,sg5,NA,sg7,NA,sg9,NA,sg11,NA,sg13,NA,sg15,NA,sg17,NA,sg19,NA,sg21,NA,sg23,NA,sg25)

# load in the any files needed by server
spectra = read.csv(file = "data/blue_singlescans.csv")
set.seed(13)

shinyServer(function(input, output) {
  
  output$introplot1 = renderPlot({
    old.par = par(mfrow = c(3,3))
    plot(x = spectra$wavelength, y = spectra$abs60, 
         type = "l", lwd = 2, col = 3, xlab = "", 
         ylab = "absorbance (au)", bty = "n",
         ylim = c(0, 0.03), xaxt = "n")
    plot(x = spectra$wavelength, y = spectra$abs47, 
         type = "l", lwd = 2, col = 3, xlab = "", ylab = "", bty = "n",
         ylim = c(0, 0.03), xaxt = "n", yaxt = "n")
    plot(x = spectra$wavelength, y = spectra$abs62, 
         type = "l", lwd = 2, col = 3, xlab = "", ylab = "", bty = "n",
         ylim = c(0, 0.03), xaxt = "n", yaxt = "n")
    plot(x = spectra$wavelength, y = spectra$abs56, 
         type = "l", lwd = 2, col = 3, xlab = "", ylab = "", bty = "n",
         ylim = c(0, 0.03), xaxt = "n", yaxt = "n")
    matplot(x = spectra$wavelength, y = spectra[,2:65],
         type = "l", lwd = 1, col = 6, xlab = "", ylab = "", bty = "n",
         ylim = c(0, 0.03), xaxt = "n", yaxt = "n")
    plot(x = spectra$wavelength, y = spectra$abs1, 
         type = "l", lwd = 2, col = 3, xlab = "", ylab = "", bty = "n",
         ylim = c(0, 0.03), xaxt = "n", yaxt = "n")
    plot(x = spectra$wavelength, y = spectra$abs49, 
         type = "l", lwd = 2, col = 3, xlab = "", ylab = "", bty = "n",
         ylim = c(0, 0.03), xaxt = "n", yaxt = "n")
    plot(x = spectra$wavelength, y = spectra$abs18, 
         type = "l", lwd = 2, col = 3, xlab = "", ylab = "", bty = "n",
         ylim = c(0, 0.03), xaxt = "n", yaxt = "n")
    plot(x = spectra$wavelength, y = spectra$abs25, 
         type = "l", lwd = 2, col = 3, xlab = "wavelength (nm)", 
         ylab = "", bty = "n",
         ylim = c(0, 0.03), yaxt = "n")
    par(old.par)
  })
  
  output$activity1plot = renderPlot({
    
    id = input$spectrum + 1
    signal = round(spectra[221,id],4)
    noise = round(sd(spectra[347:410,id]),5)
    SN = round(signal/noise,1)
    plot(x = spectra$wavelength, y = spectra[,(id)], type = "l",
            col = 6, lwd = 2, ylim = c(-0.0025,0.0275), bty = "n",
            xlab = "wavelength (nm)", xlim = c(400,900),
            ylab = "absorbance (au)" 
            )
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("signal: ", signal),
                      paste0("noise: ",noise),
                      paste0("S/N: ",SN)))
    legend("topleft", legend = paste0("spectrum number : ",input$spectrum), 
           bty = "n", cex = 1.5)
    grid()
    abline(v = 630, col = 8, lwd = 2)
    rect(725,-0.0025,775,0.006, lwd = 2, border = 8)
    text(x = 632, y = 0.028, pos = 4, label = "signal", 
         col = 8, cex = 1.5)
    text(x = 750, y = 0.007, label = "noise", col = 8, cex = 1.5)
  })
  
  output$activity2plot = renderPlot({
    
    set.seed(1111)
    x = seq(1,256,0.2)
    signal = input$sigmult * (25 * dnorm(x, mean = 125, sd = 10))
    sig_max = round(max(signal),3)
    noise = input$noisemult * rnorm(1276, mean = 0, sd = 0.1)
    noisy_signal = signal + noise
    sd_noise = round(sd(noisy_signal[c(1:50,201:250)]),3)
    sn = round(max(signal)/sd(noisy_signal[c(1:50,201:250)]),1)
    plot(x = x, y = noisy_signal, type = "l", lwd = 2, col = 6,
         ylim = c(-1,2.5), bty = "n", xaxt = "n", xlab = "", 
         ylab = "detector response", cex.main = 1.5,
         main = paste0("signal: ", sig_max, "; noise = ", sd_noise, "; signal-to-noise ratio: ",sn))

    grid()
    
  })
  
  output$activity3plot = renderPlot({
    
    num_spec = as.numeric(input$sigavg)
    old.par = par(mfrow = c(3,3))
    specs = sample(x = 2:65, num_spec, replace = FALSE)
    sigavg = rowSums(spectra[,specs])/num_spec
    plot(x = spectra$wavelength, y = sigavg, type = "l", lwd = 2, 
         col = 6, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "", ylab = "absorbance (au)", 
         xaxt = "n")
    signal = round(sigavg[221],4)
    noise = round(sd(sigavg[347:410]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    
    specs = sample(x = 2:65, num_spec, replace = FALSE)
    sigavg = rowSums(spectra[,specs])/num_spec
    plot(x = spectra$wavelength, y = sigavg, type = "l", lwd = 2, 
         col = 6, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
    signal = round(sigavg[221],4)
    noise = round(sd(sigavg[347:410]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    
    specs = sample(x = 2:65, num_spec, replace = FALSE)
    sigavg = rowSums(spectra[,specs])/num_spec
    plot(x = spectra$wavelength, y = sigavg, type = "l", lwd = 2, 
         col = 6, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
    signal = round(sigavg[221],4)
    noise = round(sd(sigavg[347:410]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    
    specs = sample(x = 2:65, num_spec, replace = FALSE)
    sigavg = rowSums(spectra[,specs])/num_spec
    plot(x = spectra$wavelength, y = sigavg, type = "l", lwd = 2, 
         col = 6, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
    signal = round(sigavg[221],4)
    noise = round(sd(sigavg[347:410]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    
    specs = 31
    plot(x = spectra$wavelength, y = spectra[,specs], type = "l", lwd = 2, 
         col = 3, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
    signal = round(spectra[221,specs],4)
    noise = round(sd(spectra[347:410,specs]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    
    specs = sample(x = 2:65, num_spec, replace = FALSE)
    sigavg = rowSums(spectra[,specs])/num_spec
    plot(x = spectra$wavelength, y = sigavg, type = "l", lwd = 2, 
         col = 6, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
    signal = round(sigavg[221],4)
    noise = round(sd(sigavg[347:410]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    
    specs = sample(x = 2:65, num_spec, replace = FALSE)
    sigavg = rowSums(spectra[,specs])/num_spec
    plot(x = spectra$wavelength, y = sigavg, type = "l", lwd = 2, 
         col = 6, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
    signal = round(sigavg[221],4)
    noise = round(sd(sigavg[347:410]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    
    specs = sample(x = 2:65, num_spec, replace = FALSE)
    sigavg = rowSums(spectra[,specs])/num_spec
    plot(x = spectra$wavelength, y = sigavg, type = "l", lwd = 2, 
         col = 6, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n")
    signal = round(sigavg[221],4)
    noise = round(sd(sigavg[347:410]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    
    specs = sample(x = 2:65, num_spec, replace = FALSE)
    sigavg = rowSums(spectra[,specs])/num_spec
    plot(x = spectra$wavelength, y = sigavg, type = "l", lwd = 2, 
         col = 6, ylim = c(0,0.03), xlim = c(400,900),
         bty = "n", xlab = "wavelength (nm)", ylab = "", yaxt = "n")
    signal = round(sigavg[221],4)
    noise = round(sd(sigavg[347:410]),5)
    SN = round(signal/noise,1)
    legend("topright", bty = "n", cex = 1.5,
           legend = c(paste0("S/N: ",SN)))
    par(old.par)
  })
  
  output$activity4plot = renderPlot({
    
    specs = input$filterspec + 1
    plot(x = spectra$wavelength, y = spectra[,specs], type = "l",
         lwd = 3, col = 8, bty = "n",
         xlim = c(400,900), xlab = "wavelength (nm)",
         ylim = c(0,0.030), ylab = "absorbance (au)")
    filterlength = input$filtersize
    if (input$filtertype == "moving average"){
      mafilter = rep(1/filterlength, filterlength)
      mafiltered = filter(x = spectra[,specs], mafilter)
      signal = round(spectra[221,specs], 4)
      noise = round(sd(spectra[347:410,specs]),5)
      SN = round(signal/noise, 1)
      signalfiltered = round(mafiltered[221], 4)
      noisefiltered = round(sd(mafiltered[347:410]),5)
      SNfiltered = round(signalfiltered/noisefiltered, 1)
      legend(x = "topright", bty = "n", cex = 1.5,
             legend = c(paste0("original S/N: ", SN),
                        paste0("filtered S/N: ", SNfiltered)),
             text.col = c(8, 6))
      lines(x = spectra$wavelength, y = mafiltered, lwd = 2, col = 6)
      legend(x = "topleft", legend = paste0("spectrum number: ",input$filterspec),
             bty = "n", cex = 1.5)
      grid()
    } else {
      sgfiltered = filter(x = spectra[,specs], sgfilters[[input$filtersize]])
      lines(x = spectra$wavelength, y = sgfiltered, lwd = 2, col = 6)
      signal = round(spectra[221,specs], 4)
      noise = round(sd(spectra[347:410,specs]),5)
      SN = round(signal/noise, 1)
      signalfiltered = round(sgfiltered[221], 4)
      noisefiltered = round(sd(sgfiltered[347:410]),5)
      SNfiltered = round(signalfiltered/noisefiltered, 1)
      legend(x = "topright", bty = "n", cex = 1.5,
             legend = c(paste0("original S/N: ", SN),
                        paste0("filtered S/N: ", SNfiltered)),
             text.col = c(8, 6))
      legend(x = "topleft", legend = paste0("spectrum number: ",input$filterspec),
             bty = "n", cex = 1.5)
      grid()

    }
    
  })
  
  output$wrapupplot1 = renderPlot({
    old.par = par(mar = c(1,4,1,2))
    set.seed(1111)
    x = seq(1,256,0.2)
    signal = 25 * dnorm(x, mean = 125, sd = 10)
    noise = rnorm(1276, mean = 0, sd = 0.1)
    noisy_signal = signal + noise
    plot(x = x, y = signal, type = "l", lwd = 2, col = 6,
         ylab = "", ylim = c(-0.2,4),
         bty = "n", xaxt = "n", xlab = "", yaxt = "n",)
    lines(x = x, y = noise + 1.5, type = "l", lwd = 2, col = 6,
         ylab = "detector response", ylim = c(-0.2,1.1),
         bty = "n", xaxt = "n", xlab = "")
    lines(x = x, y = noisy_signal + 2.5, type = "l", lwd = 2, col = 6,
         ylab = "detector response", ylim = c(-0.2,1.1),
         bty = "n", xaxt = "n", xlab = "")
    text(x = 10, y = 0.2, pos = 4, label = "signal")
    text(x = 10, y = 1.1, pos = 4, label = "noise")
    text(x = 10, y = 3.0, pos = 4, label = "signal + noise")
    par(old.par)
  })
  
  output$spectra = downloadHandler(
    filename = "spectra.csv",
    content = function(file){
      write.csv(spectra,file)}
  )
    
  output$wrapupplot2 = renderPlot({  
    set.seed(1111)
    old.par = par(mar = c(5,4,1,2))
    noisy_signal = spectra[,2]
    plot(x = spectra$wavelength, y = noisy_signal, 
         type = "l", lwd = 1, col = 6, ylab = "absorbance (au)",
         xlab = "wavelength (nm)", bty = "n", xlim = c(550,700))
    ma = rep(1/15,15)
    for (i in 1:5){
      noisy_signal = filter(noisy_signal, ma)
      lines(x = spectra$wavelength, y = noisy_signal, 
            lty = i, lwd = 2, col = 8)
    }
    grid()
    legend(x = "topright", 
           legend = c("one pass", "two passes", "three passes", 
                      "four passes", "five passes"), 
           lty = 1:5, col = 8, lwd = 2, bty = "n")
    par(old.par)
  })
  
}) # close server
