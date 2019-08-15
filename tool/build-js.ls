require! <[fs fs-extra anikit]>
names = []
for k,v of anikit.types => 
  {mod,config} = anikit.get k
  if !config.repeat => continue
  names.push config.name
console.log JSON.stringify(names)
