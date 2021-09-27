%%%Gaussian Mixture Model for Interneuron/Pyramidal Classification

%% Defining the Data (Segment 1)
% clearvars
Cell_classification_test_Shekhar;
Vehicle_Parameters=C1;

RGS_Parameters=C2;

%% Change the variable below to C1(Vehicle) or C2(RGS) and follow the instructions in the code. Run it segment by segment!
C_Chosen=C2;

%% Trying to find the clusters for inter and pyr (Segment 2)
figure(1)
rng(30)

k = 2; % Number of GMM components
options = statset('MaxIter',1000);

Sigma={'false'};
nSigma = numel(Sigma); %% Standard deviation

SharedCovariance={false};

SCtext={'true'};
nSC = numel(SharedCovariance);

d = 500; % Grid length
x1 = linspace(min(C_Chosen(:,1))-2, max(C_Chosen(:,1))+2, d);
x2 = linspace(min(C_Chosen(:,2))-2, max(C_Chosen(:,2))+2, d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];

threshold = sqrt(chi2inv(0.99,2));
count = 1;

%% Fitting the model
Gmfit_RGS=fitgmdist(RGS_Parameters,k,'CovarianceType','diagonal','SharedCovariance',false,'Options',options);
clusterX_RGS=cluster(Gmfit_RGS,RGS_Parameters);

Gmfit = fitgmdist(C_Chosen,k,'CovarianceType','diagonal','SharedCovariance',false,'Options',options);%,'CovarianceType','diagonal', ...'SharedCovariance',false,'Options',options); % Fitted GMM
clusterX = cluster(Gmfit,C_Chosen); % Cluster index

%% Customizing Cluster Labels for Vehicle ; Make more efficient// RUN ONLY FOR VEHICLE

%% Veh Section start
C_Temp=clusterX==1; C_Final=[];
for i=1:length(C_Temp)
    if C_Temp(i)==1
        
        C_Final(i)=2;
    else
        C_Final(i)=1;
        
    end
end
clusterX=C_Final;
%% Veh section end
% 
mahalDist = mahal(Gmfit,X0); % Distance from each grid point to each GMM component
% Draw ellipsoids over each GMM component and show clustering result.
%         subplot(2,2,count);
h1 = gscatter(C_Chosen(:,1),C_Chosen(:,2),clusterX);
hold on
for m = 1:k
    idx = mahalDist(:,m)<=threshold;
    Color = h1(m).Color*0.75 - 0.5*(h1(m).Color - 1);
    h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
    uistack(h2,'bottom');
end

plot(Gmfit.mu(:,1),Gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
% title(strcat("Sigma is = "," ",'full'," ",'and'," ",'SharedCovariance='," ",string(SCtext{1})),'FontSize',8)
title('RGS Units Classification');xlabel('Trough 2 peak delay');ylabel('Wave Width')
legend(h1,{'Pyramidal','Interneurons'})


%% Cluster Analysis (Quest for p-values) (Segment 3)
%Constant RGS

idx_inter_RGS=clusterX_RGS==2;
idx_pyr_RGS=clusterX_RGS==1;

RGS_Pyr=RGS_Parameters(idx_pyr_RGS,:);
RGS_Inter=RGS_Parameters(idx_inter_RGS,:);

% % Variables for VEHICLE  hash out when running RGS
idx_inter=clusterX==1;
idx_pyr=clusterX==2;
Veh_Pyr=C_Chosen(idx_pyr,:);
Veh_Inter=C_Chosen(idx_inter,:);

% Variables for RGS, hashout when running Vehicle
% idx_inter=clusterX==2;
% idx_pyr=clusterX==1;







%% Gaussian Curves Per Cluster
% Pyramidal Cluster
x_axis_pyr=RGS_Pyr(:,1);
y_axis_pyr=RGS_Pyr(:,2);

pyr_rect_x_points=[mean(x_axis_pyr)-2*std(x_axis_pyr) mean(x_axis_pyr)+2*std(x_axis_pyr)];
pyr_rect_y_points=[mean(y_axis_pyr)-2*std(y_axis_pyr) mean(y_axis_pyr)+2*std(y_axis_pyr)];


width_pyr=pyr_rect_x_points(2)-pyr_rect_x_points(1);
height_pyr=pyr_rect_y_points(2)-pyr_rect_y_points(1);


% Interneuron cluster
x_axis_inter=RGS_Inter(:,1);
y_axis_inter=RGS_Inter(:,2);

inter_rect_x_points=[mean(x_axis_inter)-2*std(x_axis_inter) mean(x_axis_inter)+2*std(x_axis_inter)];
inter_rect_y_points=[mean(y_axis_inter)-2*std(y_axis_inter) mean(y_axis_inter)+2*std(y_axis_inter)];

width_inter=inter_rect_x_points(2)-inter_rect_x_points(1);
height_inter=inter_rect_y_points(2)-inter_rect_y_points(1);

figure(5)

h1 = gscatter(C_Chosen(:,1),C_Chosen(:,2),clusterX);
hold on
for m = 1:k
    idx = mahalDist(:,m)<=threshold;
    Color = h1(m).Color*0.75 - 0.5*(h1(m).Color - 1);
    h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
    uistack(h2,'bottom');
end

plot(Gmfit.mu(:,1),Gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
rectangle('Position',[pyr_rect_x_points(1) pyr_rect_y_points(1) width_pyr height_pyr],'EdgeColor','r','LineWidth',2)
rectangle('Position',[inter_rect_x_points(1) inter_rect_y_points(1) width_inter height_inter],'EdgeColor','c','LineWidth',2)

title('RGS Units Classification');xlabel('Trough 2 peak delay');ylabel('Wave Width')
legend(h1,{'Pyramidal','Interneurons'})





hold off;


%% Segment 4
% % RGS inpolygon section: Mute when running for Vehicle
RGS_GMM_2=[];
RGS_Pyr_Units=inpolygon(RGS_Pyr(:,1),RGS_Pyr(:,2),pyr_rect_x_points,pyr_rect_y_points);
RGS_Inter_Units =inpolygon(RGS_Inter(:,1),RGS_Inter(:,2),inter_rect_x_points,inter_rect_y_points);
RGS_pyr_ind=RGS_Pyr_Units==1; RGS_GMM_2.Pyramidal_Cells=Stored_WFM_RGS14(RGS_pyr_ind);
% 

% 

% % Vehicle in polygon section: Mute when running for RGS
% Veh_GMM_2=[];
% Veh_Pyr_Units=inpolygon(Veh_Pyr(:,1),Veh_Pyr(:,2),pyr_rect_x_points,pyr_rect_y_points);
% 
% veh_pyr_ind=Veh_Pyr_Units==1; Veh_GMM_2.Pyramidal_Cells=Stored_WFM_Vehicle(veh_pyr_ind);

% veh_inter_ind=Veh_Inter_Units==2; Veh_GMM_2.Interneurons=Stored_WFM_Vehicle(veh_inter_ind);
% veh_inter_ind=Veh_Inter_Units==2; Veh_GMM.Interneurons=Stored_WFM_Vehicle(veh_inter_ind);


% Veh_Inter_Units =inpolygon(Veh_Inter(:,1),Veh_Inter(:,2),inter_rect_x_points,inter_rect_y_points);


% 
% %% Checking how many units match
% RGS_Before=load('RGS14_GMM.mat').RGS14_GMM;
% Veh_Before=load('Veh_GMM.mat').Veh_GMM;
% 
% RGS_After=load('RGS_GMM_2.mat').RGS_GMM_2;
% Vehicle_after=load('Veh_GMM_2.mat').Veh_GMM_2;
% 
% %% Getting Pyr Units
% RGS_Pyr_Before=RGS_Before.Pyramidal_Cells;
% RGS_Pyr_After=(RGS_After.Pyramidal_Cells)';
% 
% % for id=1:




