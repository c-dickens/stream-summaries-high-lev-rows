# Data Stream Summaries using High Leverage Rows

This repository contains the code used for the experiments in _Leveraging Well-Conditioned Bases: Streaming and Distributed Summaries in Minkowski $p$-Norms_ to be published at ICML 2018.

The general idea is to read a stream of data and keep a small amount of the data in memory.  
This small summary is gradually updated with more 'important' rows of data where the importance
 is measure by the contribution that a row of data makes to the overall shape of the data (this
is the part on levarge scores and well-conditioned bases from the paper).

### Example usage:

1. Clone/download repo and add to path.
2. Navigate to experiment script i.e `scripts/census/regression`
3. Run `main.m` or corresponding experiment name
4. Run `uniform_sampling.m`
5. Generate plots using `Plots for census experiments.ipynb` in `figures` directory.


### Notes

* Different experimental setups can be used by varying test inputs in `parameters.mat`.

* Any experiment requiring the `YearPredictionMSD` dataset requires the data to be downloaded from
the UCI ML data repo (https://archive.ics.uci.edu/ml/datasets/yearpredictionmsd).
The data should be located in the `/data` directory and then transformed into a `.mat`
file of the form `[A,b]` where `A` is the sample-by-feature design matrix and `b` is the target
vector.  Ensure that the name of the `.mat` file is `years_data.mat` so that it matches the 
`data_path` as described in `parameters.mat`

* The exponents for leverage thresholding differ depending on the norm used.  
For example, when computing an orthonormal basis we can use threshold of d / block_size
 for every threshold but tor an \ell_1 wcb we need to use d^1.5 / block_size.
This is dealt with in the code for these two cases and the baselines.

* Some of the code in `functions` are taken from https://github.com/chocjy/randomized-quantile-regression-solvers to generate the `ell_1` well-conditioned bases.


### License

Copyright 2018 Charlie Dickens

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

### Reference

The BibTex reference is available at: http://proceedings.mlr.press/v80/cormode18a.html


