function [x_opt, f_opt] = goldenSectionSearch(f, a, b, tol, isMax)
% goldenSectionSearch Mencari titik optimum fungsi satu variabel
%
% Input:
%   f     : function handle, contoh @sin, @(x) x.^2
%   a,b   : batas interval awal [a,b]
%   tol   : toleransi error (misal 1e-5)
%   isMax : boolean, true jika mencari maksimum, false untuk minimum
%
% Output:
%   x_opt : titik optimum (x)
%   f_opt : nilai fungsi optimum f(x_opt)
%
% Contoh:
%   [x, fx] = goldenSectionSearch(@(x) (x-2).^2, 0, 5, 1e-5, false);

    gr = (sqrt(5) - 1) / 2; % rasio golden sekitar 0.618
    c = b - gr * (b - a);
    d = a + gr * (b - a);

    fc = f(c);
    fd = f(d);

    if isMax % jika cari maksimum, balik tanda perbandingan
        comp = @(f1, f2) f1 > f2;
    else
        comp = @(f1, f2) f1 < f2;
    end

    iter = 0;
    % Buat array untuk nyimpen data iterasi
    data = [];
    
    while abs(b - a) > tol
        iter = iter + 1;
        % Simpan data iterasi
        data = [data; iter, a, b, c, d, fc, fd];
        
        if comp(fc, fd)
            b = d;
            d = c;
            fd = fc;
            c = b - gr * (b - a);
            fc = f(c);
        else
            a = c;
            c = d;
            fc = fd;
            d = a + gr * (b - a);
            fd = f(d);
        end
    end

    T = array2table(data, ...
        'VariableNames', {'Iterasi', 'a', 'b', 'c', 'd', 'f_c', 'f_d'});
    disp(T)
    
    % Pilih titik optimum dari c dan d
    if comp(fc, fd)
        x_opt = c;
        f_opt = fc;
    else
        x_opt = d;
        f_opt = fd;
    end
end
