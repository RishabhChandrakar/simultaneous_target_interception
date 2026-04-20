function edges = getTopology(step, n)


% We create a 'Directed Line' (Chain) Topology: 1->2->3->4->5

% Source nodes: 1, 2, 3, 4 ,5
s = [1 2 3 3 5] 
% Target nodes: 2, 3, 4, 5
t = [5 5 1 2 4];

% Combine into an edge list [Source, Target]
edges = [s', t'];

 
% All nodes (1,2,3,4) have a path leading to 5.
end