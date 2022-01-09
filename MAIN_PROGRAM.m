% --- SOMA Simple Program --- Version: iSOMA (V1.0) August 25, 2020 -------
% ------ Written by: Quoc Bao DIEP ---  Email: diepquocbao@gmail.com   ----
% -----------  See more details at the end of this file  ------------------
clearvars; %clc;
disp('Hello! iSOMA is working, please wait... ')
tic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  U S E R    D E F I N I T I O N
% Define the Cost function, if User want to optimize the other function,
% Please change the function name, for example:  CostFunction = @(pop)      schwefelfcn(pop);
%                                           or:  CostFunction = @(pop)      ackleyfcn(pop);
%                                           or:  CostFunction = @(pop)      periodicfcn(pop);
%CostFunction = @(pop)     schwefelfcn(pop);                                % use this line if: pop size = PopSize x Dimension
CostFunction  = @(pop)     schwefelfcn(pop');                               % use this line if: pop size = Dimension x PopSize
    %--------------- Initial Parameters of SOMA ---------------------------
            SOMApara.PopSize    = 100;                                      % The population size of SOMA
            SOMApara.N_jump     = 10;                                       % The jumping number of each individual
			SOMApara.m     		= 10;                                       % The parameter m
			SOMApara.n     		= 5;                                        % The parameter n
			SOMApara.k     		= 15;                                       % The parameter k
    %----------------------------------------------------------------------
            Info.dimension      = 20;                                       % Define the dimension of the problem
            Info.Search_Range   = [-512 512];                               % Define the search space (lower-upper)
            Info.Max_FEs        = 1e4*Info.dimension;      	                % The unique stop condition of the algorithm
    %       E N D    O F     U S E R
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [Best , FEs , Mig]      = iSOMA(Info,SOMApara,CostFunction);
time = toc;
%% Show the information to User
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(['Stop at Migration :  ' num2str(Mig)])
disp(['The number of FEs :  ' num2str(FEs)])
disp(['Processing time   :  ' num2str(time)])
disp(['The best cost     :  ' num2str(Best.Value)])
disp(['Solution values   :  ']), disp(Best.Positon)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
This algorithm is programmed according to the descriptions in the article:

Link of the article:

https://www.sciencedirect.com/science/article/pii/S1568494621010851

Please cite the article if you refer to them, as follows:

	Quoc Bao Diep, Thanh Cong Truong, Swagatam Das, and Ivan Zelinka. "Self-Organizing Migrating Algorithm with narrowing search space strategy for robot path planning." Applied Soft Computing (2021), doi: https://doi.org/10.1016/j.asoc.2021.108270

OR:
	@article{DIEP2021108270,
	title = {Self-Organizing Migrating Algorithm with narrowing search space strategy for robot path planning},
	journal = {Applied Soft Computing},
	pages = {108270},
	year = {2021},
	issn = {1568-4946},
	doi = {https://doi.org/10.1016/j.asoc.2021.108270},
	url = {https://www.sciencedirect.com/science/article/pii/S1568494621010851},
	author = {Quoc Bao Diep and Thanh Cong Truong and Swagatam Das and Ivan Zelinka}
	}


The control parameters PopSize, N_jump, m, n, and k are closely related 
and greatly affect the performance of the algorithm. Please refer to the 
above paper to use the correct control parameters.

The iSOMA will be adjusted in the near future for faster execution (using Vectorization)
and rebuilt to address more complex computational functions (a few minutes to complete one FEs)
that take advantage of Parallel Computing Toolbox to execute on supercomputer.

The iSOMA is also available in Matlab, python, and C# version, alongside some other versions like SOMA T3A and SOMA Pareto.

If you encounter any problems in executing these codes, please do not hesitate to contact:
Dr. Quoc Bao Diep (diepquocbao@gmaill.com.)

%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LIST OF COST FUNCTIONS (Need to optimize):

% You will replace these functions with your own that describes the problem you need to optimize for.
%--------------------------------------------------------------------------
% Schwefel function:
% schwefelfcn accepts a matrix of size M-by-N and returns a vetor SCORES
% of size M-by-1 in which each row contains the function value for each row of X.
function scores = schwefelfcn(x)
    n = size(x, 2);
    scores = 418.9829 * n - (sum(x .* sin(sqrt(abs(x))), 2));
end
%--------------------------------------------------------------------------
% Ackley function:
% ackleyfcn accepts a matrix of size M-by-N and returns a vetor SCORES
% of size M-by-1 in which each row contains the function value for each row of X.
function scores = ackleyfcn(x)
    n = size(x, 2);
    ninverse = 1 / n;
    sum1 = sum(x .^ 2, 2);
    sum2 = sum(cos(2 * pi * x), 2);
    scores = 20+exp(1)-(20*exp(-0.2*sqrt(ninverse*sum1)))-exp(ninverse*sum2);
end
%--------------------------------------------------------------------------
% Periodic function:
% periodicfcn accepts a matrix of size M-by-N and returns a vetor SCORES
% of size M-by-1 in which each row contains the function value for each row of X.
function scores = periodicfcn(x)
    sin2x = sin(x) .^ 2;
    sumx2 = sum(x .^2, 2);
    scores = 1 + sum(sin2x, 2) -0.1 * exp(-sumx2);
end
