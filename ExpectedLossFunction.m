function [handles] = ExpectedLossFunction(handles)

%Expected Loss Per Damage State
for i = 1:length(handles.Components) %Loop over each component/loss function
    ExpectedLoss = zeros(handles.(handles.Components{i}).NumDS,1);
    for j = 1:handles.(handles.Components{i}).NumDS %loop over each damage state
    ExpectedLoss(j) = handles.(handles.Components{i}).LossParams(j,1).*exp(0.5*handles.(handles.Components{i}).LossParams(j,2).^2);
    end
    handles.(handles.Components{i}).ExpectedLoss = ExpectedLoss;
end

%Expected Loss Per EDP
for i = 1:length(handles.Components) %Loop over each component/loss function
    for j = 1:length(handles.EDP.(handles.(handles.Components{i}).EDPtype)) %loop over each EDP
      ExpectedLoss_EDP(j)=
    end
end