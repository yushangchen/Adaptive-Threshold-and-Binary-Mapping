setup;

if ~isfolder("results")
    mkdir("results");
end
if ~isfolder("figures")
    mkdir("figures");
end

run("validation/validate_synthetic_morphologies.m");
run("validation/validate_bin_width_and_smoothing.m");
run("validation/validate_record_length.m");
run("validation/validate_sr_vr_sensitivity.m");
run("validation/validate_bootstrap_repeatability.m");

testResults = runtests("tests");
disp(table(testResults));

if any([testResults.Failed])
    error("ATBM:ValidationFailed", ...
        "One or more AT-BM unit tests failed.");
end
