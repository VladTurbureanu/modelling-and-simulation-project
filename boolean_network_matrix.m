function main()
    [matrix_size, no_of_connections, no_of_iterations] = read_input();
    
    % Each node in the network has a boolean variable attached to it (0 or 1)
    % Increase the number after '>' for less ones, decrease it for more.
    A = rand(matrix_size,matrix_size) > 0.7;

    neighbouring_nodes = {};
    all_matrices = {};
    no_of_genes = matrix_size * matrix_size;

    % Specific rules for transitioning
    % Permutations of random values: no_of_inputs^no_of_connections
    % e.g. random values with 3 input (-> 8 permutations)
    % This should probably be outside of the loop 
    truth_table_values = randi([0 1],1, 2^no_of_connections);
    % standard adjacency matrix of the network
    adjacency_matrix = zeros(no_of_genes,no_of_genes);
    
    cycle_cntr = 0;

    % state matrix will be used to count cycles in the states of the
    % network
    % state_matrix = zeros(matrix_size,matrix_size,20);
    for iteration = 1:no_of_iterations
        all_matrices{iteration} = A;
        % Each node in the network is connected to 3 other nodes (randomly)
        % Here we have 16 genes (in case of a 4x4 matrix), so 16 positions. 
        % Q: can they be connected to itself ? For now, we assume yes because it's
        % simpler
        neighbours_matrix = {};
        for gene = 1:no_of_genes
            % For each node, give 3 random values between 1 and
            % (matrix_size * matrix_size (number of genes)
            % This only occurs the first iteration (connections stay the
            % same)
            % So K = 3 in this case
            if iteration == 1
                neighbouring_nodes{gene} = randperm(no_of_genes,no_of_connections);
                % create the adjacency matrix by using the neighboring
                % nodes
                for i = 1:length(neighbouring_nodes{gene})
                    adjacency_matrix(gene,neighbouring_nodes{gene}(i))=1;
                end
            end
            
            % Get the binary values of the neighbours
            % This happens every iteration
            binary_values = [];
            for i = 1:length(neighbouring_nodes{gene})
                binary_values(i) = A(neighbouring_nodes{gene}(i));
            end
            neighbours_matrix{gene} = binary_values;
        end

        new_matrix = zeros(matrix_size);
        % Synchronous update
        for gene_update = 1:no_of_genes
            neighbours = neighbours_matrix{gene_update};
            new_matrix(gene_update) = truth_table(no_of_connections, neighbours, truth_table_values);
        end
        disp("iteration " + iteration)
        A = new_matrix;
        display_grid(A, iteration)
        pause(0.3)
        
        [found_cycle, last_value] = find_cycle(A, all_matrices);
        if found_cycle == 1
            disp('Found a cycle! In iteration and with the last value of finding this pattern:')
            iteration
            last_value
            cycle_length = iteration - last_value
            cycle_cntr = cycle_cntr + 1;
            if cycle_cntr == cycle_length
                break;
            end
        end
    
    end
    % display the network as a directed graph by using the adjacency matrix
    figure;
    G = digraph(adjacency_matrix);
    plot(G);
    
    
end

% Reads user input
function [matrix_size, no_of_connections, no_of_iterations] = read_input()
    prompt = "Please give a matrix size between 2 and 200 (e.g. 4-> 4x4): ";
    matrix_size = input(prompt);
    
    % Ensuring correct input
    while matrix_size < 2 || matrix_size > 200
        msgbox("Invalid matrix size. Please choose a number between 2 and 200.");
        matrix_size = input(prompt);
    end
    
    % Choose 2 or 3 as the other ones have not yet been properly implemented
    prompt = "Please give the number of connections per gene (between 2 and 3) (for now, still need to implement more): ";
    no_of_connections = input(prompt);
    
    % Ensuring correct input
    while no_of_connections < 1 || no_of_connections > 4
        msgbox("Invalid number of connections. Please choose a number between 2 and 3. ");
        no_of_connections = input(prompt);
    end    

    prompt = "Please give the number of iterations (between 1 and 1000): ";
    no_of_iterations = input(prompt);
    
    % Ensuring correct input
    while no_of_iterations < 1 || no_of_iterations > 1000
        msgbox("Invalid number of iterations. Please choose a number between 1 and 1000. ");
        no_of_connections = input(prompt);
    end    

end

% It should be possible to do this more efficiently, will have a look at it later
function output = truth_table(no_of_connections, neighbours, truth_table_values)
    output = 0;
    if no_of_connections == 2
        output = truth_table2(neighbours, truth_table_values);
    elseif no_of_connections == 3
        output = truth_table3(neighbours, truth_table_values);
    end
end
           
function output = truth_table3(neighbours, truth_table_values)
    if neighbours == [0,0,0]
        output = truth_table_values(1);
    elseif neighbours == [0,0,1]
        output = truth_table_values(2);
    elseif neighbours == [1,1,1]
        output = truth_table_values(3);
    elseif neighbours == [0,1,0]
        output = truth_table_values(4);
    elseif neighbours == [0,1,1]
        output = truth_table_values(5);
    elseif neighbours == [1,0,0]
        output = truth_table_values(6);
    elseif neighbours == [1,0,1]
        output = truth_table_values(7);
    elseif neighbours == [1,1,0]
        output = truth_table_values(8);
    end
end

function output = truth_table2(neighbours, truth_table_values)
    if neighbours == [0,0]
        output = truth_table_values(1);
    elseif neighbours == [0,1]
        output = truth_table_values(2);
    elseif neighbours == [1,0]
        output = truth_table_values(2);
    elseif neighbours == [1,1]
        output = truth_table_values(3);
    end
end

% Based on https://stackoverflow.com/questions/3280705/how-can-i-display-a-2d-binary-matrix-as-a-black-white-plot
function display_grid(A, iteration)
    cMap = [1 0 0; 0 0.8 0];
    [r, c] = size(A);                         
    imagesc((1:c)+0.5, (1:r)+0.5, A);          
    
    colormap(cMap);                          
    axis equal                               
    set(gca,  ...  
             'XLim', [1 c+1], 'YLim', [1 r+1], ...
             'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');

    title(['Iteration ', num2str(iteration)])
end

function [found_cycle, last_value] = find_cycle(A, all_matrices)
    flag = 0;
    last_value = 0;
    % Identifying cycles
    for j = 1:length(all_matrices)-1
        if(all_matrices{j} == A)
            flag = 1;
            last_value = j;
        end
    end
    if flag == 0
        found_cycle = 0;
    else
        found_cycle = 1;
    end
end

