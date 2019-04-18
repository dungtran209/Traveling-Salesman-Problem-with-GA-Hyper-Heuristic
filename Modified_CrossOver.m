function [Child1, Child2] = Modified_CrossOver(Parent1, Parent2)

%Choose 1 crossover point randomly, say CP
CP = randi(7-1);

try
%
Child1 = [Parent1(1:CP) Parent2(CP+1:end)]; 
Child2 = [Parent2(1:CP) Parent1(CP+1:end)]; 

catch ME
        display(ME)
end
end