
% n = 20; % number of nodes in the graph
% density = 0.2; % a rough estimate of the amount of edges       
% A = sprand( n, n, density ); % generate adjacency matrix at random
% % normalize weights to sum to num of edges
% A = tril( A, -1 );    
% A = spfun( @(x) x./nnz(A), A );    

N = 20;
s = floor(rand(1, N-1) .* (1:N-1)) + 1;
t = 2:N;


nodevalues = randi([0 1],20,1);
nodenames = string((1:20)');
NodeTable = table(nodenames,nodevalues,'VariableNames',{'Name','NodeValues'});
G = digraph(s,t);

plot(G,'NodeLabel',nodevalues);













