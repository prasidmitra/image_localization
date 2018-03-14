function localization()
    clusters = 1000;

    descriptor_matrix = [];
    image_index = [];
    index = 1;
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
    [IDX, C] = kmeans(descriptor_matrix,clusters);
    dataset = zeros(200,clusters);
    for i = 1:200
        for j = image_index(i,1):image_index(i,2)
            dataset(i,IDX(j)) = dataset(i,IDX(j)) + 1;
        end
    end
    words = zeros(50,clusters);
    i = 1;
    for prefix = 0:53
        if prefix == 7 || prefix == 25 || prefix == 44 || prefix == 45
            continue
        end
        image_name = [num2str(prefix),'.png'];
        [image, descriptors,locs] = sift(image_name);
        [m,n] = size(descriptors);
        D = pdist2(descriptors,C,'cosine');
        [M,I] = min(D,[],2);
        for j = 1:size(I)
            words(i,I(j)) = words(i,I(j)) + 1;
        end
        i = i+1;
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
end