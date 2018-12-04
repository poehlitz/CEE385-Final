
%Load Stripes Values from .csv - offset data by one to only get numeric
%data
%Maybe we could structure this similar to how we structured the fragility
%and loss functions
filenames=["Stripe1_Sa0.10_1col_S.csv","Stripe2_Sa0.35_1col_S.csv",...
    "Stripe3_Sa0.70_1col_S.csv","Stripe4_Sa1.05_1col_S.csv"];
stripes = [0.1,0.35,0.70,1.05];%Not sure how these are input into GUI

for i=1:ns
    disp(filenames(i))
    stripes_edp{i} = readtable(filenames(i));
end

%Load Each EDP into Structure
EDP=table2cell(stripes_edp{1}(:,1));

% Loop through all of the different types of damage fragilities

for i=1:length(EDP)
    for j = 1:ns
    % Find the number DS for each componenet
    a(j,:) = table2array(stripes_edp{j}(i,2:end));
    end
    handles.EDPtype.(EDP{i}) = a;
end