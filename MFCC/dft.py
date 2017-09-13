import pyaudio
from pylab import *
import numpy

def nextpow2(i):
    n = 1
    while(n<i): 
        n *= 2
    return n

microphone = pyaudio.PyAudio()
format = pyaudio.paInt16                # Consumes optimum energy and delivers good quality
channels = 1
sampRate = 10000                        # 10k

recordTime = 0.005                      # In seconds
dataLength = int(sampRate*recordTime)

# Creating a recording format object
dataStream = microphone.open(format = format,
                             channels = channels,
                             rate = sampRate,
                             input = True,
                             frames_per_buffer = dataLength)

# Getting the data
data = dataStream.read(dataLength)

# Taking the DFT
frame = numpy.fromstring(data,'int16')        # Converting the input to int
nfft = 2^(nextpow2(len(frame)))
fftx = fft(frame,nfft)

nUniquePts = int(ceil((nfft+1)/2.0))
fftx = fftx[0:nUniquePts]
fftx = abs(fftx)

fftx = fftx**2
fftx[1:len(fftx) -1] = fftx[1:len(fftx) - 1] * 2
freqArray = arange(0, nUniquePts, 1.0) * (sampRate*1.0 / nfft);
plot(freqArray/1000, 10*log10(fftx), color='k')
xlabel('Frequency (kHz)')
ylabel('Power (dB)')
show()
