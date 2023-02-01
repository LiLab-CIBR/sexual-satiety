function position_data = cellposS3(pic_dir,position_dir,cellcluster,picheight)

    position = [];cellidx = [];
    figure()
    imshow(pic_dir)
    for i = 1:length(cellcluster)
        title(cellcluster{i})
        [x,y] = ginput()
        position = [position;x,y];
        cellidx = [cellidx;i*ones(length(x),1)];
    end
    picinfo = imfinfo(pic_dir);
    position = [position,cellidx];
    position_data = position;
    position_data(:,1:2) = position(:,1:2)./picinfo.Height*picheight;
    save(position_dir,'position_data');
end