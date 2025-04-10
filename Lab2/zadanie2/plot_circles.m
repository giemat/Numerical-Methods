function plot_circles(a, b, circles);
figure;
hold on;
axis equal;
axis([0 a 0 b]);
rectangle("Position",[0,0,a,b]);
    for i = 1:length(circles)
        r = circles(i,3);
        x = circles(i,1);
        y = circles(i,2);

        plot_circle(r,x,y);
    end
    hold off;
end

