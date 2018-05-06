fs = require('fs')

# In newer Node.js versions where process is already global this isn't necessary.
process = require('process')
moveFrom = '/home/mike/dev/node/sonar/moveme'
moveTo = '/home/mike/dev/node/sonar/tome'
###
copy subdirectory files if they exist into the public and draft directories
###
tld = "/site-master/"
preparedDirectories = {}
prepareDirectory= (d)->
  return if preparedDirectories[d]?.isDirectory() 
  paths = d.split '/'
  startPath = ''
  for path in paths
    continue unless path
    startPath += '/'+ path
    continue if preparedDirectories[startPath]?.isDirectory()
    try
      fail = false
      try
        stat = fs.statSync startPath
      catch
        fail = true
      if !fail && stat.isDirectory()
        preparedDirectories[startPath] = stat
      else
        fs.mkdirSync startPath,0o755
      preparedDirectories[startPath] = fs.statSync startPath
    catch badDog
      console.error "unable to stat/create directory",d,startPath,badDog
  return
  
module.exports.copyStoryAssets= (story)->
  # Loop through all the files in the temp directory
  [siteName,category,slug] = story.id.split '/'
  storySourceAssets = "/site-master/sites/#{siteName}/templates/#{category}/#{slug}/"
  try
    fs.statSync storySourceAssets
  catch
    return 
  storyPublishedAssets = "/site-master/public-#{story.id}/"
  storyDraftAssets = "/site-master/public-#{siteName}/draft/#{category}/#{slug}/"
  if story.canPublish()
    destDir = storyPublishedAssets
    wipeDir = storyDraftAssets
  else
    destDir = storyDraftAssets
    wipeDir = storyPublishedAssets
  prepareDirectory destDir
  prepareDirectory wipeDir
  try
    files=fs.readdirSync storySourceAssets
    for file in files
      fromPath = storySourceAssets  + file
      toPath = destDir + file
      killPath = wipeDir + file
      stat = fs.statSync fromPath
      if stat.isFile()
        data = fs.readFileSync fromPath, encoding: null
        fs.writeFileSync toPath,data ,encoding: null,mode: 0o644
        #fs.copyFileSync fromPath, toPath,fs.constants.COPYFILE_FICLONE
        try
          fs.unlinkSync killPath
        catch
  catch badDog
    console.error "failure in asset copy",badDog
  return