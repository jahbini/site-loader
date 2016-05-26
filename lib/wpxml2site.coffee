'use strict'
request = require 'request'
fs = require 'fs-extra'
cheerio = require 'cheerio'
moment = require 'moment'
yamljs = require 'yamljs'
mkdirp = require 'mkdirp'

subSite = 'celarien'
destDir = subSite
mkdirp.sync "#{subSite}/images"
mkdirp.sync "#{subSite}/content"
body = fs.readFileSync("./#{subSite}.xml").toString()
$ = cheerio.load(body, xmlMode: true)
channel = $('channel')

saveToFile = (filename, content) ->
  fs.writeFile "#{subSite}/content/#{filename}.md", content, (error) ->
    if error
      console.log "saveToFile error: ", error
    else
      console.log "File #{filename}.md saved to content/"

# Each post in XML
$('item', channel).each ->
  item = $(this)
  # Main body text
  content = item.find('content\\:encoded').html()
  content = content.replace('<![CDATA[', '').replace(']]>', '')
  # Download Images
  images = []
  wysiwyg = cheerio.load(content)
  wysiwyg('img').each (i, el) ->
    image = $(this).attr('src')
    imagename = image.replace(/(?:(?:http|https)[.:]?[/.a-z-]+[/0-9]+)([a-z0-9.-]+)/igm, '$1')
    imagename = "#{subSite}/images/#{imagename}"
    console.log "wysiwyg -- #{imagename}: #{image}"

    download = (uri, filename, callback) ->
      request.head uri, (err, res, body) ->
        console.log('content-type:', res.headers['content-type']);
        console.log('content-length:', res.headers['content-length']);
        try
          request(uri).pipe(fs.createWriteStream(filename))
            .on 'close', callback
            .on 'error', (e)->
              console.log "HELP!!! #{e}"
              return false
        catch badDog
          console.log "Bad Download on #{uri}"
          console.log " -- #{badDog}"

    download image, imagename, (i) ->
      console.log "Image #{i} finished"
      return
    return

  ###*
  # Cleanup Content
  # ---------------------------------------------------------------------------
  ###

  # Trim leading and trailing whitespace
  content = content.trim()
  #.replace(/^\s+|\s+$/g, '');
  # Replace [caption] with <figure> & <figcaption> http://regexr.com/3cepk
  content = content.replace(/(?:\[+[a-z ="_0-9]+\])(\<.+\>)([^\[]+)(?:.+)/gm, '<figure>$1<figcaption>$2</figcaption></figure>')
  # Replace image link href absolute url with relative url http://regexr.com/3ceq6
  content = content.replace(/(\<a href\=\")(?:(?:http|https)[.:]?[/.a-z-]+[/0-9]+)([a-z0-9.-]*(?:jpg|png)+)([^>]+\>)/igm, '$1{{assets}}images/$2$3')
  # Replace image src absolute url with relative url http://regexr.com/3ceq0
  content = content.replace(/(\<img src\=\")(?:(?:http|https)[.:]?[/.a-z-]+[/0-9]+)([a-z0-9.-]+)(\"[^>]+\/>)/igm, '$1{{assets}}images/$2$3')
  # Replace [quote] with blockquote + footer
  content = content.replace(/(?:\[quote[^\"]+.)([^\"]+)(?:\"\])([^\[]+)(?:\[\/quote\])/gm, '<blockquote>\n\u0009$2\n\u0009<footer>$1</footer>\n</blockquote>\n')
  # Comments
  comments = []
  commentNada = item.find('wp\\:comment').each(->
    comment = $(this)
    comment_data = [
      '\n  -'
      '    comment_id: "' + comment.find('wp\\:comment_id').text() + '"'
      '    comment_author: "' + comment.find('wp\\:comment_author').text() + '"'
      '    comment_author_email: "' + comment.find('wp\\:comment_author_email').text() + '"'
      '    comment_author_url: "' + comment.find('wp\\:comment_author_url').text() + '"'
      '    comment_date: "' + comment.find('wp\\:comment_date').text() + '"'
      '    comment_content: |'
      '      ' + comment.find('wp\\:comment_content').html().replace('<![CDATA[', '').replace(']]>', '')
    ].join('\n')
    comments.push comment_data
    return
  )
  if comments.length > 0
    comments = 'comments:\n' + comments.join(' ')
  console.log "Comment section:",comments
  # Pubdate
  pubDate = moment(new Date(item.find('pubDate').text())).format('YYYY-MM-DD-HHmm')
  console.log "Publication date = #{pubDate}"
  # Output format
  filename = item.find('wp\\:post_name').text()
  frontmatter = [
    '---'
    'title: "' + item.find('title').text() + '"'
    'creator: "' + item.find('dc\\:creator').text().trim() + '"'
    'post_id: "' + item.find('wp\\:post_id').text() + '"'
    'excerpt: "' + item.find('excerpt\\:encoded').text() + '"'
    "published: #{pubDate}"
    "slug: #{filename}"
    "embargo: '02/02/2017'"
    comments
    '---'
    content
  ].join('\n')
  # See how it looks
  # console.log(frontmatter);
  saveToFile(filename, frontmatter);
  return

console.log "conversion complete"
