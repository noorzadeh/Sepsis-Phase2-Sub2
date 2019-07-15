function [InterpData, allnan] = DataInterpolationfcn(Data,Column, PNum)

allnan =0;
InterpData = Data;
for i = 1:length(Column)
    C = Column(i);
    Vec = Data(:,C);
    j=1;
    while(isnan(Vec(j)) && j<length(Vec))
        j=j+1;
    end
    Vec(1:j-1)=Vec(j);
    
    j=length(Vec);
    while(j>0 && isnan(Vec(j)))
        j=j-1;
    end
    if j~=0
        Vec(j+1:end)=Vec(j);
    end
    
    
    t = 1:length(Vec);
    NonNanVec = Vec(~isnan(Vec));
    NonNant = t(~isnan(Vec));
    Nant = t(isnan(Vec));
    
    % InterpNanVec = csapi(NonNant, NonNanVec, Nant);
    try
        InterpNanVec = interp1(NonNant,NonNanVec,Nant,'pchip');
    catch
        if ~isempty(NonNanVec)
%             disp(['Only One NonNan: ',num2str(PNum),',',num2str(C)]);
            InterpNanVec = ones(size(Nant))*NonNanVec;
        else
%             disp(['  AllNan: ',num2str(PNum),',',num2str(C)]);
            InterpNanVec = zeros(size(Nant));
            allnan =1;
        end
    end
    InterpVec = Vec;
    InterpVec(Nant) = InterpNanVec;
   
    InterpData(:,C) = InterpVec;
end