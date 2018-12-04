close all; clear all

%% Load Hazard Curve and Fit a Polynomial in Log-Log Space
load("HazardCurve.txt")

order = '4';
curve = HazardCurve;
interval = [0.2,3];
dSa = 0.01;
[handles] = createPolyFit(order, curve, interval, dSa);

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

[handles] = ResponseEstimation(handles.stripes,handles);

%% Collapse Fragility, MAF, Probability in 50 years
[handles] = CollapseFragility(handles.stripes,n,handles); %Maybe split out functions for MAF and Probability in 50 years

%% Load Fragility and Loss Functions
[handles] = loadComputeDamageFragilities(handles, 'SampleFragilityLossFunctionsS.csv');


%% Load Structure Data into Coding Structure
filename = 'SampleBuildingDataS.csv';
[handles] = LoadStructureData(handles,filename);

%% Compute Loss Given IM for structure
%Function gives expected loss for each damage state
[handles] = ExpectedLossFunction(handles);

%% Probability of Demolition Given No Collapse
demo_RIDR_median = 0.015;
demo_RIDR_dispersion = 0.3;



% expected value of the loss per floor/story as a function of IM
% (i) conditioned on no collapse and nodemolition; (ii) conditioned on no 
% collapse but demolition is necessary and (iii) if collapse occurs

% total expected loss as a function of IM
% expected annual loss
% plot the deaggregation of the expected annual loss