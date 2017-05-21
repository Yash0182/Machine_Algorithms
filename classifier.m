function classifier(F)
    M = csvread(F);
    shuffledM = M(randperm(150),:);
    
    N=size(shuffledM,1);
    
    i=1;
    CV_fold=1;
    Average_accuracy = 0;
    while(i<=N)
        fprintf('%i CV Fold',CV_fold)
        disp(' ');
        right_prediction=0;
        test_data=shuffledM(i:((N/10)+i-1),1:4);
        matrix_to_verify=shuffledM(i:((N/10)+i-1),:);
        if(i~=1)
        train_data=shuffledM([1:i-1 (N/10+i):N],:);
        else
        train_data=shuffledM((N/10+i):N,:);
        end
        index_class1 = (train_data(:,5)==1.0000);
        index_class2 = (train_data(:,5)==2.0000);
        index_class3 = (train_data(:,5)==3.0000);
        %separating the different classes
        matrix_class1 = train_data(index_class1,1:4);
        matrix_class2 = train_data(index_class2,1:4);
        matrix_class3 = train_data(index_class3,1:4);
        %finding the mean of each matrix
        meanv_class1  = mean(matrix_class1);
        meanv_class2  = mean(matrix_class2);
        meanv_class3  = mean(matrix_class3);
        %evaluating size of each matrix
        size_class1 = size(matrix_class1,1);
        size_class2 = size(matrix_class2,1);
        size_class3 = size(matrix_class3,1);
        %converting vector to matrix
        mean_class1 = repmat(meanv_class1,size_class1,1);
        mean_class2 = repmat(meanv_class2,size_class2,1);
        mean_class3 = repmat(meanv_class3,size_class3,1);
        size(mean_class1);
        %evaluating covariances
        %cov_class1 = (1/45)*(((matrix_class1 - mean_class1))*(matrix_class1 - mean_class1)');
        cov_class1 = (1/45)*(((matrix_class1' - mean_class1'))*(matrix_class1' - mean_class1')');
        cov_class2 = (1/45)*(((matrix_class2' - mean_class2'))*(matrix_class2' - mean_class2')');
        cov_class3 = (1/45)*(((matrix_class3' - mean_class3'))*(matrix_class3' - mean_class3')');
        
        for each_row = 1:size(test_data) 
            
        test_data(each_row,:);
        %temp1=(test_data(1,:)'- meanv_class1');
        temp1=(test_data(each_row,:)'- meanv_class1');
        temp2=(test_data(each_row,:)'- meanv_class2');
        temp3=(test_data(each_row,:)'- meanv_class3');
        %evaluating the discriminant function
        %g_class1 = (-0.5)*((((test_data(1,:)- meanv_class1)')*((inv(cov_class1))*(test_data(1,:)- meanv_class1)))-((0.5)*log(det(cov_class1)))+log(0.3))
        %g_class2 = (-0.5)*((((test_data(1,:)- meanv_class2)')*((inv(cov_class2))*(test_data(1,:)- meanv_class2)))-((0.5)*log(det(cov_class2)))+log(0.3))
        %g_class3 = (-0.5)*((((test_data(1,:)- meanv_class3)')*((inv(cov_class3))*(test_data(1,:)- meanv_class3)))-((0.5)*log(det(cov_class3)))+log(0.3))
        g_class1 = (-0.5)*((((temp1)')*((inv(cov_class1))*(temp1)))-((0.5)*log(det(cov_class1)))+log(0.3));
        g_class2 = (-0.5)*((((temp2)')*((inv(cov_class1))*(temp2)))-((0.5)*log(det(cov_class2)))+log(0.3));
        g_class3 = (-0.5)*((((temp3)')*((inv(cov_class1))*(temp3)))-((0.5)*log(det(cov_class3)))+log(0.3));
        predicted_class=0;
        if(g_class1>g_class2 && g_class1>g_class3)
            fprintf('Predicted class is class_1      ')
            predicted_class = 1.0000;
        elseif(g_class2>g_class1 && g_class2>g_class3)
            fprintf('Predicted class is class_2      ')
            predicted_class = 2.0000;
        else
            fprintf('Predicted class is class_3        ')
            predicted_class = 3.0000;
        end
        original_class = matrix_to_verify(each_row,5);
        fprintf('Original Class is %.3f',original_class)
        disp(' ')
        if (predicted_class == original_class)
            right_prediction=right_prediction+1;
        end
        end
        fprintf('Total Right predictions made by algorithm out of 15 is %i' ,right_prediction)
        disp(' ');
        acc = (right_prediction / size(test_data,1))*100;
        fprintf('Percentage Accuracy for this iteration = %.3f',acc)
        disp(' ')
        disp(' ')
        Average_accuracy = Average_accuracy+acc;
        i=i+(N/10);
        CV_fold=CV_fold+1;
    end
    fprintf('Average Accuracy for the 10 fold CV = %.3f',(Average_accuracy/10))
    disp(' ')
    
end