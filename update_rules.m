function y = theta(t1, t2)
    y = (t1 == t2);    
end

function W = hebbian(W, X, sigma, tau1, tau2, l)
    k = size(W,1);
    n = size(W,2);
    
    for i = 1:k
        for j = 1:n
            W(i,j) = W(i,j)  + X(i, j) .* tau1 .* theta(sigma(i), tau1) .* theta(tau1, tau2); 
            W(i,j) = clip(W(i,j),-l,l);
        end
    end
end

function W = anti_hebbian(W, X, sigma, tau1, tau2, l)
    k = size(W,1);
    n = size(W,2);
    
    for i = 1:k
        for j = 1:n
            W(i,j) = W(i,j)  - X(i, j) .* tau1 .* theta(sigma(i), tau1) .* theta(tau1, tau2); 
            W(i,j) = clip(W(i,j),-l,l);
        end
    end
end

function W = random_walk(W, X, sigma, tau1, tau2, l)
    k = size(W,1);
    n = size(W,2);
    
    for i = 1:k
        for j = 1:n
            W(i,j) = W(i,j) + X(i, j) * theta(sigma(i), tau1) * theta(tau1, tau2); 
            W(i,j) = clip(W(i,j),-l,l);
        end
    end
end

