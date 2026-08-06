setup;
run("validation/validate_synthetic_morphologies.m");
run("validation/validate_bin_width_and_smoothing.m");
run("validation/validate_record_length.m");
testResults=runtests("tests");
disp(table(testResults));
