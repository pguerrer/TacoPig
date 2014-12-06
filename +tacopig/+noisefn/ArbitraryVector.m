classdef ArbitraryVector < tacopig.noisefn.InputDependent
	properties
		X
		noiseVector
	end

	methods
		function obj = ArbitraryVector
			obj.nPar = 0;
			obj.inputDependentFunc = @(x, par) obj.GetNoiseFromVector(x);
			obj.inputDependentGrad = @(x, par) [];
		end
		function noise = GetNoiseFromVector(obj, x)
			if isequal(obj.X,x)
				noise = obj.noiseVector;
			else
				noise = 0;
			end
		end
	end
	
	% Most noise functions will be static
	methods(Static)
	end
end
