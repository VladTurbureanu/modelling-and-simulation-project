function run_simulation()
    [matrix_size, no_of_connections, no_of_iterations, visualization, run_to_end] = read_input();
    
    cycle_lengths = [];
    for i = 1:50
        disp("Found " + i + " / 200 cycles so far...")
        cycle_lengths(i) = boolean_network_matrix(matrix_size, no_of_connections, no_of_iterations, visualization, run_to_end);
    end
    
    cycle_lengths
    mean(cycle_lengths)
    mode(cycle_lengths)
    median(cycle_lengths)
    
    for j=1:length(cycle_lengths)
        if cycle_lengths(j) > 100
            cycle_lengths(j) = 100;
        end
    end
    
    histogram(cycle_lengths, 100)
    xlim([-1,100])
    xt = xticklabels; 
    xt{end} = '> 100'
    xticklabels(xt);
    xlabel('Cycle length')
    ylabel('Frequency')

end

% Reads user input
function [matrix_size, no_of_connections, no_of_iterations, visualization, run_to_end] = read_input()
    prompt = "Please give a matrix size between 2 and 200 (e.g. 4-> 4x4): ";
    matrix_size = input(prompt);
    
    % Ensuring correct input
    while matrix_size < 2 || matrix_size > 200
        msgbox("Invalid matrix size. Please choose a number between 2 and 200.");
        matrix_size = input(prompt);
    end
    
    % Choose 2 or 3 as the other ones have not yet been properly implemented
    prompt = "Please give the number of connections per gene (between 1 and 4): ";
    no_of_connections = input(prompt);
    
    % Ensuring correct input
    while no_of_connections < 1 || no_of_connections > 4
        msgbox("Invalid number of connections. Please choose a number between 1 and 4. ");
        no_of_connections = input(prompt);
    end    

    prompt = "Please give the number of iterations (between 1 and 1000): ";
    no_of_iterations = input(prompt);
    
    % Ensuring correct input
    while no_of_iterations < 1 || no_of_iterations > 1000
        msgbox("Invalid number of iterations. Please choose a number between 1 and 1000. ");
        no_of_connections = input(prompt);
    end    
    
    prompt = "Visualization: Type 1 for ON, 0 for OFF (without visualization makes it much faster): ";
    visualization = input(prompt);
    
    prompt = "Run to end (1) or Find cycles (0): ";
    run_to_end = input(prompt);

end