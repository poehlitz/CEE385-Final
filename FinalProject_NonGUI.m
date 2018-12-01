close all

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
 
%Load in Fragility Function Information
%Note this only works for fragility and loss function that all have the
%same number of damage states, maybe we could improve?

fragility = readtable('SampleFragilityLossFunctionsS.csv');
%[num,txt,raw] = xlsread('SampleFragilityLossFunctionsS.csv') %takes a long
%time but gives an interesting any maybe useful format

nfr = size(fragility,1); %number of fragility curves
nd = (size(fragility,2)-2)/4; %number of damage states, make so can specify 
%different number for each fragility function?

% Probability of Being in Each Damage State Given EDP
% Expected Loss Given Each Damage State

%[handles] = ExpectedLoss(fragility,nfr,nd);
