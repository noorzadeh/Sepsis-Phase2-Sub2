function InterpData = DataInterpolationfcn(Data,Column, PNum)

InterpData = Data;
for i = 1:length(Column)
    C = Column(i);
    Vec = Data(:,C);
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
        end
    end
    InterpVec = Vec;
    InterpVec(Nant) = InterpNanVec;
   
    InterpData(:,C) = InterpVec;
end