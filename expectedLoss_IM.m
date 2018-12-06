function handles = expectedLoss_IM(handles)

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

end

% Add losses for all components for a given story together
Loss_IM_Story = zeros(handles.numStory, length(handles.hazardCurve(1, :)));
for i = 1:handles.numStory
    Loss_IM_Story(handles.numStory - i + 1, :) = sum(handles.(handles.storys{i}).Loss_IM_comp);
end

handles.Loss_IM_Story = Loss_IM_Story;

end