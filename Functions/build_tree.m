
function root=build_tree(root,matrix,no_of_clusters,depth,max_depth)
    [IDX, root{1}] = kmeans(matrix,no_of_clusters);
    for i= 2:no_of_clusters+1
        if depth == max_depth
            root{i} = -1;
        else    
            root{i}=cell(1,no_of_clusters+1);
            root{i}=build_tree(root{i},matrix(IDX(:,1)==i-1,:),no_of_clusters,depth+1,max_depth);
        end
    end
    return
end
