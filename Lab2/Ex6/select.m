function y = select(x1, x2)
% select the positive root of 2nd-order equation


    if (x1 >= 0) && (x2 < 0)
        y = x1;
    elseif (x1 < 0) && (x2 >= 0)
        y = x2;
    elseif (x1 >= 0) && (x2 >= 0)
        error('Multiple roots')
    else
        error('unsolvable')
    
    end
end
