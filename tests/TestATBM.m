classdef TestATBM < matlab.unittest.TestCase
methods(Test)
 function binaryMap(t)
  t.verifyEqual(atbm.buildBinaryMap([-1.2 -0.5;-0.8 -1.5],[-1 -1]),logical([1 0;0 1]));
 end
 function encoding(t)
  B=logical([0 0 0 0;1 0 0 0;1 1 1 1;0 1 0 1]);
  t.verifyEqual(atbm.encodePatterns(B),[0;8;15;5]);
 end
 function hierarchy(t)
  H=atbm.buildHierarchy([-0.5 -1.2 -2.2 -2.8],repmat(-0.975,1,4), ...
   repmat(-1.975,1,4),repmat(-2.475,1,4));
  t.verifyEqual(H,uint8([0 1 2 3]));
 end
 function recordSAI(t)
  B=logical([1 0 0 0;1 1 0 0;0 0 0 0]);
  tab=table(("T"+(1:4))',[1;1;1;1],[90;-90;110;-110],[1;-1;1;-1], ...
   ones(4,1),(1:4)',"VariableNames",["TapID","zD","thetaDeg","Side","HeightGroup","BitIndex"]);
  m=atbm.computeMetrics(B,tab); t.verifyEqual(m.SAI,1/3,"AbsTol",1e-12);
 end
 function separatedPDF(t)
  cfg=atbm.defaultConfig(); rng(1);
  x=[-1.9+0.08*randn(15000,1);-0.6+0.08*randn(15000,1)];
  a=atbm.analyzeLocalSignal(x,cfg);
  t.verifyEqual(a.classification.type,"bimodal-separated");
 end
end
end
