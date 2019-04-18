function [BestCost, TSP] = SA_Two_opt(Location,Nb_Nodes,TSP,TSPCost,Dis,PlotTour,TSPType,SA_Parameters)
% Note that the initial feasible solution is TSP and the corresponding objective function
% value is TSPCost

% the neighborhood structure to use is
% whole neighborhood of TSP, for its best neighbor using Two_Opt move
TSP_Size=Nb_Nodes+1;
if (PlotTour==1)
    I1=  figure (2) ;
    set(I1,'Name',[TSPType '- 2 opt SA' ])
end

Imp=-1;

%Initialize Parameters of SA
I_Temp=SA_Parameters{1};
F_Temp=SA_Parameters{2};
R_T=SA_Parameters{3};
TCF_Criteria=SA_Parameters{4};
Alpha=SA_Parameters{5};
APF_Criteria=SA_Parameters{6};
%Initialize  node1, node2 & node3 to -1
node1=-1;
node2=-1;
%Initialize BestCost to TSPCost
BestCost=TSPCost;
Cost=TSPCost;

Reset_Temp = I_Temp;
%REPEAT until stopping condition = true // e.g., (TSP is a local optimum [BestImp<0] )

while(I_Temp>F_Temp)
    No_Acc = 0; %Set the number of move acceptance at each temperature
    for r=1:R_T
        % Generate a random neighbor of the current neighbor
        i=randi([1 TSP_Size-3]);
        j=randi([i+1 TSP_Size-2]);
        
        
        %Change in the objective function Delta =Z(x0)-Z(x)= (Improvement_in_Cost)
        % 2opt
        Improvement_in_Cost=Dis(TSP(i),TSP(j))+Dis(TSP(i+1), TSP(j+1))-Dis(TSP(i),TSP(i+1))-Dis(TSP(j),TSP(j+1));
        
        
        Imp=round(Improvement_in_Cost,3);
        % if the BestImp is less than zero (i.e. a better neighbor is found
        % that improves the tour by Improvement_in_Cost, update the BestCost
        % and current neighbor TSP
        %if   Delta<0 OR RAND<  Acceptance Probability THEN // Update
        %current seed solution x0
        RND=rand();
        
        switch APF_Criteria
            case 1
                APF=min(1,exp(-Imp/I_Temp));
            case 2
                APF=1/(1+exp(Imp/I_Temp));
        end
        if(RND < APF)
            
            No_Acc = No_Acc+1;
            %update the current tour by performing the move given the
            %i & j
            
            NewTSP=[TSP(1:i) fliplr(TSP(i+1:j)) TSP(j+1:end) ];
            
            TSP=NewTSP;
            Cost=Cost+Imp;
            if(BestCost > Cost)
                BestCost = Cost;
                BestTSP=NewTSP;
                
                % plot the tour
                if (PlotTour)
                    clf
                    %iter=iter+1;
                    
                    hold on
                    set(I1,'Name',[TSPType '- 2 opt LS' ])
                    title(['Cost ' int2str( BestCost )]);
                    scatter(Location(:,1),Location(:,2),'b');
                    
                    % Add node numbers to the plot
                    for l=1:Nb_Nodes
                        str = sprintf(' %d',l);
                        text(Location(l,1),Location(l,2),str);
                    end
                    
                    x = Location(BestTSP(1:end),1);
                    y = Location(BestTSP(1:end),2);
                    
                    % Plot new Tour
                    plot(x,y,'r',x,y,'k.');
                    hold off
                    pause(1);
                end
                
                TSP=BestTSP;
                
            end
            NewTSP = [];
        end
    end
    
    %temperature control function
    switch TCF_Criteria
        case 1
            I_Temp=I_Temp*Alpha;
        case 2
            if No_Acc == 0
                Reset_Temp = Reset_Temp/2;
                if Reset_Temp >= I_Temp
                    I_Temp = Reset_Temp;
                else
                    I_Temp=I_Temp*Alpha;
                end
            else
                I_Temp=I_Temp*Alpha;
            end
    end
end

% end

