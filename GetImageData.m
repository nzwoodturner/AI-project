function [matrix,shuffle] = GetImageData(fileName)
fileID=fopen(fileName);
if fileID==-1 
    fprintf('error while opening images');
else
    k=17;
    tempImageArray=fread(fileID);
    imageNumber=(length(tempImageArray)-16)/784;
    tempmatrix=zeros(imageNumber,784);
    matrix=zeros(imageNumber,784);
    %formating array
    for i=1:imageNumber
        for j=1:784
            tempmatrix(i,j)=tempImageArray(k)/255;
            k=k+1;
        end
    end
    %shuffling array
    shuffle=randperm(imageNumber);
    for i=1:imageNumber
       matrix(shuffle(i),:)=tempmatrix(i,:);
    end
end

