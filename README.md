
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Simulation study to phylogenetic decisiveness

<!-- badges: start -->
<!-- badges: end -->

The goal of PhyloDecR_Simulation is to test random sets with n=6, 7, 8
taxa and compare speed and reply of Fischers Algorithm and the correct
test (Four-way partition property).

**Definition** (Four-way partition property). Let
*S*<sub>*n*</sub> = {*Z*<sub>1</sub>, ..., *Z*<sub>*k*</sub>} be a set
of quadruples of taxa set *X*, \|*X*\| = *n*. Then, *S*<sub>*n*</sub>
satisfies the four-way partition property (for *X*) if, for all
partitions of *X* into four disjoint, nonempty sets
*A*<sub>1</sub>, *A*<sub>2</sub>, *A*<sub>3</sub> and *A*<sub>4</sub>
(with
*A*<sub>1</sub> ∪ *A*<sub>2</sub> ∪ *A*<sub>3</sub> ∪ *A*<sub>4</sub> = *X*)
there exists *a*<sub>*i*</sub> ∈ *A*<sub>*i*</sub> for *i* = 1, 2, 3, 4
for which
{*a*<sub>1</sub>, *a*<sub>2</sub>, *a*<sub>3</sub>, *a*<sub>4</sub>} ∈ *S*<sub>*n*</sub>.

**Theorem** (Theorem 2 of [M. Steel and M.J.
Sanderson](https://www.sciencedirect.com/science/article/pii/S0893965909003000?via%3Dihub)).
A collection *S*<sub>*n*</sub> of quadruples of *X* is phylogenetically
decisive if and only if *S*<sub>*n*</sub> satisfies the four-way
partition property for *X*.

## Planned stuff

Step 1: Create all partitions for n=6, 7, and 8 (these partitions are
fix)

Step 2: Create test function (using input from PhyloDecR package)

Step 3: Run simulations (how many times is PhyloDecR correct?)

## Stirling numbers of the second kind

How many partitions are there?

-   n=6: P=45
-   n=7: ???
-   n=8: P=1701
