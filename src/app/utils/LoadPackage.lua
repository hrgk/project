local LoadPackage = {}

function LoadPackage.loadSrcZip(url)
    gailun.HTTP.download(url, filename, LoadPackage.onZipDownloaded_, 
        LoadPackage.onZipFail_, seconds, LoadPackage.onZipProgress_)
end

function LoadPackage.onZipDownloaded_(filename)
    self:setPercentage_(100)
end

function LoadPackage.onZipFail_(...)
    
end

function LoadPackage.onZipProgress_(total, downloaded)
end

return LoadPackage 