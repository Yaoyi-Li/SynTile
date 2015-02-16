function KLdiv = klDivergence(KLpre, design)
%
%by Yaoyi Li
%Feb 2015


numConst21 = KLpre(1, 1);
numConst22 = KLpre(2, 1);

const21 = KLpre(1:2, 2:numConst21+1);
const22 = KLpre(1:2, numConst21+2:end);

origHist = KLpre(3, 2:end);

newHist = zeros(1,numConst21+numConst22);

for cntFac = 1:numConst21
	tmpFac = const21(:, cntFac);
	tmpFac = tmpFac';
	[M, N] = size(design);
	for cntM = 2:M-1
		for cntN = 2:N-2
			if design(cntM, cntN) == tmpFac(1) && design(cntM, cntN+1) == tmpFac(2)
				newHist(cntFac) = newHist(cntFac)+1;
			end
		end
	end
end

for cntFac = 1:numConst22
	tmpFac = const22(:, cntFac);
	[M, N] = size(design);
	for cntM = 2:M-2
		for cntN = 2:N-1
			if design(cntM, cntN) == tmpFac(1) && design(cntM+1, cntN) == tmpFac(2)
				newHist(cntFac+numConst21) = newHist(cntFac+numConst21)+1;
			end
		end
	end
end

newHist = newHist./sum(newHist);

KLdiv = 0;

for cntHist = 1:numConst21+numConst22
	if newHist(cntHist) == 0 || origHist(cntHist) == 0
		continue;
	end
	KLdiv = KLdiv + newHist(cntHist)*log(newHist(cntHist)/origHist(cntHist));
end

