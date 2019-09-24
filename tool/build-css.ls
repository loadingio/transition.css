require! <[fs fs-extra anikit uglifycss]>

prefix = process.argv.2 or 'ld'
dir = process.argv.3 or 'dist/entries'
if !(prefix and dir) =>
  console.log "usage: gifmin [prefix] [dir]"
  process.exit!

alias = do
  "rubber-h": <[rubber]>
  "wander-h": <[wander]>
  "coin-h": <[coin]>
  "shake-h": <[shake]>

all = [".#{prefix} { transform-origin: 50% 50%; transform-box: fill-box; }"]
console.log "prepare dist folder ... "
fs-extra.ensure-dir-sync dir

console.log "generating css files for each animation ... "

for k,v of anikit.types =>
  kit = new anikit.anikit k
  if !kit.config.repeat => continue # looping animation should not be in transition.css
  console.log " - #dir/#k.css / #k.min.css "
  cls = kit.cls {unit: \%}, {name: k, prefix, alias: if alias[k] => ([k] ++ alias[k]) else null }
  all.push cls
  css = """
  #{all.0}
  #cls
  """
  fs.write-file-sync "#dir/#k.css", css

  css-min = uglifycss.processString css
  fs.write-file-sync "#dir/#k.min.css", css-min

console.log "generating dist/transition.css ..."
css = all.join(\\n)
fs.write-file-sync "dist/transition.css", css

console.log "generating dist/transition.min.css ..."
css-min = uglifycss.processString css
fs.write-file-sync "dist/transition.min.css", css-min
