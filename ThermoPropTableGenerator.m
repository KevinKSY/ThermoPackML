%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thermodynamic property tables for combustions gases using Zacharias'
% method. The table generated will have a structure of
%    P  |  T  |  F  |  R  |  h  |  s  |  u  |
%
% For the first trial, the stoichiometric fuel-air ratio (fs) is assumed to
% be 0.0683, which is a typical figure for diesel fuel with C-H ratio of
% 1.8. 
%
% By Kevin Koosup Yum on 20 January 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pRange = (1:1:250)' * 1e5;      %Range of pressure in Pa
TRange = (275:10:3000)';        %Range of temperature in K
FRange = (0:0.01:1.2)';         %Range of fuel-air equivalence ratio
fs = 0.0683;

%% Generate the tables 
m = length(pRange); n = length(TRange); l = length(FRange);
tableRhsu = zeros(m*n*l,8);
idx = 0;
for i = 1:m
    for j = 1:n
        for k = 1:l
            idx = idx + 1;
            tableRhsu(idx,1) = pRange(i);
            tableRhsu(idx,2) = TRange(j);
            tableRhsu(idx,3) = FRange(k);
            [tableRhsu(idx,4), tableRhsu(idx,5), tableRhsu(idx,6), ...
                tableRhsu(idx,7)] = GetThdynCombGasZachV1(tableRhsu(idx,1), ...
                tableRhsu(idx,2), tableRhsu(idx,3), fs);
            tableRhsu(idx,8) = tableRhsu(idx,4) * tableRhsu(idx,2) / tableRhsu(idx,1); 
        end;
    end;
end;

%% Plot the histogram of the outputs, v, h, s, u
figure
subplot(2,2,1)
histogram(tableRhsu(:,8));
xlabel('v (m^3/kg)');
xlim([0 1])
subplot(2,2,2)
histogram(tableRhsu(:,5));
xlabel('h (J/kg)');
subplot(2,2,3)
histogram(tableRhsu(:,6));
xlabel('s (J/kg/K)');
subplot(2,2,4)
histogram(tableRhsu(:,7));
xlabel('u (J/kg');
%% 3d plot for the specific volume
FRef = 1.0;
vLL = 0.01;
vHL = 1.43;
vPlot = tableRhsu(tableRhsu(:,3) == FRef, 8);
pPlot = tableRhsu(tableRhsu(:,3) == FRef, 1);
TPlot = tableRhsu(tableRhsu(:,3) == FRef, 2);
pPlotGrid = reshape(pPlot,[n m]);
TPlotGrid = reshape(TPlot,[n,m]);
vPlotGrid = reshape(vPlot,[n,m]);
figure
subplot(2,1,1)
surface(pPlotGrid,TPlotGrid,vPlotGrid)
xlim([1e5 2e5])
ylim([275 1000])
zlim([vLL, vHL])   % Limit the z for unreasonable pressure temperature relations
title(['Reasonable pressure and temperature combination at v < ' num2str(vHL) ' @ F = ' num2str(FRef)]) 
subplot(2,1,2)
surface(pPlotGrid,TPlotGrid,vPlotGrid)
xlim([50e5 250e5])
ylim([275 1000])
zlim([vLL vHL])   % Limit the z for unreasonable pressure temperature relations
title(['Reasonable pressure and temperature combination at v > ' num2str(vLL) ' @ F = ' num2str(FRef)]) 

%% Data sampling 
% Remove the unreasonable combination of pressure and temperature by
% observing the specific volumes. Remove if it is too large or too small
idx = find(tableRhsu(:,8)<vHL & tableRhsu(:,8)>vLL);
tableRhsuNew = tableRhsu(idx,:);

fid = fopen('tableRhsu.csv','w');
fprintf(fid, 'p,T,F,R,h,s,u,v \n');
fprintf(fid, '%1.5e,%1.5e,%1.5e,%1.5e,%1.5e,%1.5e,%1.5e,%1.5e \n', tableRhsuNew');
fclose(fid);


%% Plot the histogram of the outputs, v, h, s, u for new samples
figure
subplot(2,2,1)
histogram(tableRhsuNew(:,8));
xlabel('v (m^3/kg)');
xlim([0 1]);
subplot(2,2,2)
histogram(tableRhsuNew(:,5));
xlabel('h (J/kg)');
subplot(2,2,3)
histogram(tableRhsuNew(:,6));
xlabel('s (J/kg/K)');
subplot(2,2,4)
histogram(tableRhsuNew(:,7));
xlabel('u (J/kg');
