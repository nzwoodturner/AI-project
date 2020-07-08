function [value,value2] = node(weights,bias,values)
value=0;
for n=1:length(weights)
    value = weights(n)*values(n)+value;
end
value=value+bias;
value2=value;
%squish
value=1/(1+exp(-value));
end

