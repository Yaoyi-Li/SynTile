function  symValue = patSymAnaly(pattern, horRelat, verRelat)
%
%by Yaoyi Li
%Feb 2015

[M, N] = size(pattern);

symValue = 0;

for cntStartM = 1:M
	for cntStartN = 1:N
		jumpFlag = false;
		endM = M;
		endN = N;
		
		for cntEndM = cntStartM+1:endM
			if jumpFlag
				break;
			end
			
			for cntEndN = cntStartN+1:endN
				
				box = pattern(cntStartM:cntEndM, cntStartN:cntEndN);
				
				if min(min(box)) == 0
					if cntEndN == 1
						jumpFlag = true;
						break;
					else
						endN = cntEndN - 1;
						break;
					end
				end
				
				isSym = patSymEachBox(box, horRelat, verRelat);
				if isSym 
					symValue = symValue + isSym;
				elseif cntEndN == 1
					jumpFlag = true;
					break;
				else
					endN = cntEndN - 1;
					break;
				end
				
			end
		end
	end
end