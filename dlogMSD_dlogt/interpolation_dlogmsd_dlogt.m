timesteps = load('timesteps_logaritmici_mod.txt'); % primi 152 valori dei timesteps
log_msd = load('log_msd_lammps_mod.txt') % primi 152 valori corrispondenti di log_msd

% Fattore di scala (Deltat)
Deltat = 0.005;

% Times obtained by this product:
time = timesteps * Deltat;

% Step 1: Uniform time array with  1024 points
t_new = linspace(min(time), max(time), 1024);

% Step 2: Interpolation with 'interp1'
log_msd_interpolated = interp1(time, log_msd, t_new, 'pchip');

% Step 3: Plot for comparison:

figure;
loglog(t_new, log_msd_interpolated, 'b', 'LineWidth', 1.5);
xlabel('$t$', 'Interpreter', 'latex');
ylabel('$\log(\left\langle r^2(t) \right\rangle)$', 'Interpreter', 'latex');
title('Interpolated $\log(\left\langle r^2(t) \right\rangle)$ vs $t$', 'Interpreter', 'latex');
grid on;
hold on;
loglog(time, log_msd, 'r', 'LineWidth', 1.5);
xlabel('$t$', 'Interpreter', 'latex');
ylabel('$\log(\left\langle \Delta r^2(t) \right\rangle)$', 'Interpreter', 'latex');
title('$\log(\left\langle \Delta r^2(t) \right\rangle)$ vs $t$', 'Interpreter', 'latex');
legend('Interpolated', 'Original');
grid on;

% Calcolo della derivata del log(MSD) rispetto al tempo t
dlog_msd_dt = gradient(log_msd_interpolated, t_new);

% Calcolo della derivata del log(MSD) rispetto a log(t)
dlog_msd_dlog_t = dlog_msd_dt .* t_new;


% Trova il minimo della derivata e il relativo indice
[dlog_msd_min, idx_min] = min(dlog_msd_dlog_t);

% Trova il valore corrispondente di t (tau_beta)
tau_beta = t_new(idx_min);

% Visualizza tau_beta
disp(['Tau_beta: ', num2str(tau_beta)]);

% Plot della derivata con evidenziazione di tau_beta
figure;
plot(t_new, dlog_msd_dlog_t, 'b', 'LineWidth', 1.5);
hold on;
plot(tau_beta, dlog_msd_min, 'ro', 'MarkerSize', 8, 'LineWidth', 2); % Minimo evidenziato
set(gca, 'XScale', 'log'); % Imposta scala logaritmica per l'asse x
xlabel('$t$', 'Interpreter', 'latex');
ylabel('$\log(\left\langle \Delta r^2(t) \right\rangle)$', 'Interpreter', 'latex');
title('Derivative of $\log(\langle r^2(t) \rangle)$ vs $\log(t)$', 'Interpreter', 'latex');
grid on;
legend('Derivative of log(MSD)', '\tau_{\beta}');



