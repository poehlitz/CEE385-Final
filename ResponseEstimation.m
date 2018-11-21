function [handles] = ResponseEstimation(stripes,stripes_edp)

numberCollapse = zeros (length(stripes),size(stripes_edp,2));
medianEDP = zeros (length(stripes),size(stripes_edp,2));
variationEDP = zeros (length(stripes),size(stripes_edp,2));

for i=1:length(stripes)
    for j=1:size(stripes_edp{1},1)
        a = stripes_edp{i}(j,:);
        indices = isnan(a);
        numberCollapse (i,j) = length(indices);
        a(indices) = [];
        medianEDP(i,j) = median(a);
        variationEDP(i,j) = std(log(a));
    end
end

handles.medianEDP = medianEDP;
handles.variationEDP = variationEDP;

b = zeros (length(stripes),size(stripes_edp{1},2));
for i=1:size(stripes_edp{1},1)
    figure
    b(1,:) = stripes_edp{1}(i,:);
    b(2,:) = stripes_edp{2}(i,:);
    b(3,:) = stripes_edp{3}(i,:);
    b(4,:) = stripes_edp{4}(i,:);
    plot(stripes,b, 'Color', [0.8 0.8 0.8])
    hold on
    plot(stripes,medianEDP(:,i),'LineWidth',3,'Color','r')
    title(['EDP ', num2str(i), ' v. IM'])
    ylabel('Sa')
    xlabel('EDP')
    set(gca, ...
      'Box'         , 'off'     , ...
      'TickDir'     , 'out'     , ...
      'TickLength'  , [.02 .02] , ...
      'XMinorTick'  , 'on'      , ...
      'YMinorTick'  , 'on');
end

end