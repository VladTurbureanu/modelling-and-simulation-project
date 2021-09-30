
n = 20; % number of nodes in the graph
density = 0.2; % a rough estimate of the amount of edges       
A = sprand( n, n, density ); % generate adjacency matrix at random
% normalize weights to sum to num of edges
A = tril( A, -1 );    
A = spfun( @(x) x./nnz(A), A );    
% make it symmetric (for undirected graph)
%A = A + A.';

nodevalues = randi([0 1],20,1);
nodenames = string((1:20)');
%T = table(rowTimes,X,Y,'VariableNames',{'Latitude','Longitude'});
NodeTable = table(nodenames,nodevalues,'VariableNames',{'Name','NodeValues'});

G = digraph(A,NodeTable);
plot(G,'NodeLabel',nodevalues);
