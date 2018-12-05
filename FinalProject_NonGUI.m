close all; clear all;
%% Load Hazard Curve and Fit a Polynomial in Log-Log Space
load("HazardCurve.txt")

order = '4';
curve = HazardCurve;
interval = [0.03,3];
dSa = 0.01;
[handles] = createPolyFit(order, curve, interval, dSa);

%% Initialize Variables for Integration
% This wasn't established in earlier code, but maybe it needs to be an
% input to the GUI?
%Should we do anything about fact that if the range includes zero we get a
%Nan
handles.EDP.IDR = 0.0001:.0001:.1;
handles.EDP.PFA = 0.01:.01:4.0;
handles.EDP.RIDR = 0.0001:.0001:.08;

%% Input and Plot Stripe Analysis Results

%GUI Inputs
nf = 6; %Number of Floors
ns = 4; %Number of Stripes
nedp = 3; %Number of EDPs
n = 30; %Number of Groundmotions

%Load Stripes Values from .csv - offset data by one to only get numeric
%data
%Maybe we could structure this similar to how we structured the fragility
%and loss functions
filenames=["Stripe1_Sa0.10_1col_S.csv","Stripe2_Sa0.35_1col_S.csv",...
    "Stripe3_Sa0.70_1col_S.csv","Stripe4_Sa1.05_1col_S.csv"];
handles.stripes = [0.1,0.35,0.70,1.05];%Not sure how these are input into GUI

[handles] = LoadStripeData(handles, filenames,ns);

[handles] = ResponseEstimation(handles);

%% Collapse Fragility, MAF, Probability in 50 years
[handles] = CollapseFragility(n,handles); %Maybe split out functions for MAF and Probability in 50 years

%% Load Fragility and Loss Functions
[handles] = loadComputeDamageFragilities(handles, 'SampleFragilityLossFunctionsS.csv');


%% Load Structure Data into Coding Structure
filename = 'SampleBuildingDataS.csv';
[handles] = LoadStructureData(handles,filename);

%% Compute Loss Given IM for structure
%Function gives expected loss for each damage state
filename = 'SampleBuildingDataS.csv';
handles.numStory = 6; % Need to find this somehow!
handles = loadStructure(filename, handles);
[handles] = ExpectedLossFunction(handles);

%% Probability of Demolition Given No Collapse

%Enter in GUI
handles.demo.RIDR_median = 0.015; % User input here
handles.demo.RIDR_dispersion = 0.3; % User input here
[handles] = ExpectedLoss(handles);

%% Create the Expected Loss given EDP over all damage states
for j = 1:handles.numComponents
%     EL_EDP_1comp = sum(handles.(handles.Components{j}).P_Damage.* ...
%         handles.(handles.Components{j}).ExpectedLoss_EDP);
    EL_EDP_1comp = sum(handles.(handles.Components{j}).ExpectedLoss_EDP);
    handles.(handles.Components{j}).EL_EDP_Component = EL_EDP_1comp;
    for i = 1:handles.numStory % Not sure here about story numbering
        handles.(handles.Components{j}).EL_EDP_Story(i, :) = EL_EDP_1comp * handles.(handles.storys{i}).NumComp(j);
    end
end

% TBD
%% Find expected loss given IM
Sa = handles.hazardDerivative(1,:);
deriv = handles.hazardDerivative(2,:);

for j = 1:handles.numComponents
    for i = 1:handles.numStory
        for k = 1:length(handles.hazardDerivative(1,:))
            index = strcat(handles.(handles.Components{j}).EDPtype, num2str(handles.numStory - i + 1));
            if ismember(index, fieldnames(handles.EDPtype)) == 1
                EDP = handles.(handles.Components{j}).EDP;
                PDF = handles.EDPtype.(index).pdf_edp_im(:, k)';
                EL_EDP = handles.(handles.Components{j}).EL_EDP_Story(i, :);
                handles.(handles.storys{i}).Loss_IM_comp(j, k) = trapz(EDP, PDF.*EL_EDP);
            else
                handles.(handles.storys{i}).Loss_IM_comp(j, k) = 0;
            end
        end
    end
    handles.(handles.storys{i}).Loss_IM = sum(handles.(handles.storys{i}).Loss_IM_comp);
end

% figure
% plot(handles.hazardCurve(1,:), handles.Story1.Loss_IM)
% title('Loss Test')

handles.totalLoss_NCIM = zeros(1, length(handles.hazardDerivative(1,:)));
for j = 1:numStory
    handles.totalLoss_NCIM = handles.totalLoss_NCIM + handles.(handles.story{i}).Loss_IM;
end

% Have P_collapse
P_collapse = handles.P_collapse;

P_NC_demo = 1 - P_collapse;
P_demo = P_NC_demo * fragility.Demo;
P_NC = P_NC_demo - P_demo;


% Need P_demo

% Derive P_NC
% P_NC = 1-P_demo?





        
        
% expected value of the loss per floor/story as a function of IM
% (i) conditioned on no collapse and nodemolition; (ii) conditioned on no 
% collapse but demolition is necessary and (iii) if collapse occurs

% total expected loss as a function of IM
% expected annual loss
% plot the deaggregation of the expected annual loss