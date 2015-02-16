function miu = factorFun(G, curO, facType, posM, posN)
%Parameter:
%	G			factor graph
%	curO		current pattern 
%	facType		type of factor shape
%	posM		row number of the anchor in the curretn design 
%	posN		column number of the anchor in the curretn design 
%Return:
%	miu			value of factor function
%
%by Yaoyi Li
%Jan 29, 2015

EPSILON = 0.1;
[M, N] = size(curO);

if curO(posM, posN) == -1
	miu = -1;
	return;
end

anchor = curO(posM, posN)+1;

switch facType
	case '2H'
		isFound = false;
		if posN >= N
			miu = 1;
			return;
		end

		fac = curO(posM, posN:posN+1);
		for cnt = 1:numel(G{1}{1}{anchor})
			if isequal(fac, G{1}{1}{anchor}{cnt})
				isFound = true;
			end
		end

		if isFound
			miu = 1;
		else
			miu = 0;
		end

	case '2V'
		isFound = false;
		if posM >= M
			miu = 1;
			return;
		end
		
		fac = curO(posM:posM+1, posN);
		for cnt = 1:numel(G{1}{2}{anchor})
			if isequal(fac, G{1}{2}{anchor}{cnt})
				isFound = true;
			end
		end

		if isFound
			miu = 1;
		else
			miu = 0;
		end

	case '4H'
		isFound = false;
		if posN+3 > N
			miu = 1+EPSILON;
			return;
		end

		fac = curO(posM, posN:posN+3);
		for cnt = 1:numel(G{2}{1}{anchor})
			if isequal(fac, G{2}{1}{anchor}{cnt})
				isFound = true;
			end
		end

		if isFound
			miu = 1+EPSILON;
		else
			miu = 1;
		end

	case '4V'
		isFound = false;
		if posM+3 > M
			miu = 1+EPSILON;
			return;
		end

		fac = curO(posM:posM+3, posN);
		for cnt = 1:numel(G{2}{2}{anchor})
			if isequal(fac, G{2}{2}{anchor}{cnt})
				isFound = true;
			end
		end

		if isFound
			miu = 1+EPSILON;
		else
			miu = 1;
		end

	otherwise
end

