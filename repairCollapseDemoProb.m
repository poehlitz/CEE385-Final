function handles = repairCollapseDemoProb(handles)

% Add all of the losses for the different story together
handles.Loss_IM = sum(handles.Loss_IM_Story);

% Calculate the 
P_NC = 1 - handles.P_collapse;
handles.P_NC_demo = P_NC .* handles.demo.p_im;
handles.P_NC_repair = P_NC.*(1-handles.demo.p_im);

check = handles.P_collapse + handles.P_NC_demo + handles.P_NC_repair;

handles.demoLoss_IM = handles.P_NC_demo * handles.demolishionCost;
handles.collapseLoss_IM = handles.P_collapse * handles.collapseCost;

handles.ncLoss_IM = handles.P_NC_repair .* handles.Loss_IM;

handles.L_IM = handles.ncLoss_IM + handles.collapseLoss_IM + handles.demoLoss_IM;
Sa = handles.hazardCurve(1,:);

figure
hold on
plot([0,Sa], [0, handles.L_IM], 'm', 'LineWidth', 2)
plot(Sa, handles.ncLoss_IM, '--r')
plot(Sa, handles.collapseLoss_IM, '--g')
plot(Sa, handles.demoLoss_IM, '--b')
xlabel('Sa (g)')
ylabel('E[L|IM] ($)')
title('Expected Loss Given IM')
legend('Total Loss', 'No Collapse, Repair', 'Collapse', 'Demo')
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on');
grid on
hold off