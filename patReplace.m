function [pattern, isReplaced] = patReplace(pattern, block, anchorPos, constr)
%
%
%by Yaoyi Li
%Jan 14, 2015

[M, N] = size(pattern);
[bM, bN] = size(block);
posM = anchorPos(1);
posN = anchorPos(2);
isReplaced = true;

if posM + bM > M || posN + bN > N
	isReplaced = false;
	return;
end


for cntM = 1 : bM
	for cntN = 1 : bN
		if block(cntM, cntN) == 0
			continue;
		end
		
		pattern(posM + cntM -1, posN + cntN -1) = block(cntM, cntN);
	end
end

%size(pattern)
%size(constr)

pattern = ((constr)&pattern).*pattern;
pattern = ((constr+1)&pattern).*pattern;
