import pyaudio

microphone = pyaudio.PyAudio()
format = pyaudio.paInt16                # Consumes optimum energy and delivers good quality
channels = 1
sampleRate = 10000                      # 10k

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
