function [handles] = createPolyFit(order, curve)
% Order must be defined in GUI, either 3 or 4, remember str2num
% Remember that curve must bew defined by user via file

order = str2num(order);
loadedHazardCurve = load(curve);

% Not sure how hazard curve is loaded in, assuming that each will be a row
% in a loaded in vector, change if necessary
LoadedSa = loadedHazardCurve(1,:);
LoadedMAF = loadedHazardCurve(2,:);

% Use loaded and MAF to interpolate
Sa_logspace = logspace(log10(LoadedSa), log10(Sa_hazard(length(Sa_hazard)-1)), 1000);
MAF_logspace = exp(interp1(log(LoadedSa), log(LoadedMAF), log(Sa_logspace)));

if order == 4
    [p, ~] = polyfit(log(Sa_logspace),log(MAF_interpolated), 4);
    
    regularpoly = exp(p(5)+p(4)*log(Sa_logspace)+p(3)*log(Sa_logspace).^2+p(2)*log(Sa_logspace).^3+p(1)*log(Sa_logspace).^4);
    
    % Alter to reflect 4th degree of freedom
    derivpoly = abs((p(3)+2*p(2)*log(Sa_logspace)+3*p(1)*log(Sa_logspace)...
        .^2)./Sa_logspace.*exp(p(4)+p(3)*log(Sa_logspace)+p(2)...
        *log(Sa_logspace).^2+p(1)*log(Sa_logspace).^3));
    
elseif order == 3
    [p, ~] = polyfit(log(Sa_logspace),log(MAF_interpolated), 3);
    
    regularpoly = exp(p(4)+p(3)*log(Sa_logspace)+p(2)*log(Sa_logspace).^2+...
        p(1)*log(Sa_logspace).^3);
    
    derivpoly = abs((p(3)+2*p(2)*log(Sa_logspace)+3*p(1)*log(Sa_logspace)...
        .^2)./Sa_logspace.*exp(p(4)+p(3)*log(Sa_logspace)+p(2)*...
        log(Sa_logspace).^2+p(1)*log(Sa_logspace).^3));

end
    
    
SST = sum((MAF_logspace - mean(MAF_logspace)).^2);
SSR = sum((MAF_interpolated - regularpoly).^2);
R_squared = 1-SSR/SST;

handles.hazardDerivative = [Sa; derivpoly];
handles.hazardCurve =  [Sa_logspace; regularpoly];

str1=['Curve: ',num2str(p(4)),' + ',num2str(p(3)),'x + ',num2str(p(2)),'x^2 + ',num2str(p(1)), 'x^3 ' newline 'R^2 = ', num2str(R_squared)];

figure
loglog(LoadedSa, LoadedMAF, Sa_logspace, regularpoly)
title('Seismic Hazard Curve')
xlabel('Sa')
ylabel('Mean Annual Frequency')
legend('Hazard Curve','Polyfit')
xlim([Sa_logspace(1),Sa_logspace(end)])
set(gca, ...
  'Box'         , 'off'     , ...
  'TickDir'     , 'out'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on');
t=text(.0015, min(Loaded_MAF), str1);
t.FontSize = 10;
t.BackgroundColor = 'w';
t.EdgeColor = 'k';
grid on
end



