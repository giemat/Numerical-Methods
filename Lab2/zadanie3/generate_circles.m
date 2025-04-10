function [rand_counts, counts_mean, circles, a, b, r_max] = generate_circles(n_max)

    a = randi([150, 250]);
    b = randi([50, 100]);
    r_max = randi([20, 50]); 
    
    circles = zeros(n_max, 3);
    rand_counts = zeros(1,n_max);
    counts_mean = zeros(1,n_max);
    sum = 0;
    for i = 1:n_max
        good_circle = false;
        count = 0;
        while ~good_circle
            count = count + 1;
            R = (r_max - 1) * rand() + 1;
            X = (a - 2 * R) * rand() + R;
            Y = (b - 2 * R) * rand() + R;
            
               if(R<=0 || R>=r_max || X+R>=a || X-R<=0 || Y+R>=b || Y-R<=0 || X <= 0 || Y <= 0)
                    good_circle = false;
               else
                   good_circle = true;
               end

            
            for j = 1:i-1 
                xPrev = circles(j, 1);
                yPrev = circles(j, 2);
                rPrev = circles(j, 3);

               
                distance = sqrt((X - xPrev)^2 + (Y - yPrev)^2);

                
                if distance < (rPrev + R)
                    good_circle = false;
                    break;
                end
                
                
                if R >= (rPrev + distance) || rPrev >= (R + distance)
                    good_circle = false;
                    break;
                end
            end
        end
        sum = sum + count;
        rand_counts(i) = count;
        counts_mean(i) = sum/i;
        circles(i, :) = [X, Y, R];
        
        
    end
    subplot(2,1,1);
    plot(rand_counts);
    title("Number of parameter sampling")
    xlabel("Circle number");
    ylabel("Number of samples");
    subplot(2,1,2);
    plot(counts_mean);
    title("Mean number of samples")
    xlabel("Circle number");
    ylabel("Mean number of samples");
    saveas(gcf,'zadanie3.png');
    
end

