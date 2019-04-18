function [child] = Mutation(child,SA_Param_Range)

% Randomly choose a parameter to mutate
CP = randi(7);

%
if ismember(CP,[1,2,5]) %I_Temp, F_Temp, Alpha
    child(CP) = SA_Param_Range{CP}(1)+(SA_Param_Range{CP}(2)-SA_Param_Range{CP}(1))*rand;
else
    child(CP) = randi(SA_Param_Range{CP}); 
end