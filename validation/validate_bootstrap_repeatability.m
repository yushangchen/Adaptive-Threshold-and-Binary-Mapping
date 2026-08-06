%VALIDATE_BOOTSTRAP_REPEATABILITY
% Perform an m-out-of-n bootstrap repeatability test for representative PDF
% morphologies. Each realization draws 80% of the original record length
% with replacement. The test evaluates numerical extraction repeatability,
% not physical stationarity or temporal dependence.

setup;
if ~isfolder("results"), mkdir("results"); end
if ~isfolder("figures"), mkdir("figures"); end

cfg = atbm.defaultConfig();
rng(cfg.randomSeed);

signals = {
    -0.80 + 0.12*randn(50000,1), ...
    [-1.90 + 0.08*randn(25000,1); -0.60 + 0.08*randn(25000,1)], ...
    [-1.25 + 0.24*randn(26000,1); -0.90 + 0.24*randn(24000,1)]};
caseNames = ["unimodal","bimodal-separated","bimodal-overlapped"];

nRealizations = 200;
resampleFraction = 0.80;

Case = strings(0,1);
Realization = zeros(0,1);
Candidate = strings(0,1);
FullThreshold = zeros(0,1);
BootstrapThreshold = zeros(0,1);
NormalizedDeviationPctIQR = zeros(0,1);
ExpectedMorphology = strings(0,1);
ObservedMorphology = strings(0,1);

RetentionCase = strings(0,1);
RetentionRealization = zeros(0,1);
RetentionExpectedMorphology = strings(0,1);
RetentionObservedMorphology = strings(0,1);
Retained = false(0,1);

for c = 1:numel(signals)
    x = signals{c};
    fullAnalysis = atbm.analyzeLocalSignal(x,cfg);
    expectedType = string(fullAnalysis.classification.type);
    if expectedType ~= caseNames(c)
        error("ATBM:UnexpectedSyntheticMorphology", ...
            "Expected %s but observed %s.", ...
            char(caseNames(c)),char(expectedType));
    end

    [fullNames,fullValues] = selectedCandidates(fullAnalysis);
    q = prctile(x,[25 75]);
    signalIQR = q(2)-q(1);
    if signalIQR <= 0
        error("ATBM:ZeroIQR","Representative signal has zero IQR.");
    end

    m = max(1,round(resampleFraction*numel(x)));
    for r = 1:nRealizations
        idx = randi(numel(x),m,1); % with replacement: m-out-of-n bootstrap
        bootAnalysis = atbm.analyzeLocalSignal(x(idx),cfg);
        observedType = string(bootAnalysis.classification.type);

        RetentionCase(end+1,1) = caseNames(c); %#ok<SAGROW>
        RetentionRealization(end+1,1) = r; %#ok<SAGROW>
        RetentionExpectedMorphology(end+1,1) = expectedType; %#ok<SAGROW>
        RetentionObservedMorphology(end+1,1) = observedType; %#ok<SAGROW>
        Retained(end+1,1) = observedType == expectedType; %#ok<SAGROW>

        if observedType ~= expectedType
            continue;
        end

        [bootNames,bootValues] = selectedCandidates(bootAnalysis);
        for k = 1:numel(fullNames)
            match = find(bootNames == fullNames(k),1);
            if isempty(match) || ~isfinite(bootValues(match))
                continue;
            end

            Case(end+1,1) = caseNames(c); %#ok<SAGROW>
            Realization(end+1,1) = r; %#ok<SAGROW>
            Candidate(end+1,1) = fullNames(k); %#ok<SAGROW>
            FullThreshold(end+1,1) = fullValues(k); %#ok<SAGROW>
            BootstrapThreshold(end+1,1) = bootValues(match); %#ok<SAGROW>
            NormalizedDeviationPctIQR(end+1,1) = ...
                100*(bootValues(match)-fullValues(k))/signalIQR; %#ok<SAGROW>
            ExpectedMorphology(end+1,1) = expectedType; %#ok<SAGROW>
            ObservedMorphology(end+1,1) = observedType; %#ok<SAGROW>
        end
    end
end

T = table(Case,Realization,Candidate,FullThreshold,BootstrapThreshold, ...
    NormalizedDeviationPctIQR,ExpectedMorphology,ObservedMorphology);
writetable(T,"results/validation_bootstrap_repeatability.csv");

retentionTable = table(RetentionCase,RetentionRealization, ...
    RetentionExpectedMorphology,RetentionObservedMorphology,Retained, ...
    "VariableNames",["Case","Realization","ExpectedMorphology", ...
    "ObservedMorphology","Retained"]);
writetable(retentionTable, ...
    "results/validation_bootstrap_morphology_retention.csv");

summaryTable = buildSummaryTable(T);
writetable(summaryTable, ...
    "results/validation_bootstrap_repeatability_summary.csv");

f = figure("Color","w","Position",[100 100 1250 470]);
for c = 1:numel(caseNames)
    subplot(1,3,c);
    idxCase = T.Case == caseNames(c);
    candidateNames = unique(T.Candidate(idxCase),"stable");
    hold on;
    for k = 1:numel(candidateNames)
        y = T.NormalizedDeviationPctIQR( ...
            idxCase & T.Candidate==candidateNames(k));
        if isempty(y), continue; end
        xj = k + linspace(-0.14,0.14,numel(y))';
        plot(xj,y,'.',"MarkerSize",5);
        quart = prctile(y,[25 50 75]);
        plot([k-0.20 k+0.20],[quart(2) quart(2)],"k-","LineWidth",2);
        plot([k k],[quart(1) quart(3)],"k-","LineWidth",4);
    end
    yline(0,"k-");
    xlim([0.5 max(1.5,numel(candidateNames)+0.5)]);
    set(gca,"XTick",1:numel(candidateNames), ...
        "XTickLabel",cellstr(candidateNames));
    ylabel("Normalized deviation (% IQR)");
    retainedCount = sum(retentionTable.Case==caseNames(c) & ...
        retentionTable.Retained);
    title(sprintf("(%c) %s, retained %d/%d", ...
        char('a'+c-1),char(caseNames(c)),retainedCount,nRealizations), ...
        "Interpreter","none");
    grid on;
    box on;
end
if exist("sgtitle","file") == 2
    sgtitle("Bootstrap repeatability of AT-derived thresholds");
end
saveValidationFigure(f, ...
    "figures/validation_bootstrap_repeatability.png");

fprintf("Bootstrap repeatability validation completed.\n");

function [names,values] = selectedCandidates(analysis)
    type = string(analysis.classification.type);
    C = analysis.candidates;

    if type == "bimodal-overlapped"
        [value,found] = firstExistingField(C,["Tv","TV","TValley","Valley"]);
        if ~found
            error("ATBM:MissingValleyCandidate", ...
                "No valley-candidate field was found in analysis.candidates.");
        end
        names = "Tv";
        values = value;
    else
        if ~(isfield(C,"TL") && isfield(C,"TR"))
            error("ATBM:MissingKneeCandidates", ...
                "TL and TR are required for %s.",char(type));
        end
        names = ["TL","TR"];
        values = [C.TL,C.TR];
    end

    values = double(values(:)');
    names = names(:)';
end

function [value,found] = firstExistingField(S,candidates)
    value = NaN;
    found = false;
    for i = 1:numel(candidates)
        field = char(candidates(i));
        if isfield(S,field)
            value = S.(field);
            found = true;
            return;
        end
    end
end

function S = buildSummaryTable(T)
    keyTable = unique(T(:,["Case","Candidate"]),"rows","stable");
    nRows = height(keyTable);
    Count = zeros(nRows,1);
    MedianDeviationPctIQR = nan(nRows,1);
    IQRDeviationPctIQR = nan(nRows,1);
    MaxAbsDeviationPctIQR = nan(nRows,1);

    for i = 1:nRows
        idx = T.Case==keyTable.Case(i) & ...
            T.Candidate==keyTable.Candidate(i);
        y = T.NormalizedDeviationPctIQR(idx);
        Count(i) = numel(y);
        if isempty(y), continue; end
        q = prctile(y,[25 75]);
        MedianDeviationPctIQR(i) = median(y);
        IQRDeviationPctIQR(i) = q(2)-q(1);
        MaxAbsDeviationPctIQR(i) = max(abs(y));
    end

    S = [keyTable table(Count,MedianDeviationPctIQR, ...
        IQRDeviationPctIQR,MaxAbsDeviationPctIQR)];
end

function saveValidationFigure(f,path)
    if exist("exportgraphics","file") == 2
        exportgraphics(f,path,"Resolution",300);
    else
        print(f,path,"-dpng","-r300");
    end
end
