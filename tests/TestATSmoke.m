classdef TestATSmoke < matlab.unittest.TestCase
    methods(Test)
        function executesAndReturnsFields(testCase)
            rng(1);
            x=-1+0.15*randn(20000,1);
            r=atbm.extractAT(x);
            testCase.verifyTrue(ismember(r.mode,[0 1 2]));
            testCase.verifyTrue(all(ismember({'TL','TR','Tv','SR','valleyRatio','morphology'},fieldnames(r))));
            testCase.verifyGreaterThan(numel(r.x),10);
        end
    end
end
