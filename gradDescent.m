function gradDescent(F)
    
    P = dlmread(F,'\t',[1,1,600,1]); %reading the file column 2
    
    S = dlmread(F,'\t',[1,4,600,4]); %reading the file column 2
    
    A=[S,P];
    B = sortrows(A,1); %sorting A based on Size
    X = B(25:600,1); %assigning the column 1 of B matrix to X vector for the ease of calculation and simplification
    Y = B(25:600,2); %same as above
    scatter(X,Y)
    title('Scatter Plot of Housing Prices');
    xlabel('Size in Square Feet');
    ylabel('Price');
    Xnorm = (X /(max(X)-min(X))); %normalising the X vector
    learning_rate=0.004; %taking a random learning rate, 
    
    w1=((rand*7)); %Initialising the weights
    w0=((rand*7));
    diff_with_w0=0;
    diff_with_w1=0;
    
    MSE = zeros(1,410); %just declaring MSE
    
    j=1;
        for j=1:400
            %disp(j)
            for i = 1:576
                diff_with_w1 = diff_with_w1+((-1)*((1/576)*((Y(i)-(w1*Xnorm(i)+w0)))*(Xnorm(i)))); %calculating the partial differentiation with respect to w0 and w1 and iterating over all the training sets to find the value
                diff_with_w0 = diff_with_w0+((-1)*((1/576)*(Y(i)-(w1*Xnorm(i)+w0))));
            end    
            w0new = (w0 - (learning_rate*diff_with_w0));  %determining new values
            w1new = (w1 - (learning_rate*diff_with_w1));
            for i = 1:576
                MSE(j) = vpa((MSE(j) +(((0.5)/576)*(Y(i)-(w0+(w1*Xnorm(i))))^2))/10^5); %calculating the summation of all the MSE
            end
            w0=w0new; %assigning the new calculated values to the weights
            w1=w1new;
            %display (j)
            if j>2
            terminating_point(j-1)=(MSE(j-2)-MSE(j)); %doing this to evaluate the difference in between the MSE of different iterations which will be used for the convergence point
            end
            if j>3
                if (terminating_point(j-1)<terminating_point(j-2)) %this is the condition of convergence, I examined various values and find that at a point the difference between two successive MSE becomes constant and it again begans to fall
                    break;
                end
            end
            j=j+1;
        end
        fprintf('Algorithm converges after %d iterations, learning rate=%5.5f \n', j, learning_rate);
        for i =1:576
            yhat(i) = w1*Xnorm(i) + w0; %evaluating expected prize
        end
        figure; 
        subplot(2,1,1)                  %plotting the graph on same plot
        hold off; 
        plot(X,Y,'.'); 
        xlabel('Size in square Feet');
        ylabel('Estimated Price');
        hold;
        plot(X,yhat,'r');
        subplot(2,1,2)
        plot(MSE);
        xlabel('Iterations');
        ylabel('Error');
        
end
