function [ ] = LagrangeMethod( f, h, x ,isMax)
    n = length(x);
    m = length(h);
    lambda = sym('lambda', [m, 1], 'real');
    
    L = f - sum(lambda .* h)
    gradL = gradient(L, x) 
    
    eqns = gradL == 0;
    eqns = [eqns; h == 0]
    
    vars = [x, lambda.']
    S = solve(eqns, vars, 'ReturnConditions', true);
    disp(S.parameters)
    %disp(S.conditions)
    
    %S = vpasolve(eqns, vars)
    jml=length(S.(char(x(1))));
    f_x = zeros(jml,1);
    
    for idx = 1:jml
        x_val = zeros(n, 1);
        lambda_val = zeros(m, 1);
        
        for i = 1:n
            xi_name = char(x(i));
            x_val(i) = double(S.(xi_name)(idx));
        end

        for j = 1:m
            lj_name = ['lambda', num2str(j)];
            lambda_val(j) = double(S.(lj_name)(idx));
        end
        
        f_x(idx) = double(subs(f, x, x_val.'));
        fprintf('\nSolusi #%d :\n', idx);
        for i = 1:n
            fprintf('x%d = %.6f\n', i, x_val(i));
        end
        for j = 1:m
            fprintf('lambda%d = %.6f\n', j, lambda_val(j));
        end
        fprintf('f(x) = %.6f\n', f_x(idx));
    end
    
    if isMax
        [val] = max(f_x)
        fprintf('\nSolusi dengan hasil maximun\n');
    else
        [val] = min(f_x)
        fprintf('\nSolusi dengan hasil minimun\n');
    end
    
    idx = find(f_x == val);    % cari semua indeks yang cocok
    
    for id = 1:length(idx)
        x_val = zeros(n, 1);
        lambda_val = zeros(m, 1);
        
        for i = 1:n
            xi_name = char(x(i));
            x_val(i) = double(S.(xi_name)(idx(id)));
        end

        for j = 1:m
            lj_name = ['lambda', num2str(j)];
            lambda_val(j) = double(S.(lj_name)(idx(id)));
        end
        
        f_x(idx(id)) = double(subs(f, x, x_val.'));
        fprintf('\nSolusi #%d :\n', idx(id));
        for i = 1:n
            fprintf('x%d = %.6f\n', i, x_val(i));
        end
        for j = 1:m
            fprintf('lambda%d = %.6f\n', j, lambda_val(j));
        end
        fprintf('f(x) = %.6f\n', f_x(idx(id)));
    end
        
    
end

