%  i S O M A
function [Best , FEs , Mig] = iSOMA(Info , SOMApara , CostFunction)
    % -------------- Extract Information ----------------------------------
    PopSize    = SOMApara.PopSize;        Step     = 0.3;
    Max_FEs    = Info.Max_FEs;            N_jump   = SOMApara.N_jump;
    dimension  = Info.dimension;          m        = SOMApara.m;
    n          = SOMApara.n;              k        = SOMApara.k;
    VarMin     = Info.Search_Range(1);    VarMax   = Info.Search_Range(2);
    % --------------------- Create Initial Population ---------------------
    pop        = VarMin + rand(dimension,PopSize)*(VarMax - VarMin);
    fit        = CostFunction(pop)';
    FEs        = PopSize;
    [global_cost, id] = min(fit);
    global_pos = pop(:,id);
    % ---------------- SOMA MIGRATIONS ------------------------------------
    Mig = 0; Count = 0; global_cost_old = global_cost;
    while (FEs+N_jump < Max_FEs)
        Mig     = Mig + 1;
        %------------- Migrant selection: m -------------------------------
        M       = randperm(PopSize,m);
        sub_M   = [fit(M) ; pop(:,M) ; M];
        sub_M   = sortrows(sub_M')';
        fit_M   = sub_M(1,:);
        pop_M   = sub_M(2:end-1,:);
        order_M = sub_M(end,:);
        %------------- movement of n Migrants -----------------------------
        for j   = 1 : n
            Migrant = pop_M(:,j);
            %------------- Leader selection: k ----------------------------
            K       = randperm(PopSize,k);
            sub_K   = [fit(K) ; pop(:,K) ; K];
            sub_K   = sortrows(sub_K')';
            pop_K   = sub_K(2:end-1,:);
            order_K = sub_K(end,:);
            Leader  = pop_K(:,1);
            if order_M(j) == order_K(1)
                Leader  = pop_K(:,2);
            end
            % ------ Migrant move to Leader: Jumping ----------------------
            flag = 0; move = 1;
            while (flag == 0) && (move <= N_jump)
                nstep     = (N_jump-move+1) * Step;
                % ------ Update Control parameters: PRT -------------------
                PRT       = 0.1 + 0.9*(FEs / Max_FEs);
                %----- SOMA Mutation --------------------------------------
                PRTVector = rand(dimension,1) < PRT;
                %PRTVector = (PRTVector-1)*(1-0.5*FEs/Max_FEs)+1;
                %----- SOMA Crossover -------------------------------------
                offspring = Migrant+(Leader-Migrant)*nstep.*PRTVector;
                %----- Checking Boundary and Replaced Outsize Individuals -
                for rw = 1 : dimension
                    if  (offspring(rw) < VarMin) || (offspring(rw) > VarMax)
                         offspring(rw) = VarMin  +  rand*(VarMax - VarMin);
                    end
                end
				%----- SOMA Re-Evaluate Fitness Fuction + Count FEs -------
				new_cost  = CostFunction(offspring);
				FEs       = FEs + 1;
				%----- SOMA Accepting: Place the Best Offspring to Pop ----
				if  new_cost         <= fit_M(j)
					flag              = 1;
					pop(:,order_M(j)) = offspring;
					fit(order_M(j))   = new_cost;
					%----- Update Global_Leader and Calculate error -------
					if  new_cost     <= global_cost
						global_cost   = new_cost;
						global_pos    = offspring;
                    else
                        Count         = Count + 1;                        
					end
				end
                move    = move + 1;
            end % END JUMPING
        end  % END PopSize   (For Loop)
		%------------------------
        if Count > PopSize*10
            if global_cost == global_cost_old
                rat         = round(0.1*PopSize);
                pop_temp    = VarMin + rand(dimension,rat)*(VarMax - VarMin);
                fit_temp    = CostFunction(pop_temp);
                FEs         = FEs + rat;
                D           = randperm(PopSize,rat);
                pop(:,D)    = pop_temp;
                fit(D)      = fit_temp;
            else
                global_cost_old = global_cost;
            end
            Count = 0;
        end
    end   % END MIGRATIONS (While Loop)
    Best.Value      = global_cost;
    Best.Positon    = global_pos;
end