# Simulation of Genetic Networks using Random Boolean Networks
Modelling and Simulation Course Project


## Running the code

For one experiment:
```shell
Run: boolean_network_matrix.m
```

For bulk experiments + histogram output:
```shell
cd experiments
Run: run_simulation.m
```

## Parameters
- _matrix_size_: Size of the matrix containing genes, i.e. the number of genes
- _no_of_connections_: Number of input connections per gene
- _no_of_iterations_: Number of updates in the network
- _visualization_: Visualization for the matrix and network structure (on or off)
- _run_to_end_: Run all iterations or break when a cycle is found
- _tautology_and_contradiction_: Whether tautology and contradiction are used 
- _runs_: Number of runs to be performed
