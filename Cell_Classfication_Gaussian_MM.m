%%%Gaussian Mixture Model for Interneuron/Pyramidal Classification

%% Defining the Data
clearvars
Cell_classification_test_Shekhar;
Vehicle_Parameters=C1;

RGS_Parameters=C2;
size=size(RGS_Parameters,1);
% Distributions=[Vehicle_Parameters; RGS_Parameters];

%% Fitting the Distribution
GMModel = fitgmdist(RGS_Parameters,2);%% 2 Components: Wave Width and Trough to Peak Delay
% 
% figure
% % y = [zeros(134,1);ones(135,1)];
% h = gscatter(RGS_Parameters(:,1),RGS_Parameters(:,2));%,y);
% % scatter(RGS_Parameters(:,1),RGS_Parameters(:,2),'r','filled');
% xlabel('Time to Peak Delay');ylabel('Wave Width'); title('RGS Treatment')

%% Trying to find the clusters for inter and pyr
rng default;
k = 2; % Number of GMM components
options = statset('MaxIter',50);

Sigma = {'diagonal','full'}; % Options for covariance matrix type
% Sigma={'diagonal'};
nSigma = numel(Sigma); %% Standard deviation

SharedCovariance = {true,false}; % Indicator for identical or nonidentical covariance matrices
% SharedCovariance={false};
SCtext = {'true','false'};
% SCtext={'false'};
nSC = numel(SharedCovariance);

d = 500; % Grid length
x1 = linspace(min(C1(:,1))-2, max(C1(:,1))+2, d);
x2 = linspace(min(C1(:,2))-2, max(C1(:,2))+2, d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];

threshold = sqrt(chi2inv(0.99,2));  
count = 1;
ranges=[];
for i = 1:nSigma
    for j = 1:nSC
        ranges=[ranges,{rng}];
        gmfit = fitgmdist(C1,k,'CovarianceType',Sigma{i}, ...
            'SharedCovariance',SharedCovariance{j},'Options',options); % Fitted GMM
        clusterC1 = cluster(gmfit,C1); % Cluster index 
        mahalDist = mahal(gmfit,X0); % Distance from each grid point to each GMM component
        % Draw ellipsoids over each GMM component and show clustering result.
        figure(1)
        subplot(2,2,count);
        
        h1 = gscatter(C1(:,1),C1(:,2),clusterC1);
        hold on
            for m = 1:k
                idx = mahalDist(:,m)<=threshold;
                Color = h1(m).Color*0.75 - 0.5*(h1(m).Color - 1);
                h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
                uistack(h2,'bottom');
            end    
        plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
        title(sprintf('Sigma is %s\nSharedCovariance = %s',Sigma{i},SCtext{j}),'FontSize',8)
        xlabel('Trough 2 peak delay');ylabel('Wave Width')
        legend(h1,{'Pyramidal','Interneurons'})
        hold off
        count = count + 1;
    end
end
P = posterior(gmfit,C1);