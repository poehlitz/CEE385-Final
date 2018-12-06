function handles = averageAnnualLoss(handles)

% Combine all individual losses (already weighted based on P_collapse,
% demo, repair) into loss given IM
handles.L_IM = handles.ncLoss_IM + handles.collapseLoss_IM + handles.demoLoss_IM;
deriv = handles.hazardDerivative(2,:);

% Calculate total AAL, and AAL caused by each of the components
handles.AAL = trapz(handles.hazardCurve(1,:), deriv.*handles.L_IM);
AAL_deag_repair = trapz(handles.hazardCurve(1,:), deriv.*handles.ncLoss_IM);
AAL_deag_collapse = trapz(handles.hazardCurve(1,:), deriv.*handles.collapseLoss_IM);
AAL_deag_demo = trapz(handles.hazardCurve(1,:), deriv.*handles.demoLoss_IM);

% Find the ratio
lossRatioRepair = AAL_deag_repair/handles.AAL;
lossRatioCollapse = AAL_deag_collapse/handles.AAL;
lossRatioDemo = AAL_deag_demo/handles.AAL;

% Total ratio
lossRatio = handles.AAL/handles.collapseCost;

% Save to handles for later use, perhaps a display or a graph
handles.ratio.totalLoss = lossRatio;
handles.ratio.Repair = lossRatioRepair;
handles.ratio.Demo = lossRatioDemo;
handles.ratio.Collapse = lossRatioCollapse;

% Display the total AAL
disp('Average Annual Loss:')
disp(handles.AAL)
end