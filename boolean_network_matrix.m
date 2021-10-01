function main()
    % Each node in the network has a boolean variable attached to it (0 or 1)
    A = rand(4,4)>.7 % Increase number for less ones, decrease for more.

    B = rand(4,4)>.7;
    % Check if we have a cycle
    % Useless now, this is for later
    if A == B
        disp('yes')
    else 
        disp('no')
    end
    
    neighbouring_nodes = {};
    for iteration = 1:20
        % Each node in the network is connected to 3 other nodes (randomly)
        % Here we have 16 genes, so 16 positions. 
        % Q: can they be connected to itself ? For now, we assume yes because it's
        % simpler
        
        neighbours_matrix = {};
        for gene = 1:16
            % For each node, give 3 random values between 1 and 16
            % This only occurs the first iteration (connections stay the
            % same)
            % So K = 3 in this case
            if iteration == 1
                neighbouring_nodes{gene} = randperm(16,3);
            end
            
            % Get the binary values of the neighbours
            % This happens every iteration
            binary_values = [];
            for i = 1:length(neighbouring_nodes{gene})
                binary_values(i) = A(neighbouring_nodes{gene}(i));
            end
            binary_values;
            neighbours_matrix{gene} = binary_values;
        end
        % print C and an element in C
        neighbours_matrix;
        for j = 1:16
            neighbours_matrix{j};
        end

        % Specific rules for transitioning
        % Random values with 3 input (-> 8 permutations)
        truth_table_values = randi([0 1],1,8);
        new_matrix = zeros(4);
        % Synchronous update (think so). 
        for gene_update = 1:16
            neighbours = neighbours_matrix{gene_update};
            new_matrix(gene_update) = truth_table(neighbours, truth_table_values);
        end
        disp("iteration " + iteration + ":")
        A = new_matrix
        display_grid(A, iteration)
        pause(0.3)

    end
    %display_grid(A)

end

function output = truth_table(neighbours, truth_table_values)
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

% Based on https://stackoverflow.com/questions/3280705/how-can-i-display-a-2d-binary-matrix-as-a-black-white-plot
function display_grid(A, iteration)
    cMap = [1 0 0; 0 0.8 0];
    [r, c] = size(A);                          % Get the matrix size
    imagesc((1:c)+0.5, (1:r)+0.5, A);          % Plot the image
    % cMap
    colormap(cMap);                              % Use a gray colormap
    axis equal                                   % Make axes grid sizes equal
    set(gca, 'XTick', 1:(c+1), 'YTick', 1:(r+1), ...  % Change some axes properties
             'XLim', [1 c+1], 'YLim', [1 r+1], ...
             'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');
   % hold on
    %legend('on', 'off')
    %hold on
    title(['Iteration ', num2str(iteration)])
end


