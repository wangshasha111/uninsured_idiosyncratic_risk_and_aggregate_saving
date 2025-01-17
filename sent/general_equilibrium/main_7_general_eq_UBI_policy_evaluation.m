clear

%% Question 3.3.3 Policy Evaluation
% What happens to macroeconomic aggregates (Y; K; C), to equilibrium prices (w; r) 
% and the equilibrium distributions for earnings (1 -��)wyl, income (1 - ��)wyl + ra, assets a
% and consumption c.

% For the distributions, you may want to calculate Gini coefficients
% or if possible, plot the Lorenz curves, under the two different specifications. 

% Is UBI welfare-improving? To answer this question you may want to compare the
% value functions v(a; y) under the two policies for some combinations of (a; y);
% or aggregate (utilitarian) social welfare

load('withoutUBI.mat')

vWage = zeros(1,2);
vRate = zeros(1,2);
vAggY = zeros(1,2);
vAggK = zeros(1,2);
vAggConsumption = zeros(1,2);
vAggValue = zeros(1,2);

vDistribution = zeros(nGridShocks*nAssets,2);
vIndEarnings = zeros(nGridShocks*nAssets,2);
vIndIncome = zeros(nGridShocks*nAssets,2);
vIndAsset = zeros(nGridShocks*nAssets,2);
vIndConsumption = zeros(nGridShocks*nAssets,2);
vIndValue = zeros(nGridShocks*nAssets,2);

vGiniCoefficientsEarnings = zeros(1,2);
vGiniCoefficientsIncome = zeros(1,2);
vGiniCoefficientsAssets = zeros(1,2);
vGiniCoefficientsConsumption = zeros(1,2);
vGiniCoefficientsValue = zeros(1,2);

%========================================

vDistribution(:,1) = vStationaryDistribution;

vWage(1) = wage;
vRate(1) = r;
vAggK(1) = capitalSupply;
vAggY(1) = capitalSupply^aalphaK * laborSupplyEffective^(1-aalphaK);

vConsumption = mConsumptionPolicy(:);
vAggConsumption(1) = vStationaryDistribution' * vConsumption;

vValue = mValue(:);
vAggValue(1) = vStationaryDistribution' * vValue;


mIndEarnings = mLaborPolicy.*vIncomeShocks';
mIndIncome = mIndEarnings + r * vGridAsset;
mIndAsset = repmat(vGridAsset,1,nGridShocks);
vIndEarnings(:,1) = mIndEarnings(:);
vIndIncome(:,1) = mIndIncome(:);
vIndAsset(:,1) = mIndAsset(:);
vIndConsumption(:,1) = vConsumption;
vIndValue(:,1)=mValue(:);
% vGiniCoefficients(1) = % to be calculated

%==========================================
load('withUBI.mat')
vDistribution(:,2) = vStationaryDistribution;

vWage(2) = wage;
vRate(2) = r;
vAggK(2) = capitalSupply;
vAggY(2) = capitalSupply^aalphaK * laborSupplyEffective^(1-aalphaK);

vConsumption = mConsumptionPolicy(:);
vAggConsumption(2) = vStationaryDistribution' * vConsumption;

vValue = mValue(:);
vAggValue(2) = vStationaryDistribution' * vValue;

mIndEarnings = (1-ttao) * mLaborPolicy.*vIncomeShocks';
mIndIncome = mIndEarnings + r * vGridAsset;
mIndAsset = repmat(vGridAsset,1,nGridShocks);

vIndEarnings(:,2) = mIndEarnings(:);
vIndIncome(:,2) = mIndIncome(:);
vIndAsset(:,2) = mIndAsset(:);
vIndConsumption(:,2) = vConsumption;
vIndValue(:,2)=mValue(:);

% vGiniCoefficients(2) = % to be calculated
%% Inequality Figures
figure
subplot(1,2,1)
vGiniCoefficientsEarnings(1) = giniFunction(vDistribution(:,1),vIndEarnings(:,1),true); % Copyright (c) 2010, Yvan Lengwiler
xlabel('share of earnings without UBI');
subplot(1,2,2)
vGiniCoefficientsEarnings(2) = giniFunction(vDistribution(:,2),vIndEarnings(:,2),true); % Copyright (c) 2010, Yvan Lengwiler
xlabel('share of earnings with UBI');
savefig('giniEarnings')
save('giniEarnings.png')


figure
subplot(1,2,1)
vGiniCoefficientsIncome(1) = giniFunction(vDistribution(:,1),vIndIncome(:,1) ,true); % Copyright (c) 2010, Yvan Lengwiler
xlabel('share of income without UBI');
subplot(1,2,2)
vGiniCoefficientsIncome(2) = giniFunction(vDistribution(:,2),vIndIncome(:,2) ,true); % Copyright (c) 2010, Yvan Lengwiler
xlabel('share of income with UBI');
savefig('giniIncome')
save('giniIncome.png')

figure
subplot(1,2,1)
vGiniCoefficientsAssets(1) = giniFunction(vDistribution(:,1),vIndAsset(:,1),true) ;% Copyright (c) 2010, Yvan Lengwiler
xlabel('share of assets without UBI');
subplot(1,2,2)
vGiniCoefficientsAssets(2) = giniFunction(vDistribution(:,2),vIndAsset(:,2),true); % Copyright (c) 2010, Yvan Lengwiler
xlabel('share of assets with UBI');
savefig('giniAssets')
save('giniAssets.png')

figure
subplot(1,2,1)
vGiniCoefficientsConsumption(1) = giniFunction(vDistribution(:,1),max(0,vIndConsumption(:,1)) ,true) ;% Copyright (c) 2010, Yvan Lengwiler
xlabel('share of consumption without UBI');
subplot(1,2,2)
vGiniCoefficientsConsumption(2) = giniFunction(vDistribution(:,2),max(vIndConsumption(:,2) ,0),true) ;% Copyright (c) 2010, Yvan Lengwiler
xlabel('share of consumption with UBI');
savefig('giniConsumption')
save('giniConsumption.png')

figure
subplot(1,2,1)
vGiniCoefficientsValue(1) = giniFunction(vDistribution(:,1),exp(vIndValue(:,1)),true) ;% Copyright (c) 2010, Yvan Lengwiler
xlabel('share of value exponent without UBI');
subplot(1,2,2)
vGiniCoefficientsValue(2) = giniFunction(vDistribution(:,2),exp(vIndValue(:,2)),true); % Copyright (c) 2010, Yvan Lengwiler
xlabel('share of value exponent with UBI');
savefig('giniExpValue')
save('giniExpValue.png')

table(vWage,vRate)
table(vAggY,vAggK,vAggConsumption,vAggValue)
table(vGiniCoefficientsEarnings,vGiniCoefficientsIncome,vGiniCoefficientsAssets,vGiniCoefficientsConsumption)
table(vGiniCoefficientsValue)


%% simulation
nSimulations = 5000; % number of simulated paths M
nPeriods = 120; % number of periods in one simulation

load('withoutUBI.mat')

mShocksIndexSimulation= ash_panelFunction(mTransition,nSimulations,nPeriods,nGridShocks)'; % nPeriods by nSimulations
mAssetIndexSimulation = ones(nPeriods,nSimulations); % Note this is an index matrix, so start with 1
mConsumptionSimulation = zeros(nPeriods,nSimulations);
mValueSimulation = zeros(nPeriods,nSimulations);

for iSimulations = 1 : nSimulations
    iAsset = 1;
    for iPeriods = 1 : nPeriods
        iShocks = mShocksIndexSimulation(iPeriods,iSimulations);
        mAssetIndexSimulation(iPeriods+1,iSimulations) = mAssetPolicyIndex(iAsset,iShocks);
        mConsumptionSimulation(iPeriods,iSimulations) = mConsumptionPolicy(iAsset,iShocks);
        mValueSimulation(iPeriods,iSimulations) = mValue(iAsset,iShocks);
        iAsset = mAssetPolicyIndex(iAsset,iShocks);
        
    end
end

mAssetIndexSimulation = mAssetIndexSimulation(1:nPeriods,:);

save('withoutUBI')

load('withUBI.mat')

mShocksIndexSimulation= ash_panelFunction(mTransition,nSimulations,nPeriods,nGridShocks)'; % nPeriods by nSimulations
mAssetIndexSimulation = ones(nPeriods,nSimulations); % Note this is an index matrix, so start with 1
mConsumptionSimulation = zeros(nPeriods,nSimulations);
mValueSimulation = zeros(nPeriods,nSimulations);

for iSimulations = 1 : nSimulations
    iAsset = 1;
    for iPeriods = 1 : nPeriods
        iShocks = mShocksIndexSimulation(iPeriods,iSimulations);
        mAssetIndexSimulation(iPeriods+1,iSimulations) = mAssetPolicyIndex(iAsset,iShocks);
        mConsumptionSimulation(iPeriods,iSimulations) = mConsumptionPolicy(iAsset,iShocks);
        mValueSimulation(iPeriods,iSimulations) = mValue(iAsset,iShocks);
        iAsset = mAssetPolicyIndex(iAsset,iShocks);
        
    end
end

mAssetIndexSimulation = mAssetIndexSimulation(1:nPeriods,:);

save('withUBI.mat')

figure
load('withoutUBI.mat')
[assetasset,shockshock]=meshgrid(vGridAsset, vIncomeShocks);
plot(1:nPeriods,mean(mValueSimulation,2),'b')
xlim([1,nPeriods]);
xlabel('T')
ylabel('c')

load('withUBI.mat')
hold on
plot(1:nPeriods,mean(mValueSimulation,2),'r')
xlim([1,nPeriods]);
title('Value - UBI')
xlabel('T')
ylabel('Value')

legend('without UBI','with UBI','location','northwest')
savefig('valueUBI_simulation_infinite_horizon')
save('valueUBI_simulation_infinite_horizon.png')

%% welfare analysis

figure
load('withoutUBI.mat')
plot(vGridAsset,mValue,'b')
hold on
load('withUBI.mat')
plot(vGridAsset,mValue,'r')
xlabel('Assets')
ylabel('Value')
title('Value under different shocks - without UBI (blue) and with UBI (red)')
savefig('valueUBI_by_asset')
save('valueUBI_by_asset.jpg')

figure
load('withoutUBI.mat')
plot(log(vIncomeShocks),mValue','b')
hold on
load('withUBI.mat')
plot(log(vIncomeShocks),mValue','r')
xlabel('log income')
ylabel('Value')
title('Value given different assets - without UBI (blue) and with UBI (red)')
savefig('valueUBI_by_income_shocks')
save('valueUBI_by_income_shocks.jpg')



save('evaluationUBI')