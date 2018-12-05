function [handles] = ExpectedLoss(handles)

%Probability of Demolition At Each EDP
prob_demo_edp = zeros(length(handles.EDP.RIDR),1);
for i=1:length(handles.EDP.RIDR) %Loop over each EDP
    prob_demo_edp = normcdf((log(handles.EDP.RIDR(i))...
        -log(handles.demo.RIDR_median))/handles.demo.RIDR_dispersion);
end

%Probability of Demolition at Each IM
%Multiple the Probability at each EDP by probability of observing that EDP
%at a certain IM

for i=1:length(handles.hazardDerivative(1,:)) %Loop over each IM
    %Loop over every floor
    prob_demo_im = prob_demo_edp; %multiply by probability of RIDR at each IM at each floor
end
