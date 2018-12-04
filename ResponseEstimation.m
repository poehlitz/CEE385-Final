function [handles] = ResponseEstimation(handles)

numberCollapse = zeros (length(handles.stripes),1);
medianEDP = zeros (length(handles.stripes),1);
variationEDP = zeros (length(handles.stripes),1);

for j=1:length(handles.EDPnames)
    for i=1:length(handles.stripes) %Loop Over Stripes
     %Loop over EDP Types and Floors
        a = handles.EDPtype.(handles.EDPnames{j}).GMData(i,:);
        indices = find(isnan(a)==1);
        numberCollapse (i) = length(indices);
        a(indices) = [];
        medianEDP(i) = median(a);
        variationEDP(i) = std(log(a));
    end
    handles.numberCollapse = numberCollapse;
    handles.EDPtype.(handles.EDPnames{j}).medianEDP = medianEDP;
    handles.EDPtype.(handles.EDPnames{j}).variationEDP = variationEDP;
    meanEDP = medianEDP.*exp(0.5*variationEDP.^2);
    handles.EDPtype.(handles.EDPnames{j}).meanEDP = meanEDP;
    handles.EDPtype.(handles.EDPnames{j}).standarddevEDP = meanEDP.*sqrt(exp(variationEDP.^2)-1);
end

for i=1:length(handles.EDPnames)
    %figure
    %plot(handles.stripes,handles.EDPtype.(handles.EDPnames{i}).GMData, 'Color', [0.8 0.8 0.8])
    %hold on
    %plot(handles.stripes,handles.EDPtype.(handles.EDPnames{i}).meanEDP,'LineWidth',3,'Color','r')
    %plot(stripes,medianEDP(:,i),'LineWidth',3,'Color','r')
%     title([(handles.EDPnames{i}), ' v. IM'])
%     ylabel((handles.EDPnames{i}))
%     xlabel('Sa')
%     set(gca, ...
%       'Box'         , 'off'     , ...
%       'TickDir'     , 'out'     , ...
%       'TickLength'  , [.02 .02] , ...
%       'XMinorTick'  , 'on'      , ...
%       'YMinorTick'  , 'on');
end

%Interpolate to median and dispersion of each EDP at each IM

%Calculate Probability of Each EDP at Each IM
%Requires users name EDP by IDR RIDR and PFA
for i=1:length(handles.EDPnames)
    if contains(handles.EDPnames{i},'IDR')
        median_everyEDP = interp1(handles.stripes, handles.EDPtype.(handles.EDPnames{i}).medianEDP, handles.hazardDerivative(1,:)); 
        sig_everyEDP = interp1(handles.stripes, handles.EDPtype.(handles.EDPnames{j}).variationEDP, handles.hazardDerivative(1,:));
        handles.EDPtype.(handles.EDPnames{i}).prob_im = (1./(handles.EDP.IDR.*sig_everyEDP*sqrt(2*pi))).*exp(-((log(handles.EDP.IDR)-log(median_everyEDP)).^2)./(2*(sig_everyEDP.^2)));
        figure
        plot(handles.EDP.IDR,handles.EDPtype.(handles.EDPnames{i}).prob_im)
            title(['Probability Distribution of ',(handles.EDPnames{i})])
        ylabel(['P(',(handles.EDPnames{i}),')'])
        xlabel('Sa')
        set(gca, ...
          'Box'         , 'off'     , ...
          'TickDir'     , 'out'     , ...
          'TickLength'  , [.02 .02] , ...
          'XMinorTick'  , 'on'      , ...
          'YMinorTick'  , 'on');
    elseif contains(handles.EDPnames{i},'RIDR')
        median_everyEDP = interp1(handles.stripes, handles.EDPtype.(handles.EDPnames{i}).medianEDP, handles.EDP.IDR); 
        sig_everyEDP = interp1(handles.stripes, handles.EDPtype.(handles.EDPnames{j}).variationEDP, handles.EDP.IDR);
        handles.EDPtype.(handles.EDPnames{i}).prob_im = (1./(handles.EDP.RIDR.*sig_everyEDP*sqrt(2*pi))).*exp(-((log(handles.EDP.RIDR)-log(median_everyEDP).^2)./(2*(sig_everyEDP.^2))));
                figure
        plot(handles.EDP.IDR,handles.EDPtype.(handles.EDPnames{i}).prob_im)
            title(['Probability Distribution of ',(handles.EDPnames{i})])
        ylabel(['P(',(handles.EDPnames{i}),')'])
        xlabel('Sa')
        set(gca, ...
          'Box'         , 'off'     , ...
          'TickDir'     , 'out'     , ...
          'TickLength'  , [.02 .02] , ...
          'XMinorTick'  , 'on'      , ...
          'YMinorTick'  , 'on');
    elseif contains(handles.EDPnames{i},'PFA')
        median_everyEDP = interp1(handles.stripes, handles.EDPtype.(handles.EDPnames{i}).medianEDP, handles.EDP.IDR); 
        sig_everyEDP = interp1(handles.stripes, handles.EDPtype.(handles.EDPnames{j}).variationEDP, handles.EDP.IDR);
        handles.EDPtype.(handles.EDPnames{i}).prob_im = (1./(handles.EDP.PFA.*sig_everyEDP*sqrt(2*pi))).*exp(-((log(handles.EDP.PFA)-log(median_everyEDP).^2)./(2*(sig_everyEDP.^2))));
        figure
        plot(handles.EDP.IDR,handles.EDPtype.(handles.EDPnames{i}).prob_im)
            title(['Probability Distribution of ',(handles.EDPnames{i})])
        ylabel(['P(',(handles.EDPnames{i}),')'])
        xlabel('Sa')
        set(gca, ...
          'Box'         , 'off'     , ...
          'TickDir'     , 'out'     , ...
          'TickLength'  , [.02 .02] , ...
          'XMinorTick'  , 'on'      , ...
          'YMinorTick'  , 'on');
    else
        disp('error')
    end
end