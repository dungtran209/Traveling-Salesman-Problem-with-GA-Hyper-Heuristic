function Population=InitializePopulation(Location,Nb_Nodes,TSP,TSP_Dist,Distance,PlotTour,TSPType,Population_Size,SA_Param_Range)

%initialize the population
Population=cell(1,3);

% generate the individuals
for k = 1:Population_Size
    
    %
    I_Temp=SA_Param_Range{1}(1)+(SA_Param_Range{1}(2)-SA_Param_Range{1}(1))*rand;
    F_Temp=SA_Param_Range{2}(1)+(SA_Param_Range{2}(2)-SA_Param_Range{2}(1))*rand;
    Rt=randi(SA_Param_Range{3});
    TCF_Criteria=randi(SA_Param_Range{4});
    Alpha=SA_Param_Range{5}(1)+(SA_Param_Range{5}(2)-SA_Param_Range{5}(1))*rand;
    APF_Criteria=randi(SA_Param_Range{6});
    
    %
    Population{k,2} = {I_Temp,F_Temp,Rt,TCF_Criteria,Alpha,APF_Criteria};
    [Population{k,1}, Population{k,3}] = SA_Two_opt(Location,Nb_Nodes,TSP,TSP_Dist,Distance,PlotTour,TSPType,Population{k,2});
end

[~, Sort_Ind] = sort([Population{:,1}]);
Sorted_Population = Population(Sort_Ind,:);
Population = Sorted_Population;
Sorted_Population = [];
end