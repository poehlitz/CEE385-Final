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
%It may be better to load a different way, maybe xlsread to give us a cell
%output
%I'm mainly worried about how we know which rows are which EDPs
filenames=["Stripe1_Sa0.10_1col_S.csv","Stripe2_Sa0.35_1col_S.csv",...
    "Stripe3_Sa0.70_1col_S.csv","Stripe4_Sa1.05_1col_S.csv"];
stripes = [0.1,0.35,0.70,1.05];%Not sure how these are input into GUI

for i=1:ns
    disp(filenames(i))
    stripes_edp{i} = csvread(filenames(i),1,1);
end

[handles] = ResponseEstimation(stripes,stripes_edp,handles);

%% Collapse Fragility, MAF, Probability in 50 years
[handles] = CollapseFragility(stripes,n,handles); %Maybe split out functions for MAF and Probability in 50 years

%% Load Fragility and Loss Functions
[handles] = loadComputeDamageFragilities(handles, 'SampleFragilityLossFunctionsS.csv');

%% Compute Loss Given IM for structure

%Function gives expected loss for each damage state
[handles] = ExpectedLossFunction(handles);


% expected value of the loss per floor/story as a function of IM
% (i) conditioned on no collapse and nodemolition; (ii) conditioned on no 
% collapse but demolition is necessary and (iii) if collapse occurs

% total expected loss as a function of IM
% expected annual loss
% plot the deaggregation of the expected annual loss