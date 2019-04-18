function [TSP_Dist,TSP]= Farthest_Insertion_Heuristics(Nb_Nodes,Distance,Location,Depot,PlotTour,TSPType)

if(PlotTour==true)
    h = figure;
    set(h,'Name',[TSPType    ])
end


%Create a list called 'Unvisited_nodes' that keeps track of the nodes not visited by the salesman (not in P).
Nb_Unvisited_Nodes=Nb_Nodes;
Unvisited_nodes=1:Nb_Nodes;

% Initialize the Total Distance to Zero
TSP_Dist=0;

% remove the depot from the list of unvisited nodes
Unvisited_nodes(Unvisited_nodes==Depot)=[];
Nb_Unvisited_Nodes=Nb_Unvisited_Nodes-1;

% find the  closest nodes to the Depot
[~,nodeindex]=min(Distance(Depot,Unvisited_nodes));
Nodes=Unvisited_nodes(nodeindex);

%create AN OPEN tour, called 'TSP'
TSP=[Depot Nodes];
Tour_size=2;
TSP_Dist=TSP_Dist+Distance(Depot,Nodes);
% if the TSPType is closed TSP
%Join the first and last nodes of the TSP TO obtain a closed TSP tour.
if(isequal(TSPType,'closed'))
    TSP_Dist=TSP_Dist+Distance(TSP(end) ,TSP(1));
    TSP=[TSP TSP(1)];
    Tour_size=3;
    
end
% update the Unvisited_nodes & Nb_Unvisited_Nodes
Unvisited_nodes(nodeindex)=[];
Nb_Unvisited_Nodes=Nb_Unvisited_Nodes-1;
%%%% plot tour
if(PlotTour==true)
    hold on
    % plot the location of nodes
    scatter(Location(:,1),Location(:,2),'b');
    x = Location(TSP(1:Tour_size),1);
    y = Location(TSP(1:Tour_size),2);
    
    % Plot new Tour
    plot(x,y,'r',x,y,'k.');
    hold off
    % pause(5)
end

% while there is a n unvisited node left Do
while(Nb_Unvisited_Nodes>0)
    
    % select the next node to insert based on Insertion Criteria
    % Insertion Criteria = Closest
    if(Nb_Unvisited_Nodes>1)
        Dist_to_TSP=Distance(Unvisited_nodes ,TSP(1,1:Tour_size-1));
        [Distance_To_TSP,i_uninserted]= max(Dist_to_TSP);
        [~,I]=  max(Distance_To_TSP);
        nodeindex=i_uninserted(I);
        Nodes=Unvisited_nodes(nodeindex);
    else
        Nodes=Unvisited_nodes;
        nodeindex=1;
    end
    
    %calculate insertion cost of the chosen node in the TSP tour
    MinInsertionCost=inf;
    
    for j=1:size(TSP,2)-1
        insertionCost=Distance(TSP(j),Nodes)+Distance(TSP(j+1),Nodes)-Distance(TSP(j),TSP(j+1));
        
        if(MinInsertionCost>insertionCost)
            inspos=j+1;
            %inspos=j;
            MinInsertionCost=insertionCost;
        end
        
    end
    
    % insert the node in the best position in the tour
    if(isequal(TSPType,'open'))
        if(MinInsertionCost>Distance(TSP(Tour_size),Nodes))
            TSP=[TSP Nodes];
        else
            TSP=InserColumntInArray(TSP,inspos,Nodes);
        end
    else
        TSP=InserColumntInArray(TSP,inspos,Nodes);
        TSP_Dist = TSP_Dist + MinInsertionCost;
    end
    
    Unvisited_nodes(nodeindex)=[];
    Nb_Unvisited_Nodes=Nb_Unvisited_Nodes-1;
    
    Tour_size=Tour_size+1;
    if(PlotTour==true)
        clf
        hold on
        % plot the location of nodes
        scatter(Location(:,1),Location(:,2),'b');
        x = Location(TSP(1:Tour_size),1);
        y = Location(TSP(1:Tour_size),2);
        
        % Plot new Tour
        plot(x,y,'r',x,y,'k.');
        hold off
        % pause(5)
    end
    
end
