function sn(nlabs)
if nargin==0
  % Run parfor in reverse order (as if just a for-loop)
  nlabs = 0;
end

root = iGetDirListing;
parfor (root_index=1:length(root),nlabs)% root is a char array that has the directories I need for the next loop
    fprintf(1,"ri: %d\t%s\n",root_index,root{root_index});
    cd(root{root_index})
    
    folders = iGetDirListing;
    for folder_index=1:length(folders)
        fprintf(1,"ri: %d\tfi: %d\t%s\n",root_index,folder_index,folders{folder_index});
        %do something
    end
    
    % Go back up for next parfor iteration
    cd ..
end

end


function dir_listing = iGetDirListing

% Get listing of folders, remove ".*" folders
d = dir;
names = {d([d.isdir]).name};
dir_listing = names(~strncmp(names,'.',1));

end
