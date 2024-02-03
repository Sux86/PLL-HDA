function initLabel = update_ground_truth(decisionValue,train_target,labelNumVec)
[label_num,ins_num] = size(decisionValue);
cost = full(decisionValue).*(full(train_target));
cost(train_target==0) = -1e5;
cvx_begin quiet
cvx_solver mosek
     variable y(label_num,ins_num);
     maximize(sum(sum(cost.*y)));
     subject to
     sum(y)==ones(1,ins_num);
     sum(y,2) == labelNumVec;
     y>=0;
cvx_end
[~,initLabel] = max(y);
initLabel = initLabel';
end

