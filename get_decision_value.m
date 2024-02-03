function value=get_decision_value(W,source_y,target_y,H,X,X_tt)
    tmp_label=[source_y;target_y];
    A_matrix=[];
    for i=1:length(tmp_label)
        A=[];
         for cc=1:max(source_y)
             if tmp_label(i)==cc
                 aa=ones(1,max(source_y)-1);
                 bb=zeros(1,max(source_y));
                 bb(cc)=1;
                 bb(tmp_label(i))=[];
             else
                 aa=zeros(1,max(source_y)-1);
                 bb=zeros(1,max(source_y));
                 bb(cc)=1;
                 bb(tmp_label(i))=[];
             end
                
                tmp_A=aa-bb;
             A=[A; tmp_A];
         end
         A_matrix=[A_matrix A];
    end
AA_matrix=A_matrix.*(repmat(W,1,max(source_y))');
I=diag(ones(1,size(H,1)));
value=AA_matrix*X*(H+I)*X_tt;
end
