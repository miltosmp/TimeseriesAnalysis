function linear_analysis()
    % Add analysis tools to the path
    addpath("lab/");

    % Load timeseries
    [timeseries_1989, timeseries_2000, timeseries_2011, ~, ~] = load_data();
    N = length(timeseries_1989);

    % Select timeseries to analyze (comment out the unwanted)
    timeseries = timeseries_1989;
    %timeseries = timeseries_2000;
    %timeseries = timeseries_2011;

    % operation variable, 1: Fit model, 2: Parameter estimation
    operation = 2;

    % Parameters for operation 2 (the following where found after model fit)
    arma_p = 1;
    arma_q = 1;
    ar_p = 2;
    ma_q = 5;
    prediction_steps = 1;

    % Linear Analysis
    if operation == 1
        figure(1);
        r_t = autocorrelation(timeseries, N, 'ac.f.', 'c');
        hold on;
        confidence_interval = [-1.96/sqrt(N) 1.96/sqrt(N)];
        yline(confidence_interval(1), 'r');
        yline(confidence_interval(2), 'r');
    
        p_value = 0;
        for i=1 : length(r_t)
            if r_t(i, 2) > confidence_interval(2) || r_t(i, 2) < confidence_interval(1)
                p_value = p_value + 1;
            end
        end
        p_value = p_value / N;
        if p_value > 0.05
            fprintf("There are strong correlations between observations, it's not white noise. %.3f is significant\n", p_value);
        else
            fprintf("There are not any strong correlations. The time series is white noise. %.3f is significant\n", p_value);
        end
    
        % Fit AR(p) model
        aic_memory_ar = NaN();
    
        for p=1 : 30
            [~, ~, ~, ~, aic_memory_ar(p)] = fitARMA(timeseries, p, 0, 1);
        end
    
        figure(2);
        plot(aic_memory_ar);
    
        % Fit MA(q) model
        aic_memory_ma = NaN();
    
        for q=1 : 30
            [~, ~, ~, ~, aic_memory_ma(q)] = fitARMA(timeseries, 0, q, 1);
        end
    
        figure(3);
        plot(aic_memory_ma);
    
        % Fit ARMA(p,q) model
        aic_memory_arma = NaN();
    
        figure(4);
        for q=1 : 7
            for p=1 : 7
                [~, ~, ~, ~, aic_memory_arma(p)] = fitARMA(timeseries, p, q, 1);
            end
            plot(aic_memory_arma);
            q_str{q} = sprintf('q = %d', q);
            legend(q_str);
            hold all;
            drawnow;
        end
    else
        % Determine models coefficients phi, theta for selected p, q
        % Also predict and check nrmse
        [nrmse, phi_parameters, theta_parameters, s_z, ~, ~, ~] = fitARMA(timeseries, arma_p, arma_q, prediction_steps);
        fprintf("For ARMA(%d, %d) fit:\n", arma_p, arma_q);
        fprintf("- nrmse = %f\n", nrmse);
        fprintf("- phi parameters: %f %f\n", phi_parameters);
        fprintf("- theta parameters: %f\n", theta_parameters);
        fprintf("- noise standard deviation: %f\n\n", s_z);
        
        [nrmse, phi_parameters, ~, s_z, ~, ~, ~] = fitARMA(timeseries, ar_p, 0, prediction_steps);
        fprintf("For AR(%d) fit:\n", ar_p);
        fprintf("- nrmse = %f\n", nrmse);
        fprintf("- phi parameters: %f %f %f\n", phi_parameters);
        fprintf("- noise standard deviation: %f\n\n", s_z);
        
        [nrmse, ~, theta_parameters, s_z, ~, ~, ~] = fitARMA(timeseries, 0, ma_q, prediction_steps);
        fprintf("For MA(%d) fit:\n", ma_q);
        fprintf("- nrmse = %f\n", nrmse);
        fprintf("- theta parameters: %f %f %f %f %f\n", theta_parameters);
        fprintf("- noise standard deviation: %f\n\n", s_z);
        
    end

end

