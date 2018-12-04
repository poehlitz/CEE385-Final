function [handles] = loadStructure(filename, handles)
% Create the storys vector
num = 1:handles.numStory+1;
storys = cell(length(num), 1);

for i = 1:length(num)
    storys{i, 1} = strcat('Story ', num2str(num(i)));
end
handles.storys = storys;

handles.numStory = 6; %Story input user
handles.numComponents = length(handles.Components);
ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

disp_start_index = strcat('B', num2str(2));
disp_end_index = strcat(ALPHABET(handles.numComponents+1), num2str(2+handles.numStory));
disp_index = strcat(disp_start_index, ':', disp_end_index);

a_start_index = strcat('B', num2str(handles.numStory+5));
a_end_index = strcat(ALPHABET(handles.numComponents+1), num2str(6+2*handles.numStory));
a_index = strcat(a_start_index, ':', a_end_index);

handles.buildingDataIDR = xlsread(filename, disp_index);
handles.buildingDataAcc = xlsread(filename, a_index);

handles.replacementCostPart = xlsread(filename, strcat('F', num2str(11 + 2*handles.numStory), ':F', num2str(11 + 2*handles.numStory)));
handles.demolishionCost = xlsread(filename, strcat('F', num2str(13 + 2*handles.numStory), ':F', num2str(13 + 2*handles.numStory)));
handles.collapseCost = xlsread(filename, strcat('F', num2str(15 + 2*handles.numStory), ':F', num2str(15 + 2*handles.numStory)));

for i = 1:handles.numStory
    handles.(handles.storys{i}).Money = (handles.buildingDataIDR(i, :) ...
                                    + handles.buildingDataAcc(i, :))';
end
end