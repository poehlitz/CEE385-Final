function [handles] = ResponseEstimation(stripes,handles)

numberCollapse = zeros (length(stripes),1);
medianEDP = zeros (length(stripes),1);
variationEDP = zeros (length(stripes),1);

for j=1:length(handles.EDPnames)
    for i=1:length(stripes) %Loop Over Stripes
     %Loop over EDP Types and Floors
        a = handles.EDPtype.(handles.EDPnames{j}).GMData(i,:);
        indices = find(isnan(a)==1);
        numberCollapse (i) = length(indices);
        a(indices) = [];
        medianEDP(i) = median(a);
        variationEDP(i) = std(log(a));
    end
    handles.EDPtype.(handles.EDPnames{j}).numberCollapse = numberCollapse;
    handles.EDPtype.(handles.EDPnames{j}).medianEDP = medianEDP;
    handles.EDPtype.(handles.EDPnames{j}).variationEDP = variationEDP;
    meanEDP = medianEDP.*exp(0.5*variationEDP.^2);
    handles.EDPtype.(handles.EDPnames{j}).meanEDP = meanEDP;
    handles.EDPtype.(handles.EDPnames{j}).standarddevEDP = meanEDP.*sqrt(exp(variationEDP.^2)-1);
end

for i=1:length(handles.EDPnames)
    figure
    plot(stripes,handles.EDPtype.(handles.EDPnames{i}).GMData, 'Color', [0.8 0.8 0.8])
    hold on
    plot(stripes,handles.EDPtype.(handles.EDPnames{i}).meanEDP,'LineWidth',3,'Color','r')
    %plot(stripes,medianEDP(:,i),'LineWidth',3,'Color','r')
    title([(handles.EDPnames{i}), ' v. IM'])
    ylabel((handles.EDPnames{i}))
    xlabel('Sa')
    set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.02 .02] , ...
      'XMinorTick'  , 'on'      , ...
      'YMinorTick'  , 'on');
end

end