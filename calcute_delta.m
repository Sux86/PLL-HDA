function delta_matrix= calcute_delta(ground,k)

ground_truth=kron(ground,ones(k-1,1));

m=[];
for i=1:size(ground,1)
    tmp_c=1:1:k;
    tmp_c(ground(i))=[];
    m=[m,tmp_c];
end
delta_matrix=[];
parfor i=1:size(ground_truth,1)
    tmp_matrix=[];
    for j=1:size(ground_truth,1)
        
        if ground_truth(i)==ground_truth(j)
            yy=1;  
        else
            yy=0;
        end
        if m(i)==m(j)
            mn=1;  
        else
            mn=0;
        end
        if ground_truth(i)==m(j)
            yn=1;  
        else
            yn=0;
        end
        if ground_truth(j)==m(i)
            ym=1;  
        else
            ym=0;
        end
        tmp=yy+mn-yn-ym;
        tmp_matrix=[tmp_matrix tmp];
    end
    delta_matrix=[delta_matrix; tmp_matrix];
end
end
