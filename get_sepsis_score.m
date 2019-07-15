function [score, label] = get_sepsis_score(data, model)


data = DataInterpolationfcn(data, 1:size(data,2), 1);
% data = myNormalization(data);
% size(data)
data = data(:,model.cols);
pihat = mnrval(model.BMatrix,data);
observation_probs = zeros(size(data,1),2);
for t=1:size(data,1)
	Po_correction = mvnpdf(data(t,find(ismember(model.cols,[1]))),cell2mat(model.dist(1)),cell2mat(model.dist(2)));
    observation_probs(t,1) = pihat(t,1);
    observation_probs(t,2) = pihat(t,2);
%     observation_probs(t,1) = (pihat(t,1)*Po_correction)/model.pi_vector(1);
% 	observation_probs(t,2) = (pihat(t,2)*Po_correction)/model.pi_vector(2);
end
T= size(data,1);
delta = ones(T,2)*-inf;
psi = zeros(T,2);
%%%%%%%%%%% Initialization eq(32a,32b) %%%%%%%%%%%%%
delta(1,:)  = model.pi_vector.*observation_probs(1,:);
psi(1,:)    = 0;

%%%%%%%%%%% Recursion eq(33a,33b) %%%%%%%%%%%%%

for t = 2:T
     for j = 1:2
        [delta(t,j), psi(t,j)]=max(delta(t-1,j)*model.aMatrix(:,j)');
        delta(t,j)=delta(t,j)*observation_probs(t,j);
     end
end
% disp('end of for')
%%%%%%%%%%% Termination eq(34a,34b) %%%%%%%%%%%%%
[~,qstarT]  = max(delta(T,:));

 %%%%%%%%%%%%% Path Backtracking eq.(35)%%%%%%%%%%%%
qstar(T) = qstarT;
 for t=T-1:-1:1
     qstar(t) = psi(t+t)* qstar(t+1);
 end

label = qstar(end)-1;
if label ==1
    score =0.9;
else
    score =0.1;

end
% disp('end of ROW')


 
end
