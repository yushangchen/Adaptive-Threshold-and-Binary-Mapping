classdef TestDataAPI < matlab.unittest.TestCase
    methods(Test)
        function tapOrder(testCase)
            T=atbm.defaultTapTable();
            testCase.verifyEqual(height(T),18);
            bm=sortrows(T(T.UseForBM,:),'BMBitIndex');
            expected=["Cpp90_1D";"Cpn90_1D";"Cpp110_1D";"Cpn110_1D"; ...
                "Cpp90_2D";"Cpn90_2D";"Cpp110_2D";"Cpn110_2D"; ...
                "Cpp90_3_5D";"Cpn90_3_5D";"Cpp110_3_5D";"Cpn110_3_5D"];
            testCase.verifyEqual(bm.VariableName,expected);
        end
        function standardizeLegacyVariables(testCase)
            T=atbm.defaultTapTable(); S=struct();
            for k=1:height(T)
                S.(char(T.VariableName(k)))=zeros(20,3)+k;
            end
            S.Re=[1 2 3]; S.Fs=1000;
            D=atbm.standardizeDataset(S);
            testCase.verifySize(D.alldata,[1 18]);
            testCase.verifyEqual(D.nSamples,20);
            testCase.verifyEqual(D.nCases,3);
            testCase.verifyEqual(atbm.getTap(D,'Cpp90_2D',2),zeros(20,1)+8);
        end
        function calibrationRows(testCase)
            C=atbm.defaultCalibrationTable();
            testCase.verifyEqual(height(C),21);
            testCase.verifyEqual(C.Channel,(7:27).');
        end
    end
end
