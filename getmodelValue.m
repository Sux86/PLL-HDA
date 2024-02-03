function model_value = getmodelValue(W,source_y,target_y,H,X,X_tt,C,delta)
  I=eye(size(H,1));
  k=max(source_y);
  model_value=0.5*W'*((X*(H+I)*X').*delta)*W+C*sum(max(0,1-(W'*((X*(H+I)*X').*delta))));
end
