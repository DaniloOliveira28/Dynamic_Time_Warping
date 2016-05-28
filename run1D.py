import numpy as np
import unicodecsv
import csv
from dtw_danilo import KnnDtw

m = KnnDtw()

treinoFile = open("./Data/treino.txt", "r")

# Train the algorithm
trainLabels = []
trainSet = []
for line in treinoFile:
    line = line.split(" ")
    line = [float(i) for i in line]
    trainLabels.append(line[0])
    trainSet.append(line[1:])

trainSet = np.array(trainSet)
trainLabels = np.array(trainLabels)

m.fit(trainSet, trainLabels)

# Load the test set
testLabels = []
trainSetTest = []
testFile = open("./Data/teste.txt", "r")
for line in testFile:
    line = line.split(" ")
    line = [float(i) for i in line]
    testLabels.append(line[0])
    trainSetTest.append(line[1:])

# print trainSetTest
testLabels = np.array(testLabels)
trainSetTest = np.array(trainSetTest)

# Load the result file
resultFile = open("./Data/results.csv", "wa")
w = unicodecsv.writer(resultFile,
                      encoding='UTF-8',
                      delimiter=';',
                      quotechar='"',
                      quoting=csv.QUOTE_ALL)

w.writerow(["DIMENSION", "BANDWIDTH", "TOTAL",
            "SCORE", "PERCENTAGE", "ELLAPSED_TIME"])
# execute with bandwith 0%
m.set_bandwidth(0)
result, elapsed_time = m.predict(trainSetTest)
total = len(result)
scoreTotal = np.sum(result == testLabels)
scorePercentage = float(scoreTotal) / total
w.writerow(["1d", 0, total, scoreTotal, scorePercentage, elapsed_time])

# execute with bandwith 1%
m.set_bandwidth(0.01)
result, elapsed_time = m.predict(trainSetTest)
total = len(result)
scoreTotal = np.sum(result == testLabels)
scorePercentage = float(scoreTotal) / total
w.writerow(["1d", 0.01, total, scoreTotal, scorePercentage, elapsed_time])

# execute with bandwith 5%
m.set_bandwidth(0.05)
result, elapsed_time = m.predict(trainSetTest)
total = len(result)
scoreTotal = np.sum(result == testLabels)
scorePercentage = float(scoreTotal) / total
w.writerow(["1d", 0.05, total, scoreTotal, scorePercentage, elapsed_time])

# execute with bandwith 10%
m.set_bandwidth(0.10)
result, elapsed_time = m.predict(trainSetTest)
total = len(result)
scoreTotal = np.sum(result == testLabels)
scorePercentage = float(scoreTotal) / total
w.writerow(["1d", 0.10, total, scoreTotal, scorePercentage, elapsed_time])

# execute with bandwith 20%
m.set_bandwidth(0.20)
result, elapsed_time = m.predict(trainSetTest)
total = len(result)
scoreTotal = np.sum(result == testLabels)
scorePercentage = float(scoreTotal) / total
w.writerow(["1d", 0.20, total, scoreTotal, scorePercentage, elapsed_time])

# # execute with bandwith 50%
m.set_bandwidth(0.50)
result, elapsed_time = m.predict(trainSetTest)
total = len(result)
scoreTotal = np.sum(result == testLabels)
scorePercentage = float(scoreTotal) / total
w.writerow(["1d", 0.50, total, scoreTotal, scorePercentage, elapsed_time])

# execute with bandwith 100%
m.set_bandwidth(1)
result, elapsed_time = m.predict(trainSetTest)
total = len(result)
scoreTotal = np.sum(result == testLabels)
scorePercentage = float(scoreTotal) / total
w.writerow(["1d", 1, total, scoreTotal, scorePercentage, elapsed_time])
