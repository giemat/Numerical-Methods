function [circle_areas,circles, a, b, r_max] = generate_circles(n_max)

    a = randi([150, 250]);
    b = randi([50, 100]);
    r_max = randi([20, 50]); 
    
    circles = zeros(n_max, 3);
    circle_areas = zeros(n_max,1);
    sum = 0;
    for i = 1:n_max
        good_circle = false;
        
        while ~good_circle
            
            R = (r_max - 1) * rand() + 1;
            X = (a - 2 * R) * rand() + R;
            Y = (b - 2 * R) * rand() + R;
            
            good_circle = true;

            
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
        
        
        circles(i, :) = [X, Y, R];
        areaPrev = 100*pi*R*R/(a*b);
        sum = sum + areaPrev;
        circle_areas(i) = sum;
        
    end
    plot(circle_areas, 'LineWidth', 1.5, 'MarkerSize', 5); 
    xlabel('Number of circles');
    ylabel('Percentage area ratio');
    title('Circle areas to rectange area ratio');
    saveas(gcf,'zadanie2.png');
    
end

