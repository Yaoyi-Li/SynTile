function KLpre = klPreprocee(inPatt, G)
%
%by Yaoyi Li
%Feb 2015

constr21 = [0;0];
constr22 = [0;0];

for cntAnc = 1:numel(G{1}{1})
	for cntTiles = 1:numel(G{1}{1}{cntAnc})
		tmpConstr = G{1}{1}{cntAnc}{cntTiles};
		if tmpConstr(1) ~= 0 && tmpConstr(2) ~= 0
			constr21 = [constr21, tmpConstr'];
		end
	end
end

for cntAnc = 1:numel(G{1}{2})
	for cntTiles = 1:numel(G{1}{2}{cntAnc})
		tmpConstr = G{1}{2}{cntAnc}{cntTiles};
		if tmpConstr(1) ~= 0 && tmpConstr(2) ~= 0
			constr22 = [constr22, tmpConstr];
		end
	end
end

numCons21 = size(constr21, 2)-1;
numCons22 = size(constr22, 2)-1;

KLpre = [numCons21;numCons22];

KLpre = [KLpre, constr21(:,2:end), constr22(:,2:end)];

hist = zeros(1,numCons21+numCons22);

for cntFac = 1:numCons21
	tmpFac = constr21(:, cntFac);
	tmpFac = tmpFac';
	for cntPatt = 1:numel(inPatt)
		tmpPatt = inPatt{cntPatt};
		[M, N] = size(tmpPatt);
		for cntM = 2:M-1
			for cntN = 2:N-2
				if tmpPatt(cntM, cntN) == tmpFac(1) && tmpPatt(cntM, cntN+1) == tmpFac(2)
					hist(cntFac) = hist(cntFac)+1;
				end
			end
		end
	end
end

for cntFac = 1:numCons22
	tmpFac = constr22(:, cntFac);
	for cntPatt = 1:numel(inPatt)
		tmpPatt = inPatt{cntPatt};
		[M, N] = size(tmpPatt);
		for cntM = 2:M-2
			for cntN = 2:N-1
				if tmpPatt(cntM, cntN) == tmpFac(1) && tmpPatt(cntM+1, cntN) == tmpFac(2)
					hist(cntFac+numCons21) = hist(cntFac+numCons21)+1;
				end
			end
		end
	end
end

hist = hist./sum(hist);

hist = [0, hist];

KLpre = [KLpre; hist];
