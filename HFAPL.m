function Acc=HFAPL(source_x,source_y,target_x,target_p,C,target_test_x,target_test_y,lambda)
    ins_num = size(target_x,1);
    label_num = size(target_p,1);
    confident = target_p./repmat(sum(target_p),label_num,1);
    sumConfident = full(sum(confident,2));
    labelNumVec = floor(sumConfident);
    sorted = sortrows([sumConfident,(1:label_num)']);
    for itemLabel = 1:ins_num-sum(labelNumVec)
        labelNumVec(round(sorted(itemLabel,2))) = labelNumVec(round(sorted(itemLabel,2))) + 1;
    end
    
    X=[kron(source_x,ones(max(source_y)-1,1)) zeros(size(source_x,1)*(max(source_y)-1),size(target_x,2));
   zeros(size(target_x,1)*(max(source_y)-1),size(source_x,2)) kron(target_x,ones(max(source_y)-1,1))];
    X_decison=[source_x zeros(size(source_x,1),size(target_x,2));
                zeros(size(target_x,1),size(source_x,2)) target_x];

    X_t=[zeros(size(target_x,1),size(source_x,2)) target_x];
    X_tt=[zeros(size(target_test_x,1),size(source_x,2)) target_test_x];
    target_y=update_ground_truth(-confident,target_p,labelNumVec);
    
    num=size(X,2);


    H=(lambda/num)*diag(ones(1,size(source_x,2)+size(target_x,2)));
    Acc=[];
    flag=0;
    C_tmp=C*1e-3;
    iter=0;
    while iter<=20
% %update w and H
    if C_tmp==C
           flag = 1;
    end
        tmp_model_value=0;
        for ite=1:5
            [W,H,delta]=update_w(X,source_x,source_y,target_x,target_y,C_tmp,X_decison,lambda,H);
            pre_decision_value=get_decision_value(W,source_y,target_y,H,X,X_tt');
            tmp_acc=calcute_acc(pre_decision_value,target_test_y);
            Acc=[Acc;tmp_acc];
            
            modelvalue=getmodelValue(W,source_y,target_y,H,X,X_decison,C,delta);
               
                if abs(tmp_model_value-modelvalue)/abs(tmp_model_value)<=1e-4 
                     tmp_model_value=modelvalue;
                     break;
                else
                    tmp_model_value=modelvalue;
                    ite=ite+1;
                end
        
                %update y
                decision_value=get_decision_value(W,source_y,target_y,H,X,X_t');
                xi_margin=get_xi_margin(decision_value);
                target_y=update_ground_truth(-xi_margin,target_p,labelNumVec);
        end
        if flag==1
            break;
        end
        C_tmp=min(C_tmp*1.5,C);
        iter=iter+1;
    end
end
function acc=calcute_acc(decision_value,target_test_y)
     %predict
        [~,pre_label]=max(decision_value);
        [~,bb]=find(target_test_y==1);
        aa=bb'-pre_label;
        acc=size(find(aa==0),2)/size(target_test_y,1);
        disp(acc);
end
function xi_margin=get_xi_margin(decision_value)
    xi_margin=[];
    for i=1:size(decision_value,2)
        margin=[];
        for j=1:size(decision_value,1) 
            tmp_margin=[];
            for k=1:size(decision_value,1)  
                tmp=max(0,1-(decision_value(j,i)-decision_value(k,i))); 
                tmp_margin=[tmp_margin tmp];
            end
            margin=[margin; sum(tmp_margin)-1]; 
        end
        xi_margin=[xi_margin margin];
    end
end
