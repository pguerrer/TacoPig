classdef NoisyTrainingSamples < tacopig.noisefn.InputDependent
	properties
        X
	end

	methods
		function obj = NoisyTrainingSamples
            obj.nPar = 0;
			obj.inputDependentFunc = @(x, par, GP) obj.GetNoiseFromSamplesAndGradient(x, GP);
            % \todo: no deberia ser cero (fGradient depende de los hiperparametros):
			obj.inputDependentGrad = @(x, par, GP) []; 
		end
		function SetTrainingSamples(obj, X, SigmaX, sigmaY, ~)
			obj.X = X;
			obj.sigmaY = sigmaY;
            obj.SigmaX = SigmaX;
        end
        function noise = GetNoiseFromSamplesAndGradient(obj, x, GP)
			if isequal(obj.X,x)
                fGradient = Piled_Vertical(GP.gradient(obj.X));
				noise = obj.sigmaY + Piled_Horizontal(mmx('mult', mmx('mult',fGradient,obj.SigmaX), fGradient,'nt'));
			else
				noise = 0;
			end
		end
	end
	
	% Most noise functions will be static
	methods(Static)
	end
end
