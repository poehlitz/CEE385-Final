function [handles] = ExpectedLoss(handles)

%Probability of Demolition At Each EDP
prob_demo_edp = zeros(length(handles.EDP.RIDR),1);
for i=1:length(handles.EDP.RIDR) %Loop over each EDP
    prob_demo_edp(i) = normcdf((log(handles.EDP.RIDR(i))...
        -log(handles.demo.RIDR_median))/handles.demo.RIDR_dispersion);
end

%Probability of Demolition at Each IM
%Multiple the Probability at each EDP by probability of observing that EDP
%at a certain IM

for i=1:length(handles.hazardDerivative(1,:)) %Loop over each IM
    %Loop over every floor, this isn't finished yet huh
    for j = 1:handles.numStory-1
        story_index = strcat('RIDR', num2str(handles.numStory - j));
        prob_demo_im(j, i) = trapz(handles.EDP.RIDR, prob_demo_edp.*handles.EDPtype.(story_index).pdf_edp_im(:, i)); %multiply by probability of RIDR at each IM at each floor
    end
end

handles.demo.p_im_story = prob_demo_im;
handles.demo.p_im = max(handles.demo.p_im_story);




