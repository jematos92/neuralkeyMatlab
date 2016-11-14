function x = clip(x,xmin,xmax,varargin)
    if(x < xmin)
        x = xmin;
    end
    if(x > xmax)
        x = xmax;
    end    
end


