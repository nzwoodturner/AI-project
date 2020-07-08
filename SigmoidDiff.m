function [out] = SigmoidDiff(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
out=(exp(-x))/((1+exp(-x))^2);
end

