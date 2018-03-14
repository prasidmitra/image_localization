function word = traverse_tree(root,descriptor,n,d,marker)
    length = n*(n^d-1)/(n-1);
    word =zeros(length,1);
    index = knnsearch(root{1},descriptor,'Distance','cosine');
    word(4*marker+index)=1;
    if iscell(root{2})==1
        word = traverse_tree(root{index+1},descriptor,n,d,4*marker+index);
    end
    return
end