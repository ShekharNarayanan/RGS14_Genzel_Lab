function [In, pl] = ClusterPointsBoundaryOutBW_mod(Data, ECells, ICells,m,b,C1,C2)
% function [In,pl] = ClusterPointsBoundaryOut(Data, IfPlot,nClusters)
%% Changes in the mod: Input takes in data from two clusters and now the function can plot units with colour coding
% --Rest is from Anton's 'ClusterPoints.m'
%   The only difference is that you can also output the boundary information (pl)
%
% Data is two column matrix of coordinates, IfPlot =1 if you want Data to
% be ploted by this function (0, if they are plotter already in current
% axes).
% ECells and ICells are lists of E or I cells (ie by synaptic
% interactions).  They may be empty.
% m & b are slope and intersect of separatrix
%
% starts clustering manual interface like in klusters
% - left click - new line
%   right click - one back
%   middle click - close the polygon.
%% Changes in the mod: Input takes in data from two clusters and now the function can plot units with colour coding
% don't click too fast -it wrongly interprets double click I guess.
%  returns In - binary vector where ones corresopond to caught fish :))

hold on
plot(C1(:,1),C1(:,2),'k.','MarkerSize', 20);
plot(C1(:,1), C1(:,2),'k.','MarkerSize', 20);
plot(C2(:,1), C2(:,2),'r.','MarkerSize', 20);
plot(C2(:,1), C2(:,2),'r.','MarkerSize', 20);
%scatterplot(Data_2(:,1), Data_2(:,2),20,'r','.')
text(1.9,1.8,'RGS14','Color','red','FontSize',24)
text(1.9,1.6,'VEHICLE','Color','black','FontSize',24)
if ~isempty(ECells)
    plot(Data(ECells,1),Data(ECells,2),'.','color',[.2 .8 .2],'markersize',50000)
end
if ~isempty(ICells)
    plot(Data(ICells,1),Data(ICells,2),'.r','markersize',50000)
end
xlim([0 max([Data(:,1)+0.1;2])])
ylim([0 max([Data(:,2)+0.1;2])])
xb = get(gca,'XLim');
yb = get(gca,'YLim');
plot(xb,[m*xb(1)+b m*xb(2)+b])
xlim(xb)
ylim(yb)

% for nc=1:nClusters
linepos=1;
pl=[];%matrix of polyline coords
h_lastline=[];

    zoomoff = 1;
    while 1
        [x y button]=PointInput(1);
        res = button*zoomoff;  
        title({'Discriminate pyr and int (select Pyramidal)',...
            'left click to draw boundary',...
            'center click/ENTER to complete)'});


        switch res
            case 1 % left button
                pl(linepos,:)=[x y];
                if linepos>1
                    h_lastline(end+1) = line([pl(linepos-1,1),pl(linepos,1)],[pl(linepos-1,2),pl(linepos,2)]);
                    set(h_lastline(end),'Color','k');
                end;
                linepos=linepos+1;
%             case 2% middle button
            case 3% right button
                if linepos>2
                    pl(linepos,:)=pl(1,:);
                    h_lastline(end+1) = line([pl(linepos-1,1),pl(linepos,1)],[pl(linepos-1,2),pl(linepos,2)]);
                    set(h_lastline(end),'Color','k');
                    break;
                end
%             case 3 %right button
%                 if linepos>2
%                     linepos=linepos-1;
%                     delete(h_lastline(end));
%                     h_lastline(end)=[];
%                     pl(end,:)=[];
% 
%                 end;

            case 0 %pressed a key or iz in zoom state
                curchar = get(gcf,'CurrentCharacter');
                if button==0 & strcmp(curchar,'z')
                    zoomoff= ~zoomoff;
                    continue
                end
                if ~zoomoff
                    switch button
                        case 1
                            zoom(1.5);
                        case 3
                            zoom(0.5);      title('Discriminate pyr and int (select Pyramidal)');

                    end
                end
            otherwise
                fprintf('uups\n');
        end
    end
%     if nClusters==1
        In = inpolygon(Data(:,1), Data(:,2), pl(:,1),pl(:,2));
%     else
%         In(inpolygon(Data(:,1), Data(:,2), pl(:,1),pl(:,2))) = nc;
%     end

% end



if nargout<1
    plot(Data(In,1),Data(In,2),'r*');
end


hold off;