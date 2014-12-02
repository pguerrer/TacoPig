classdef NoisyTrainingSamples < tacopig.noisefn.ArbitraryVector
	properties

	end

	methods
		function obj = NoisyTrainingSamples
		end
		function SetTrainingSamples(obj, X, SigmaX, sigmaY, GP)
			obj.X = X;
			fGradient = GP.gradient(X);
			obj.noiseVector = sigmaY + Piled_Horizontal(mmx('mult', mmx('mult',fGradient',SigmaX), fGradient));
		end
	end
	
	% Most noise functions will be static
	methods(Static)
	end
end
