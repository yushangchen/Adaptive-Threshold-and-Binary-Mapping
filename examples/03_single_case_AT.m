setup;
D = atbm.loadDataset(fullfile('data','processed','ATBM_dataset.mat'));
seg = atbm.getTap(D,'Cpp90_2D',25);
result = atbm.extractAT(seg);
figure('Color','w');
atbm.plotATResult(gca,result,true,false);
title('Cpp90\_2D, case 25','Interpreter','none');
