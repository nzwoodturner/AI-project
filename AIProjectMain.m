% AI main function
% determain size of neural net or import data
%imageFile =input('please enter image file ','s');
clear
imageFile='train-images.idx3-ubyte';
labelFile='train-labels.idx1-ubyte';
values={};
[imageValues,shuffle]=GetImageData(imageFile);
labels=GetLabels(labelFile,shuffle);
%layers = input('please enter number of hidden layers ');
layers=2;
layerSizes=zeros(1,layers);
for i=1:layers
    %s=num2str(i);
    %fprintf('please enter number of nodes for layer %d',i)
    %layerSizes(i+1)=input(' ');
    layerSizes(i+1)=16;
end
iterations=100;%input('please enter number of iterations ');
layerSizes(1)=784;
layerSizes(i+2)=10;
% initialize
weights={};
for i=1:(layers+1)
    weights{i}=20.*rand(layerSizes(i+1),layerSizes(i))-10;
end
biases={};
for i=1:layers+1
    biases{i}=20.*rand(layerSizes(i+1),1)-10;
end


% inport image files for layer 1 values
for i=1:layers+2
    values{i}=zeros(layerSizes(i),10000);
    values2{i}=zeros(layerSizes(i),10000);
end
%values{i+1}=zeros(10,1);
%values2{i+1}=zeros(10,1);
count=1;
weightCostRatio={};
biasCostRatio={};
nodeCostRatio={};
weightCostSum=0;
for i=2:layers+2
    weightCostRatio{i}=zeros(layerSizes(i),1);
end
for i=2:layers+2
    biasCostRatio{i}=zeros(layerSizes(i),1);
end
for i=1:layers+1
    previousCostRatio{i}=zeros(layerSizes(i),1);
end
for i=2:layers+2
    wantedValues{i}=zeros(layerSizes(i),10000);
end
zeroMatrix=zeros(layerSizes(layers+2),10000);
for i=1:iterations
    % main
    for image=1:length(shuffle)
        values{1}(:,count)=imageValues(image,:,:);
        %values{1}(:,count)=imageValues(count,:,:);
        for L=1:layers+1
            for N=1:layerSizes(L+1)
                [values{L+1}(N,count),values2{L+1}(N,count)]=node(weights{L}(N,:),biases{L}(N),values{L}(:,count));%calculating outcomes
            end
        end
        
        if count==10000%doing back prop
            %imputing the correct
            wantedValues{layers+2}(:,:)=zeroMatrix(:,:);
            for k=1:10000
                wantedValues{layers+2}(labels(k+image-10000)+1,k)=1;
                %wantedValues{layers+2}(labels(k)+1,k)=1;
            end
            cost=0;
            for k=1:layerSizes(layers+2)
                cost=cost+(values{layers+2}(k,count)-wantedValues{layers+2}(k))^2;
            end
            fprintf("cost is currently %f\n",cost)
            %calculating the change needed
            for layer=layers+2:-1:2%layers
                for j=1:layerSizes(layer)%current layer nodes
                    
                    
                    for l=1:layerSizes(layer-1)%prev layer nodes
                        weightCostSum=0;
                        prevCostSum=0;
                        for k=1:10000%for the 100 images
                            
                            prevCostSum=prevCostSum+(weights{layer-1}(j,l)*SigmoidDiff(values2{layer}(j,k))*2*(values{layer}(j,k)-wantedValues{layer}(j,k)));
                            weightCostSum=weightCostSum+(values{layer-1}(l))*SigmoidDiff(values2{layer}(j,k))*2*(values{layer}(j,k)-wantedValues{layer}(j,k));
                            %calculating the sum of all the weights for a
                            %set node and a previous node
                        end
                        previousCostRatio{layer-1}(l)=previousCostRatio{layer-1}(l)+prevCostSum/10000;
                        weightCostRatio{layer}(j,l)=weightCostSum/10000;%averageing all the values for the node to prev node weight
                    end
                    
                    biasCostSum=0;
                    for k=1:100
                        biasCostSum=biasCostSum+(SigmoidDiff(values2{layer}(j,k))*2*(values{layer}(j,k)-wantedValues{layer}(j,k)));
                    end
                    biasCostRatio{layer}(j)=biasCostSum/10000;
                end
                wantedValues{layer-1}=values{layer-1}-previousCostRatio{layer-1};
                
            end
            %putting the ratios into the matrix
            
           for k=1:layers+1
               biases{k}=biases{k}-biasCostRatio{k+1};
               weights{k}=weights{k}-weightCostRatio{k+1};
           end
            
            count=0;
            fprintf("up to image %d\n",image);
        end
        count =count+1;
    end
    
    
end
%export weights and bias for next time