descriptor_matrix = [];
image_index = [];
index=1;
for prefix = 0:53
    if prefix == 7 || prefix == 25 || prefix == 44 || prefix == 45
        continue
    end
    for suffix = 1:4
        image_name = [num2str(prefix),'_',num2str(suffix),'.png'];
        [image, descriptors,locs] = sift(image_name);
        descriptor_matrix = vertcat(descriptor_matrix,descriptors); %stored in project folder
        [m, n] = size(descriptors);
        image_index = vertcat(image_index,[index index+m-1]);
        index = index + m;
    end
end

no_of_clusters = 5;
depth = 4;
n=no_of_clusters;
d=depth;

root = cell(1,no_of_clusters+1);
root = build_tree(root, descriptor_matrix, no_of_clusters,1,depth);

length = n*(n^d-1)/(n-1);
dataset=zeros(200,length);
for i = 1:200
    word =zeros(length,1);
    for j = image_index(i,1):image_index(i,2)
        word = word + traverse_tree(root,descriptor_matrix(j,:),no_of_clusters,depth,0);   
    end
    dataset(i,:) = word;
end

words = zeros(50,length);
i = 1;
for prefix = 0:53
    if prefix == 7 || prefix == 25 || prefix == 44 || prefix == 45
        continue
    end
    image_name = [num2str(prefix),'.png'];
    [image, descriptors,locs] = sift(image_name);
    [m,n] = size(descriptors);
    word =zeros(length,1);
    for j = 1:m
        word = word + traverse_tree(root,descriptors(j,:),no_of_clusters,depth,0);   
    end
    words(i,:)=word;
    i=i+1;
end
nearest_neighbours = knnsearch(dataset,words,'Distance','cosine','K',5);
success = 0;
for i = 1:50
    check = [4*i-3,4*i-2,4*i-1,4*i];
    lia = ismember(check,nearest_neighbours(i,:));
    if sum(lia) >= 1
        success = success+1;
    end
end
fprintf('The accuracy is %f %% \n',success*2);

