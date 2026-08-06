%VALIDATE_SR_VR_SENSITIVITY
% Evaluate whether the separated/overlapped decision depends on narrowly
% tuned SR and VR cutoffs. The representative PDFs are generated once; the
% resulting SR and VR values are evaluated over a +/-20% criterion grid.

setup;
if ~isfolder("results"), mkdir("results"); end
if ~isfolder("figures"), mkdir("figures"); end

cfg = atbm.defaultConfig();
rng(cfg.randomSeed);

signals = {
    [-1.90 + 0.08*randn(25000,1); -0.60 + 0.08*randn(25000,1)], ...
    [-1.25 + 0.24*randn(26000,1); -0.90 + 0.24*randn(24000,1)]};
caseNames = ["bimodal-separated","bimodal-overlapped"];

nominalSR = 1.5;
nominalVR = 0.8;
srCutoffs = nominalSR * [0.8 1.0 1.2];
vrCutoffs = nominalVR * [0.8 1.0 1.2];

Case = strings(0,1);
SRCutoff = zeros(0,1);
VRCutoff = zeros(0,1);
DecisionCode = zeros(0,1);
Decision = strings(0,1);
ObservedSR = zeros(0,1);
ObservedVR = zeros(0,1);
decisionMaps = cell(1,2);

for c = 1:2
    analysis = atbm.analyzeLocalSignal(signals{c},cfg);
    observedType = string(analysis.classification.type);
    if observedType ~= caseNames(c)
        error("ATBM:UnexpectedSyntheticMorphology", ...
            "Expected %s but observed %s.", ...
            char(caseNames(c)),char(observedType));
    end

    sr = analysis.classification.SR;
    vr = analysis.classification.VR;
    M = zeros(numel(srCutoffs),numel(vrCutoffs));

    for i = 1:numel(srCutoffs)
        for j = 1:numel(vrCutoffs)
            isSeparated = sr >= srCutoffs(i) && vr <= vrCutoffs(j);
            if isSeparated
                code = 1;
                label = "bimodal-separated";
            else
                code = 2;
                label = "bimodal-overlapped";
            end
            M(i,j) = code;

            Case(end+1,1) = caseNames(c); %#ok<SAGROW>
            SRCutoff(end+1,1) = srCutoffs(i); %#ok<SAGROW>
            VRCutoff(end+1,1) = vrCutoffs(j); %#ok<SAGROW>
            DecisionCode(end+1,1) = code; %#ok<SAGROW>
            Decision(end+1,1) = label; %#ok<SAGROW>
            ObservedSR(end+1,1) = sr; %#ok<SAGROW>
            ObservedVR(end+1,1) = vr; %#ok<SAGROW>
        end
    end
    decisionMaps{c} = M;
end

T = table(Case,SRCutoff,VRCutoff,DecisionCode,Decision,ObservedSR,ObservedVR);
writetable(T,"results/validation_sr_vr_sensitivity.csv");

f = figure("Color","w","Position",[100 100 1100 450]);
for c = 1:2
    subplot(1,2,c);
    imagesc(vrCutoffs,srCutoffs,decisionMaps{c});
    axis xy;
    caxis([0.5 2.5]);
    colormap(parula(2));
    hold on;
    plot(nominalVR,nominalSR,"kp","MarkerFaceColor","w", ...
        "MarkerSize",13,"LineWidth",1.5);
    for i = 1:numel(srCutoffs)
        for j = 1:numel(vrCutoffs)
            text(vrCutoffs(j),srCutoffs(i), ...
                num2str(decisionMaps{c}(i,j)), ...
                "HorizontalAlignment","center","FontWeight","bold");
        end
    end
    xlabel("VR cutoff");
    ylabel("SR cutoff");
    title(sprintf("(%c) %s case", ...
        char('a'+c-1),char(caseNames(c))),"Interpreter","none");
    cb = colorbar;
    cb.Ticks = [1 2];
    cb.TickLabels = {"Separated","Overlapped"};
    box on;
end
if exist("sgtitle","file") == 2
    sgtitle("Sensitivity of PDF modality decision to SR/VR criteria");
end
saveValidationFigure(f,"figures/validation_sr_vr_sensitivity.png");

fprintf("SR/VR sensitivity validation completed.\n");

function saveValidationFigure(f,path)
    if exist("exportgraphics","file") == 2
        exportgraphics(f,path,"Resolution",300);
    else
        print(f,path,"-dpng","-r300");
    end
end
