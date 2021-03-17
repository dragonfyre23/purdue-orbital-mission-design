%% solid rocket motor sizing code
function [] = Simulate(dt, shape, length, width, innerWidth, maxPres)
%% Constants (SI)
g = 9.81; 
%% Inputs
%time step [seconds]
%rocket geometry parameters: Width, inner width, shape, and length
%maximum pressure desired

%GUESSTIMATED DUMMY VALUES FROM CEARUN, get better ones from CEA
C_initial = 6.2; %C at pressure of 1000 psi (6.895 MPA)
n = .098; %Burn rate exponent at 1000 psi (6.895 MPA)
C_star = 1077.8; %C* for 70% AP-HTPB 
propDens = 1.5; %Average density for 70% AP-HTPB (g/cm^3)

    r_max = width / 2;
    r_min = innerWidth / 2;
    %finding throat area for end of burn
    A_t = (Surface_Area(shape, r_max, r_min, length) * propDens * C * C_star / g * maxPres^(1-n));
    i = 1;
    while W(i-1) < r_max
        %time step
        T(i) = T(i-1) + dt;
        %Chamber pressure
        P_c(i) = ((Surface_Area(shape, W(i), r_min, length) * propDens * C * C_star) / (g * A_t))^(1/ 1 - n);
        %Thrust
        thrust(i) = c_t * A_t * P_c(i);
        %Burn Rate
        R_b(i) = C * P_c(i)^n;
        %New web distance
        W(i+1) = W(i) + R_b * dt;
        %increment index
        i = i + 1;
    end
    %burn time = t
end

function area = Surface_Area(shape, w, r_min, l)
% INPUTS
%shape, the cross sectional shape of the grain
%w, the current web distance
%l, the length of the rocket
    switch(shape)
        %case 'aft finocyl'
        %    area = ;%todo
        case 'circular'
            area = 2 * pi * (w+r_min) * l;
        case 'square'
            area = 8 * (w+r_min) * l;
        otherwise
            fprintf("Invalid shape parameter, see Surface_Area function for valid choices");
            area = 0;
    end
end