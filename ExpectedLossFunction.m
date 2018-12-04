function [handles] = ExpectedLossFunction(handles)

%Expected Loss Per Damage State
for i = 1:length(handles.Components) %Loop over each component/loss function
    ExpectedLoss_DS = zeros(handles.(handles.Components{i}).NumDS+1,1);
    for j = 1:handles.(handles.Components{i}).NumDS %loop over each damage state
    ExpectedLoss_DS(j+1) = handles.(handles.Components{i}).LossParams(j,1).*exp(0.5*handles.(handles.Components{i}).LossParams(j,2).^2);
    end
    handles.(handles.Components{i}).ExpectedLoss_DS = ExpectedLoss_DS;
end

%Expected Loss each Componenet Per EDP
for i = 1:length(handles.Components) %Loop over each component/loss function
    ExpectedLoss_EDP=zeros(handles.(handles.Components{i}).NumDS+1,length(handles.EDP.(handles.(handles.Components{i}).EDPtype)));
    for j = 1:length(handles.EDP.(handles.(handles.Components{i}).EDPtype)) %loop over each EDP
      ExpectedLoss_EDP(1:handles.(handles.Components{i}).NumDS+1,j) = handles.(handles.Components{i}).P_Damage(:,j).*handles.(handles.Components{i}).ExpectedLoss_DS;
    end
    handles.(handles.Components{i}).ExpectedLoss_EDP = ExpectedLoss_EDP;
end

%Expected Loss Per IM
%Perhaps organize structure similarly to loss/fragility function structure
%Then we can link EDPs more easily