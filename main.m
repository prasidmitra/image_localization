folder = fileparts(which(mfilename)); 
addpath(genpath(folder));
disp('Question 2: Pose Estimation')
estimate_pose()
disp('----------------------------')
disp('Question 3: Image Localization')
disp('Bag of words')
localization()
disp('Vocabulary Tree')
vocab_tree()