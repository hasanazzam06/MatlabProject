function [x_valid_all, f_valid_all, lambda_valid_all] = KKTMethod(f, g, x)
% Modular dan fleksibel: bisa menangani jumlah variabel dan kendala berapa pun
% f: fungsi objektif simbolik
% g: array fungsi kendala simbolik (<= 0)
% x: array variabel keputusan simbolik [x1, x2, ..., xn]

    n = length(x);
    m = length(g);
    lambda = sym('lambda', [m, 1], 'real');

    % Lagrangian
    L = f + sum(lambda .* g)
    gradL = gradient(L, x)

    % Buat sistem persamaan KKT
    eqns = gradL == 0;
    for i = 1:m
        eqns = [eqns; lambda(i) * g(i) == 0];
    end

    eqns
    
    vars = [x, lambda.']
    S = solve(eqns, vars, 'ReturnConditions', true);
    disp(S.parameters)
    %disp(S.conditions)
    
    %S = vpasolve(eqns, vars)

    % Inisialisasi array hasil
    x_valid_all = [];
    f_valid_all = [];
    lambda_valid_all = [];

    % Iterasi semua solusi
    for idx = 1:length(S.(char(x(1))))
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
        
        f_x=double(subs(f, x, x_val.'));
        fprintf('\nSolusi #%d :\n', idx);
        for i = 1:n
            fprintf('x%d = %.6f\n', i, x_val(i));
        end
        for j = 1:m
            fprintf('lambda%d = %.6f\n', j, lambda_val(j));
        end
        fprintf('f(x) = %.6f\n', f_x);
        
        
        % Validasi KKT
        valid = true;
        for j = 1:m
            g_val = double(subs(g(j), x, x_val.'));
            if g_val > 1e-6 
                valid = false;
                fprintf('\nGagal memenuhi Feasiblity ke:%d',j);
                fprintf('\ng%d = %.6f > 0',j,g_val);
                break;
            elseif lambda_val(j) < -1e-6
                valid = false;
                fprintf('\nGagal memenuhi Non negatif ke:%d',j);
                fprintf('\nlambda%d = %.6f < 0',j,lambda_val(j));
                break;
            end
        end

        if valid
            x_valid_all = [x_valid_all; x_val.'];
            fprintf('\nStatus Solusi -> valid\n');
            fprintf('\nMemenuhi semua syarat KKT\n');
        else
            fprintf('\nStatus Solusi -> Tidak valid\n');
        end
    end

    if isempty(x_valid_all)
        disp('Tidak ada solusi valid yang memenuhi KKT');
    end
end
