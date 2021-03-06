
clear();

CONVOLUTION_SHAPE_FULL  = 1;
CONVOLUTION_SHAPE_SAME  = 2;
CONVOLUTION_SHAPE_VALID = 3;

maxThr = 1e-9;

tic();
for numElementsSignal = 8:21
    
    vI = rand(numElementsSignal, 1);
    
    for numElementsKernel = 1:7
        
        vH = rand(numElementsKernel, 1);
        
        for convShape = 1:3
            
            switch(convShape)
                case(CONVOLUTION_SHAPE_FULL)
                    numElementsOut  = numElementsSignal + numElementsKernel - 1;
                    convShapeString = 'full';
                case(CONVOLUTION_SHAPE_SAME)
                    numElementsOut  = numElementsSignal;
                    convShapeString = 'same';
                case(CONVOLUTION_SHAPE_VALID)
                    numElementsOut  = numElementsSignal - numElementsKernel + 1;
                    convShapeString = 'valid';
            end
            
            vORef   = conv2(vI, vH, convShapeString);
            mK      = GenerateToeplitzConvMatrixEx(vH, numElementsSignal, convShape);
            % mKK      = full(CreateConvMtx1D(vH, numElementsSignal, convShape));
            vO      = reshape(mK * vI, numElementsOut, 1);
            
            disp([' ']);
            disp(['Validating solution for the following parameters:']);
            disp(['Signal Size - [', num2str(numElementsSignal), ' x 1]']);
            disp(['Kernel Size - [', num2str(numElementsKernel), ' x 1]']);
            disp(['Convolution Shape - ', convShapeString]);
            
            vE = vO - vORef;
            maxAbsDev = max(abs(vE(:)));
            if(maxAbsDev >= maxThr)
                disp([' ']);
                disp(['Validation Failed']);
                disp([' ']);
            end
            assert(maxAbsDev < maxThr);
            
        end
    end
end

toc();

