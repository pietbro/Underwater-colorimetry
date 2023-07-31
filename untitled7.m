    XYZ = getChartXYZvalues(chart,colors);
    T = XYZ' * pinv(RGB)';
    Ixyz = reshape((T*reshape(Iwhitebalanced,[s(1)*s(2) 3])')',[s(1) s(2) 3]);
    Ixyz(Ixyz < 0) = 0; % Check for negative values
    IPPrgb = XYZ2ProPhoto(Ixyz);