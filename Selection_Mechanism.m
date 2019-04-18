function [P1,P2] = Selection_Mechanism(Population,PopulationSize, SelectionIDX,TournamentSize)
try
    Pop_Ind = 1:PopulationSize;
    
    switch SelectionIDX
        
        case 0 %random
            Selected_Parents = randsample(PopulationSize,2);
            P1 = Selected_Parents(1);
            P2 = Selected_Parents(2);
            
        case 1 %Tournament
            % Find the 1st parent
            % Randomly select a number of chromosomes from the current population
            Selected_Index = randsample(Pop_Ind,TournamentSize);
            %Selected_Individuals = Population(Selected_Index,:);
            
            % Select the fittest chromosome from above random sample
            % Because individuals are sorted in the current population in a
            % non-deacreasing order based on their cost
            % So individual with smaller index has lower cost
            %[~,I]= sort([Selected_Individuals{:,1}]);
            [~,I]= sort(Selected_Index);
            P1 = Selected_Index(I(1));
            
            % Find the 2nd parent
            Pop_Ind(P1) = [];
            Selected_Index = randsample(Pop_Ind,TournamentSize);
            [~,I]= sort(Selected_Index);
            P2 = Selected_Index(I(1));
    end
    
catch ME
    display(ME)
end
end