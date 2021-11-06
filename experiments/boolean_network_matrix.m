function cycle_length = boolean_network_matrix(matrix_size, no_of_connections, no_of_iterations, visualization, run_to_end, tautology_and_contradiction)
    %[matrix_size, no_of_connections, no_of_iterations] = read_input();
    
    % Each node in the network has a boolean variable attached to it (0 or 1)
    % Increase the number after '>' for less ones, decrease it for more.
    % We want an equal probability for zeroes and ones
    A = rand(matrix_size,matrix_size) > 0.5;

    neighbouring_nodes = {};
    truth_table_values = {};
    all_matrices = {};
    no_of_genes = matrix_size * matrix_size;

    % standard adjacency matrix of the network
    adjacency_matrix = zeros(no_of_genes,no_of_genes);
    
    cycle_cntr = 0;
    cycle_length = -1;

    % state matrix will be used to count cycles in the states of the
    % network
    % state_matrix = zeros(matrix_size,matrix_size,20);
    for iteration = 1:no_of_iterations
        all_matrices{iteration} = A;
        % Each node in the network is connected to 3 other nodes (randomly)
        % Here we have 16 genes (in case of a 4x4 matrix), so 16 positions. 
        % Q: can they be connected to itself ? For now, we assume no -- see
        % the while loop below
        neighbours_matrix = {};
        for gene = 1:no_of_genes
            % For each node, give 3 random values between 1 and
            % (matrix_size * matrix_size (number of genes)
            % This only occurs the first iteration (connections stay the
            % same)
            % So K = 3 in this case
            if iteration == 1
                neighbouring_nodes{gene} = randperm(no_of_genes, no_of_connections);
                while ismember(gene, neighbouring_nodes{gene})
                    neighbouring_nodes{gene} = randperm(no_of_genes, no_of_connections);
                end
                % create the adjacency matrix by using the neighboring
                % nodes
                for i = 1:length(neighbouring_nodes{gene})
                    adjacency_matrix(gene,neighbouring_nodes{gene}(i))=1;
                end
                
                % Specific rules for transitioning, specific per gene
                % Permutations of random values: no_of_inputs^no_of_connections
                % e.g. random values with 3 input (-> 8 permutations)
                truth_table_values{gene} = randi([0 1],1, 2^no_of_connections);
                
                % Remove tautology and contradiction
                if (tautology_and_contradiction == 0)
                    contradiction = zeros(size(truth_table_values{gene}));
                    tautology = ones(size(truth_table_values{gene}));
                    while (isequal(truth_table_values{gene},contradiction) || isequal(truth_table_values{gene},tautology))
                        truth_table_values{gene} = randi([0 1],1, 2^no_of_connections);
                    end
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
            new_matrix(gene_update) = truth_table(no_of_connections, neighbours, truth_table_values{gene_update});
        end
        if mod(iteration, 100) == 0
            disp("iteration " + iteration)
        end
        A = new_matrix;
        if visualization == 1
            display_grid(A, iteration)
            pause(0.3)
        end
        
        [found_cycle, last_value] = find_cycle(A, all_matrices);
        if run_to_end == 0 && found_cycle == 1
            disp('Found a cycle! In iteration and with the last value of finding this pattern:')
            iteration
            cycle_length = iteration - last_value
            cycle_cntr = cycle_cntr + 1;
            if cycle_cntr == 1
                break;
            end
        end
    
    end
    
    if visualization == 1
        % display the network as a directed graph by using the adjacency matrix
        figure;
        G = digraph(adjacency_matrix);
        plot(G);
    end
    
    
end

% It should be possible to do this more efficiently, will have a look at it later
function output = truth_table(no_of_connections, neighbours, truth_table_values)
    output = 0;
    if no_of_connections == 2
        output = truth_table2(neighbours, truth_table_values);
    elseif no_of_connections == 3
        output = truth_table3(neighbours, truth_table_values);
    elseif no_of_connections == 4
        output = truth_table4(neighbours, truth_table_values);
    elseif no_of_connections == 1
        output = neighbours;
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
        output = truth_table_values(3);
    elseif neighbours == [1,1]
        output = truth_table_values(4);
    end
end

function output = truth_table4(neighbours, truth_table_values)
    if neighbours == [0,0,0,0]
        output = truth_table_values(1);
    elseif neighbours == [0,0,0,1]
        output = truth_table_values(2);
    elseif neighbours == [0,0,1,0]
        output = truth_table_values(3);
    elseif neighbours == [0,0,1,1]
        output = truth_table_values(4);
    elseif neighbours == [0,1,0,0]
        output = truth_table_values(5);
    elseif neighbours == [0,1,0,1]
        output = truth_table_values(6);
    elseif neighbours == [0,1,1,0]
        output = truth_table_values(7);
    elseif neighbours == [0,1,1,1]
        output = truth_table_values(8);
    elseif neighbours == [1,0,0,0]
        output = truth_table_values(9);
    elseif neighbours == [1,0,0,1]
        output = truth_table_values(10);
    elseif neighbours == [1,0,1,0]
        output = truth_table_values(11);
    elseif neighbours == [1,0,1,1]
        output = truth_table_values(12);
    elseif neighbours == [1,1,0,0]
        output = truth_table_values(13);
    elseif neighbours == [1,1,0,1]
        output = truth_table_values(14);
    elseif neighbours == [1,1,1,0]
        output = truth_table_values(15);
    elseif neighbours == [1,1,1,1]
        output = truth_table_values(16);   
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

