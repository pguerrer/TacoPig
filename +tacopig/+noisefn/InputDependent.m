classdef InputDependent < tacopig.noisefn.NoiseFunc
   
	properties
		nPar,
		inputDependentFunc,
		inputDependentGrad
	end
	
	methods
		function n_theta = npar(obj, ~)
            n_theta = obj.nPar;
		end
		function noise = eval(obj, X, GP)
             par = tacopig.noisefn.NoiseFunc.getNoisePar(GP);
             noise = diag(obj.inputDependentFunc(X,par,GP));
        end
        
        function [g] = gradient(obj, X, GP)
             par = tacopig.noisefn.NoiseFunc.getNoisePar(GP);
			 if (isempty(obj.inputDependentGrad))
				 g=[];
			 else
				g = diag(obj.inputDependentGrad(X,par,GP));
			 end
        end
	end
	
    % Most noise functions will be static
    methods(Static) 
        
    end
    
end
