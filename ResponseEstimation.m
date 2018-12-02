function [handles] = ResponseEstimation(stripes,stripes_edp,handles)

numberCollapse = zeros (length(stripes),1);
medianEDP = zeros (length(stripes),size(stripes_edp,2));
variationEDP = zeros (length(stripes),size(stripes_edp,2));

for i=1:length(stripes)
    for j=1:size(stripes_edp{1},1)
        a = stripes_edp{i}(j,:);
        indices = find(isnan(a)==1);
        numberCollapse (i) = length(indices);
        a(indices) = [];
        medianEDP(i,j) = median(a);
        variationEDP(i,j) = std(log(a));
    end
end

handles.numberCollapse = numberCollapse;
handles.medianEDP = medianEDP;
handles.variationEDP = variationEDP;

meanEDP = medianEDP.*exp(0.5*variationEDP.^2);
standarddevEDP = meanEDP.*sqrt(exp(variationEDP.^2)-1);

b = zeros (length(stripes),size(stripes_edp{1},2));
for i=1:size(stripes_edp{1},1)
    figure
    b(1,:) = stripes_edp{1}(i,:);
    b(2,:) = stripes_edp{2}(i,:);
    b(3,:) = stripes_edp{3}(i,:);
    b(4,:) = stripes_edp{4}(i,:);
    plot(stripes,b, 'Color', [0.8 0.8 0.8])
    hold on
    plot(stripes,meanEDP(:,i),stripes,meanEDP(:,i)+standarddevEDP(:,i),stripes,meanEDP(:,i)-standarddevEDP(:,i),'LineWidth',3,'Color','r')
    %plot(stripes,medianEDP(:,i),'LineWidth',3,'Color','r')
    title(['EDP ', num2str(i), ' v. IM'])
    ylabel('EDP')
    xlabel('Sa')
    set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.02 .02] , ...
      'XMinorTick'  , 'on'      , ...
      'YMinorTick'  , 'on');
end

end