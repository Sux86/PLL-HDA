function [x2,fval2] = solve_svm_qp(X,H,delta,C)
    I=eye(size(H,1));
    Q=(X*(H+I)*X').*delta;
    e=ones(size(delta,1),1);
    options.tmax='10000';
    [x2,fval2] = qpbsvm(double(Q),-e,C,[],[],options);
    % [x2,fval2] = quadprog(double(Q),-e,[],[],[],[],0*e,C*e);
end

