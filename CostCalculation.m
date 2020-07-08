function [cost] = CostCalculation(values,answer)
cost=0;
for i=1:10
    if i==answer+1
        cost =cost+(values(i)-1)^2;
        
    else
        cost=cost+values(i)^2;
    end
end

end

