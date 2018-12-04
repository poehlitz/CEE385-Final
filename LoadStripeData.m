function [handles] = LoadStripeData(handles, filenames,ns)

for i=1:ns
    disp(filenames(i))
    stripes_edp{i} = readtable(filenames(i));
end

%Load Each EDP into Structure
EDP=table2array(stripes_edp{1}(:,1));
handles.EDPnames = EDP;

% Loop through all of the different types of damage fragilities

for i=1:length(EDP)
    for j = 1:ns
    % Find the number DS for each componenet
    a(j,:) = table2array(stripes_edp{j}(i,2:end));
    end
    handles.EDPtype.(EDP{i}).GMData = a;
end