%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FileDir='C:\Users\Asus\Desktop\MSc BA\Business Analytics with Heuristics\Exam\Code\data\';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samples_optSolution={
    'eil51' , 426;%$1
    'eil76' , 538;%$2
    'pr76' , 108159;%$3
    'kroA100' , 21282;%$4
    'kroB100' , 22141;%$5
    'kroC100' , 20749;%$6
    'kroD100' , 21294;%$7
    'kroE100' , 22068;%$8
    'eil101' , 629;%$9
    'pr107' , 44303;%$10
    'pr124' , 59030;%$11
    'ch130' , 6110;%$12
    'pr136' , 96772;%$13
    'pr144' , 58537;%$14
    'ch150' , 6528;%$15
    'kroA150' , 26524;%$16
    'kroB150', 26130;%$17
    'pr152' , 73682;%$18
    'kroA200' , 29368;%$19
    'kroB200' , 29437;%$20
    'pr299' , 48191;%$21
    'pr226' , 80369;%$22
    'pr264' , 49135;%$23
    'pr439' , 107217;%$24
    'pr1002' , 259045;%$25
    'u159' , 42080;%$26
    'u574' , 36905;%$27
    'u724' , 41910;%$28
    'u1060' , 224094;%$29
    'u1432' , 152970;%$30
    };

TSPType='closed';
PlotTour=true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Samples only saves the samples name
Samples=samples_optSolution(:,1);

File_No = 1;
FileSet = [9,10,24,27,25,29]; %9,10,24,27,25,29
% run the heursitics for all samples
% s is the sample number
for s=17
    %set sample to Samples{s}
    sample=Samples{s};
    %upload sample
    DataName = [FileDir,sample +'.mat'];
    newData =load(DataName, 'Data','OptSolution');
    
    % set the Location to newData.Data
    Location=newData.Data;
    
    % set the optimal cost of the instance to (Opt_Cost) to newData.OptSolution
    Opt_Cost=newData.OptSolution;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % initialise the distance matrix and number of nodes
    Distance=pdist2(Location,Location);
    Nb_Nodes=size(Distance,1);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % initialise the list nodes of the new problem instance
    % set the distance between each node and itself to inf
    Nodes=zeros(Nb_Nodes,1);
    for i=1:Nb_Nodes
        Distance(i,i)=inf;%%
        Nodes(i,1)=i;
    end
    Depot=1;
    % find a complete tour using a construction heuriustic
    [TSP_Dist,TSP]= Farthest_Insertion_Heuristics(Nb_Nodes,Distance,Location,Depot,PlotTour,TSPType);
    
    % calculate the Percentage Increase of initial tour over the optimal solution ('Inc_over_opt')
    Inc_over_opt_CH(File_No)=round(((TSP_Dist-Opt_Cost)/Opt_Cost)*100,4);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % initialise SA_Param_Range
    InitTemp_Range=[1,20];
    FinalTemp_Range=[0.1,0.5];
    Rt_Range=[10,500];
    TCF_Criterion=[1,2];
    Alpha_Range=[.8,0.99];
    APF_Criterion=[1,2];
    SA_Param_Range={InitTemp_Range,FinalTemp_Range,Rt_Range,TCF_Criterion,Alpha_Range,APF_Criterion};
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Decisions made foe each element of GA
    Crossover=true;
    Mutation=true;
    CrossoverRate=.6;
    MutationRate=0.001;
    
    Population_Size=50;
    %Nb_Evolutions=5;
    SelectionIDX=1; %if 0 random selection, 1: tournament
    TournamentSize = 4;
    
    Replacement='random';
    PP_Size=CrossoverRate*Population_Size;
    Replace_parents_pool=zeros(1,PP_Size);
    parents_pool=zeros(1,PP_Size);
    elitism=.1*Population_Size;
    
    for RUN=1:1 %Run the solution for the file k times
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  Create Initial  Population
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Choose an initial population of M individuals & evaluate the fitness of each individual;
        Evolution_Ind = 0;
        Population = InitializePopulation(Location,Nb_Nodes,TSP,TSP_Dist,Distance,PlotTour,TSPType,Population_Size,SA_Param_Range);
        
        %Initialize the best solution found so far to the best individual;
        BestFitness=Population{1,1};
        BestIndividual=Population{1,2};
        BestTSP=Population{1,3};
        
        % REPEAT until stopping condition = true
        % In this case, Time for Hyperheuristic = 10 Mins
        Total_Time=0;
        while Total_Time <= 600
            NewGeneration={};
            
            %     Produce a new generation
            % IF crossover condition(s) hold THEN // Perform Crossover Operator{
            %    Select a subset of individuals from the current generation as parents for reproduction; // Selection process
            %    Perform a crossover operation on parents to generate children; }
            
            for i=1:(PP_Size/2)
                %select parents based on the chosen selection mechanism
                [P1, P2] = Selection_Mechanism(Population, Population_Size, SelectionIDX, TournamentSize);
                parents_pool(2*i-1:2*i)=[P1,P2];
            end
            
            tic
            for i=1:(PP_Size/2)
                
                if(Crossover)
                    try
                        P1= parents_pool(2*i-1);
                        P2= parents_pool(2*i);
                        
                        Parent1=Population{P1,2};
                        Parent2=Population{P2,2};
                        
                        % perform crossover (2 parents 1 child)
                        [Child1, Child2]=Modified_CrossOver(Parent1, Parent2);
                        
                        % Evaluate the fitness of each child
                        [Child1_Fitness, Child1_TSP]=SA_Two_opt(Location,Nb_Nodes,TSP,TSP_Dist,Distance,PlotTour,TSPType,Child1);
                        [Child2_Fitness, Child2_TSP]=SA_Two_opt(Location,Nb_Nodes,TSP,TSP_Dist,Distance,PlotTour,TSPType,Child2);
                        
                        NewGeneration(end+1,:)={Child1_Fitness, Child1, Child1_TSP};
                        NewGeneration(end+1,:)={Child1_Fitness, Child2, Child1_TSP};
                        
                        
                    catch ME
                        display(ME)
                        display(ME.stack(1))
                    end
                    
                    % IF mutation condition(s) hold THEN // Perform Mutation Operator{
                    % Select a subset of individuals from the current generation as parents to mutate; // Selection process
                    % Perform a mutation operation on parents to generate children;}
                    %%%%% Perform mutation %%%%%%%%%%%%%%%%%
                    
                    if(Mutation)
                        try
                            for m=1:2
                                if(rand()<=MutationRate)
                                    parent=NewGeneration{end-m+1,2};
                                    child=parent;
                                    child=Mutation(child);
                                    
                                    [child_Fitness,child_TSP]=SA_Two_opt(Location,Nb_Nodes,TSP,TSP_Dist,Distance,PlotTour,TSPType,child);
                                    if(NewGeneration{end-m+1,1}<BestFitness)
                                        BestFitness=NewGeneration{end-m+1,1};
                                    else
                                        NewGeneration(end-m+1,:)={child_Fitness,child,child_TSP};
                                    end
                                end
                            end
                        catch ME
                            display(ME)
                            display(ME.stack(1))
                        end
                    end
                end
                
                %IF immigration condition(s) hold THEN Perform an immigration operation to generate children;// Immigration Operator
                
            end
            HH_Time = toc;
            
            NG_Size=size(NewGeneration,1);
            
            % Replace a subset of parents in the current population by a subset of
            % the current children to produce a new generation; // Selection of survivors
            
            % delete  parents
            switch Replacement
                case 'worst'
                    Population(end-NG_Size+1:end,:)=[];
                    %CurrPopSize=Population_Size-NG_Size;
                case 'random'
                    % select parents  to delete  based on the chosen selection mechanism
                    % Replace_parents_pool = Replacement_Selection_Mechanism(Population,Population_Size, NG,0,TournomentSize,elitism);
                    Pop_idx=elitism:Population_Size;
                    Pop_Size=Population_Size-elitism;
                    P1_Idx = randperm(Pop_Size);
                    Replace_parents_pool=Pop_idx(P1_Idx(1:PP_Size));
                    
                    Population(Replace_parents_pool,:)=[];
                    %CurrPopSize=Population_Size-NG_Size;
            end
            
            %add the new generation
            Population(end+1:end+NG_Size,:)= NewGeneration;
            [~, Sort_Ind] = sort([Population{:,1}]);
            Sorted_Population = Population(Sort_Ind,:);
            Population = Sorted_Population;
            Sorted_Population = [];
            
            % Update the best solution found so far, if necessary
            if(BestFitness>Population{1,1})
                BestFitness=Population{1,1};
                BestIndividual=Population{1,2};
                BestTSP=Population{1,3};
            end
            
            Total_Time = Total_Time + HH_Time;
            Evolution_Ind = Evolution_Ind + 1;
        end
        
        
        % calculate the Percentage Increase of HyperHeuristics over the optimal solution
        Inc_over_opt_HH(File_No,RUN)=round(((BestFitness-Opt_Cost)/Opt_Cost)*100,4);
        %disp(['Best Improvement: ' num2str(Inc_over_opt_HH) '%']);
        BestSet{File_No,RUN} = BestIndividual;
        Evolution_No(File_No,RUN)= Evolution_Ind;
    end
    Table(File_No,1:4)=[mean(Inc_over_opt_HH(File_No,:)),std(Inc_over_opt_HH(File_No,:)),min(Inc_over_opt_HH(File_No,:)),max(Inc_over_opt_HH(File_No,:))];
        
    File_No = File_No + 1;
end

%output data as excel files

File_name_output=['C:\Users\Asus\Desktop\MSc BA\Business Analytics with Heuristics\Exam\data\output\','Results.xlsx'];
title1={'Instances','% Inc. over Opt.'};
title2={'Mean','Std','Min','Max'};
title3={'Instances','Detailed % Inc. over Opt.'};
title4={'1','2','3','4','5','6','7','8','9','10'};
title5={'Instances','Number of Evolution'};

xlswrite(File_name_output,title1,1,'A1');
xlswrite(File_name_output,samples_optSolution(FileSet,1),1,'A3');
xlswrite(File_name_output,title2,1,'B2');
xlswrite(File_name_output,Table,1,'B3');

xlswrite(File_name_output,title3,2,'A1');
xlswrite(File_name_output,samples_optSolution(FileSet,1),2,'A3');
xlswrite(File_name_output,title4,2,'B2');
xlswrite(File_name_output,Inc_over_opt_HH,2,'B3');

xlswrite(File_name_output,title5,2,'A10');
xlswrite(File_name_output,samples_optSolution(FileSet,1),2,'A12');
xlswrite(File_name_output,title4,2,'B11');
xlswrite(File_name_output,Evolution_No,2,'B12');

title5={'T0','Tf','Rt','TCF','Alpha','APF'};
for n=1:size(FileSet,2)
    xlswrite(File_name_output,samples_optSolution(FileSet(n)),n+2,'A1');
    xlswrite(File_name_output,title5,n+2,'A3');
    for k = 1:RUN
    xlswrite(File_name_output,BestSet{n,k},n+2,['A' num2str(k+3)]);
    end
end