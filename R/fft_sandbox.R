# read in data for blue dye spectrum
spectra = read.csv(file = "data/blue_singlescans.csv")

# supress warnings
old.opt <- getOption("warn")
options(warn = -1)

# vectors of wavelengths and absorbance values
x = spectra$wavelength[1:512]
y = spectra$abs1[1:512]

# take fft of absorbance values
yfft = fft(y)

# grid for plots
old.par = par(mfrow = c(2,1))

# display plot of spectrum after fft
plot(x = 1:512, y = yfft, type = "l", lwd = 2, col = 6, ylim = c(-0.5,0.5))

# display first half of data
# plot(x = x[1:256], y = yfft[1:256], type = "l", lwd = 2, col = 6, ylim = c(-1,1))

# zero out the noise
yfft[26:486] = 0

# display the zeroing out
# plot(x = x[1:512], y = yfft[1:512], type = "l", lwd = 2, col = 6, ylim = c(-0.5,0.5))

# take inverse fft
yinvfft = fft(yfft, inverse = TRUE)/length(yfft)

# display original data and smoothed data
plot(x = x[1:512], y = Re(yinvfft[1:512]), type = "l", lwd = 2, col = 6)
lines(x = x[1:512], y = spectra$abs1[1:512], type = "l", lwd = 2, col = 8)

par(old.par)

# reset warning
options(warn = old.opt)
