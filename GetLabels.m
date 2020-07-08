function [labels] = GetLabels(fileName,shuffle)
fileID=fopen(fileName);
tempLabels=fread(fileID);
labels=(length(tempLabels)-8);
for i=9:length(tempLabels)
    labels(shuffle(i-8))=tempLabels(i);
end
end

