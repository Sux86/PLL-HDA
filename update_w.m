function [W_star,H_star,delta] = update_w(X,source_x,source_y,target_x,target_y,C,X_decison,lambda,H)


k=max(source_y);
dim_num=size(source_x,2)+size(target_x,2);

H=(lambda/dim_num)*diag(ones(1,size(source_x,2)+size(target_x,2)));
tic;
delta=calcute_delta([source_y;target_y],k);
toc;
t=0;
[W,~]=solve_svm_qp(X,H,delta,C); 

fun=@(X,H,delta,W) -0.5*W'*((X*(H+eye(size(H,1)))*X').*delta)*W+sum(W);

while t<=50
        W_=W;

        % Amjo 
        rate=0.1;
        hat_H=-0.5*(X'*diag(W)*double(delta)*diag(W)*X);

        while fun(X,H-rate*hat_H,delta,W)>fun(X,H,delta,W)
            rate = rate * 0.5; 
        end
        tmp_H=H-rate*hat_H;

        tmp_H=real(fix_trace(tmp_H,lambda));
        [tmp_W,~]=solve_svm_qp(X,tmp_H,delta,C);
        t=t+1;

     if norm(W_-tmp_W)^2<=1e-3
         W_star=tmp_W;
         H_star=tmp_H;
         break;
     else
         W=tmp_W;
         H=tmp_H;
     end
 W_star=tmp_W;
 H_star=H;
end
end
