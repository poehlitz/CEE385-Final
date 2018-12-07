function [handles] = ExpectedLoss(handles)
%Enter in GUI
handles.demo.RIDR_median = 0.015; % User input here
handles.demo.RIDR_dispersion = 0.3; % User input here

%Probability of Demolition At Each EDP
prob_demo_edp = zeros(length(handles.EDP.RIDR),1);
for i=1:length(handles.EDP.RIDR) %Loop over each EDP
    prob_demo_edp(i) = normcdf((log(handles.EDP.RIDR(i))...
        -log(handles.demo.RIDR_median))/handles.demo.RIDR_dispersion);
end

%Probability of Demolition at Each IM
%Multiple the Probability at each EDP by probability of observing that EDP
%at a certain IM
Sa = handles.hazardDerivative(1,:);
prob_demo_im = zeros(handles.numStory - 1, length(Sa));

for i=1:length(Sa) %Loop over each IM
    %Loop over every floor, this isn't finished yet huh
        story_index = strcat('RIDR', num2str(handles.numStory - j));
        prob_demo_im(i) = trapz(handles.EDP.RIDR, prob_demo_edp.*handles.EDPtype.(story_index).pdf_edp_im(:, i)); %multiply by probability of RIDR at each IM at each floor
end

handles.demo.p_im = prob_demo_im;




