classdef TestBinaryMapping < matlab.unittest.TestCase
    methods(Test)
        function thresholdAndEncoding(testCase)
            Cp=[-2 -0.5 -3; -0.5 -2 -0.2];
            T=[-1 -1 -1];
            I=atbm.binaryMap(Cp,T);
            testCase.verifyEqual(I,logical([1 0 1;0 1 0]));
            [state,~,weights]=atbm.encodePatterns(I,true);
            testCase.verifyEqual(weights,[4 2 1]);
            testCase.verifyEqual(state,uint16([5;2]));
            testCase.verifyEqual(atbm.decodePatterns(state,3,true),I);
        end
        function twelveBitKnownPattern(testCase)
            bits=logical([1 1 1 1 1 1 0 0 1 1 1 1]);
            state=atbm.encodePatterns(bits,true);
            testCase.verifyEqual(state,uint16(bin2dec('111111001111')));
        end
        function hierarchy(testCase)
            Cp=[0 -1 -2 -3].';
            level=atbm.hierarchyMap(Cp,-0.5,-1.5,-2.5);
            testCase.verifyEqual(level,[0;1;2;3]);
        end
    end
end
