%% loading paths and specifying network architecture
addpath('..\..\util');
init = struct; 
init.filtsize = 5;
init.numconvs =2;
init.poolstride = 2;
init.mlff_inputsize = 16;
init.xfold = 4;
init.numPoints = calpoints(init.numconvs,init.filtsize,init.poolstride,init.mlff_inputsize);
%works for all numPoint sizes
%%  
for i = 1:500 
    signal(i,:) = gausswin(76,5) + zeros(76,1);
end
for i = 1:250
    signal(i,:)= gausscreate(signal(i,:),floor(i/4)+1,10,20);
end
init.numSignals = length(signal); 
desired_op = [ones(250,1); zeros(250,1)];
normsig = feat_scale(signal,0,1) ; %scale the contents of the signal to fmin and fmax

%% shuffling and splitting to training and testing data
[normfinal, desired_output] = randomize(normsig,desired_op,init.numSignals);

[init.trainsize, init.testsize, init.traindata, init.desired_train_op, init.testdata, init.desired_test_op] = ...
    xfoldsplit(normfinal,init.xfold,desired_output);
% ---------------------------------------------------------------------------------
%clearning unwanted variables
keepvars = { 'init'};
clearvars('-except', keepvars{:});
% ---------------------------------------------------------------------------------
save('k4bench2.mat');