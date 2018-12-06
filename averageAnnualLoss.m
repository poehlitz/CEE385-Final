function handles = averageAnnualLoss(handles)

handles.L_IM = handles.ncLoss_IM + handles.collapseLoss_IM + handles.demoLoss_IM;
Sa = handles.hazardCurve(1,:);

handles.AAL = trapz(handles.hazardCurve(1,:), handles.hazardDerivative(2,:).*handles.L_IM);
AAL_deag_repair = trapz(handles.hazardCurve(1,:), handles.hazardDerivative(2,:).*handles.ncLoss_IM);
AAL_deag_collapse = trapz(handles.hazardCurve(1,:), handles.hazardDerivative(2,:).*handles.collapseLoss_IM);
AAL_deag_demo = trapz(handles.hazardCurve(1,:), handles.hazardDerivative(2,:).*handles.demoLoss_IM);

lossRatioRepair = AAL_deag_repair/handles.AAL;
lossRatioCollapse = AAL_deag_collapse/handles.AAL;
lossRatioDemo = AAL_deag_demo/handles.AAL;

lossRatio = handles.AAL/handles.collapseCost;

handles.ratio.totalLoss = lossRatio;
handles.ratio.Repair = lossRatioRepair;
handles.ratio.Demo = lossRatioDemo;
handles.ratio.Collapse = lossRatioCollapse;

disp('Average Annual Loss:')
disp(handles.AAL)
end