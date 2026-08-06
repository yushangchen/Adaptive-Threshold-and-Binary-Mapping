function setup()
root = fileparts(mfilename("fullpath"));
addpath(root, fullfile(root,"src"), fullfile(root,"scripts"), ...
    fullfile(root,"validation"), fullfile(root,"examples"));
fprintf("AT-BM path configured: %s\n",root);
end
