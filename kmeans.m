function kmeans(F)                                                          %defining the function
 data = csvread(F);                                                         %reading the input file
 N=size(data,1);                                                            %calculating the size of the input file
 features = data(:,1:2);                                                    %separating the features and labels
 labels = data(:,3);
 random_row = ceil(rand * size(features,1));                                %selecting random row
 ctr1 = features(random_row,:);                                             %initially selecting the centroids
 ctr2 = features(random_row+1,:);
 x = size(ctr1);
 y = size(ctr2);
 cluster1 = [];                                                             %declaring the cluster matrix
 cluster2 = [];
 iterations_count=0;
 element11 = 0;                                                             %declaring the elements of confusion matrix
 element12 = 0;
 element21 = 0;
 element22 = 0;
 while(1)                                                                   %starting the loop untill break condition reach
 cluster1 = [];
 cluster2 = [];
 element11 = 0;
 element12 = 0;
 element21 = 0;
 element22 = 0;         
     for i = 1:size(features,1)                                             %calculate Euclidean distance of each data point from the centroids    
        distance_ctr1 = norm(ctr1 - features(i,:),2);               
        distance_ctr2 = norm(ctr2 - features(i,:),2);
        
        if(distance_ctr1 < distance_ctr2)                                   %Assigning the data points to the clusters depending on the distance from the centroid
            cluster1 = [cluster1;features(i,:)];
            if(data(i,3)==1.0000)                                           %Doing this in order to calculate the elements of confusion matrix
                element11=element11+1;                                      %If class label is 1 and the predicted class is also 1 increment the value
            else
                element21=element21+1;                                      %if class label is 2 but the predicted class is 1
            end
        else
            cluster2 = [cluster2;features(i,:)];
            if(data(i,3)==2.0000)
                element22=element22+1;                                      %If class label is 2 and the predicted class is also 2 increment the value
            else
                element12=element12+1;                                      %if class label is 1 but the predicted class is 2
            end
        end
     end
     iterations_count = iterations_count +1;
     old_ctr1=ctr1;
     old_ctr2=ctr2;
     ctr1 = mean(cluster1);
     ctr2 = mean(cluster2);
     pos_diff1 = norm(ctr1 - old_ctr1,2);                                   %To identify the breaking condition, finding the Euclidean distance of the two centroids new ones and the old ones
     pos_diff2 = norm(ctr2 - old_ctr2,2);
     if(pos_diff1==0 || pos_diff2 == 0)                                     %If the distance is zero, just break the loop
         break
     else
         continue
     end
 end
 
if(element11<element12)                                                     %swapping the elements if diagonal elements are smaller as compared to the off diagonal elements
[element12, element11]=deal(element11,element12);
end

if(element22<element21)
[element21,element22] = deal(element22,element21);
end
confusion_matrix = [element11 element12 ; element21 element22];             %assigning the calculated values to the confusion matrix
display(confusion_matrix);
 a = size(cluster1);
 b = size(cluster2);
 
 fprintf('The Algorithm converges after %i iterations',iterations_count);
 disp(' ');
 figure; hold on; xlabel('Sepal Length'); ylabel('Sepal Width');            %Plotting the figure
 for ax1 = 1: size(cluster1,1)
 plot(cluster1(ax1,1),cluster1(ax1,2),'r.','MarkerSize',12) 
 end
 for ax2 = 1: size(cluster2,1)
 plot(cluster2(ax2,1),cluster2(ax2,2),'b.','MarkerSize',10)
 end
 plot(ctr1(:,1),ctr1(:,2), 'kx', 'MarkerSize',12,'LineWidth',2); 
 plot(ctr2(:,1),ctr2(:,2), 'ko', 'MarkerSize',12,'LineWidth',2);
 
end
