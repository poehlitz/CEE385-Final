function [handles] = ExpectedLoss(handles)

%Probability of Demolition At Each EDP
handles.EDP.RIDR = 0:.01:4.0;

prob_demo_edp = zeros(length(handles.EDP.RIDR),1);
for i=1:length(handles.EDP.RIDR)
    prob_demo_edp = normcdf((log(handles.EDP.RIDR(i))...
        -log(handles.demo.RIDR_median))/handles.demo.RIDR_dispersion);
end

%Probability of Demolition at Each IM
%Multiple the Probability at each EDP by probability of observing that EDP
%at a certain IM

for i=1:length(handles.hazardDerivative(1,:))
    prob_demo_im = 
end
