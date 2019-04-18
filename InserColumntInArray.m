function result=InserColumntInArray(A,C_Idx,ColumnToInsert) 
try
    if(C_Idx>1)
         % Idx column position, can be 1,2 or 3 in this case
        result = [A(:,1:C_Idx-1), ColumnToInsert, A(:,C_Idx:end)];
%         disp(result);
    else
        if(C_Idx==1)
         % Idx column position, can be 1,2 or 3 in this case
            result = [ ColumnToInsert, A(:,C_Idx-1:end)];
%             disp(result);
        end
    end
catch ME

    disp(ME.message);
end
end
