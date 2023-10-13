function classification_CV(input_matrix,out_file_name)

%%input_matrix: i.e.All_matrix_IFS.mat
%%the file name for the output results.

[~,~,info]=xlsread('inhouse_file.xlsx');  %%The sample information for all the samples

load (input_matrix); %% load the IFS matrix for all the samples.

[~,ia,ib]=intersect(info(:,1),sample);

info=info(ia,:);

label=info(:,3);


class_label=zeros(length(label),1);

class_label(strcmpi(label,'c')==1,1)=1;
class_label(class_label~=1,1)=-1; %%obtain the labels for all the samples

data=ma(:,ib);


pre_score=[];
used_sample=[];

auc_score=zeros(10,1);
sensitivity(1,1)=1;
sensitivity(1,2)=0.99;
sensitivity(1,3)=0.95;
sensitivity(1,4)=0.85;



fold_number=10;

cou=0;
for j=1:10
    indices = crossvalind('Kfold',label,fold_number);
    
    for i=1:fold_number
        train_data=data(:,indices~=i);
        train_label=class_label(indices~=i,1);
        test_label=class_label(indices==i,1);
        test_data=data(:,indices==i);
        
        test_sample_stage=info(indices==i,5);
        
        
        intervals= linspace(0, 1, 101);
        
        X=train_data';
        Y=train_label(:,1);
        %%%%%train Liner SVM model
        SVMModel = fitcsvm(X,Y,'ClassNames',[-1,1]);
        test=test_data';
        %%%%%%%%%predict the test data set
        [Label,score] = predict(SVMModel,test);
        
        pre_score=[pre_score;[Label score(:,2) test_label ones(length(test_label),1)*i]];
        
        used_sample=[used_sample;info(indices==i,:)];
        
        [X,Y,~,AUC] = perfcurve(test_label,score(:,2),'1');
        cou=cou+1;
        auc_score(cou,1)=AUC;
        

        %%%%%%%%Use function to estimate the sensitivity from 1-specificity [0 0.01 0.02...1]
        val=data_point_estimate(X,Y,intervals);
        
        if i==1 && j==1
            mean_curve= val/(fold_number*10);
        else
            mean_curve= mean_curve+ val/(fold_number*10);
        end
        sensitivity(cou+1,1)=val(1);
        sensitivity(cou+1,2)=val(2);
        sensitivity(cou+1,3)=val(6);
        sensitivity(cou+1,4)=val(16);
        
    end
end

X=[0 intervals]';
Y=[0;mean_curve];



save((out_file_name),'X','Y','auc_score','sensitivity','pre_score');

end