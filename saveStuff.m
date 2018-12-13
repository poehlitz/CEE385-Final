function saveStuff(app)

[file,path] = uiputfile('*.mat');
filename = fullfile(path, file);

allData = app.handles;
handles = app.handles;

AAL = handles.AAL;
hazardCurve = app.UIAxes2;
collapseCurve = app.UIAxes;
eventProbability = app.UIAxes6;
lossEstimation = app.UIAxes4;

save(filename, 'hazardCurve', 'collapseCurve', 'eventProbability',...
    'lossEstimation', '', 'allData')
end


