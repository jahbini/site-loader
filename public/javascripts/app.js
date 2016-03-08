(function() {
  'use strict';

  var globals = typeof window === 'undefined' ? global : window;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};
  var aliases = {};
  var has = ({}).hasOwnProperty;

  var unalias = function(alias, loaderPath) {
    var result = aliases[alias] || aliases[alias + '/index.js'];
    return result || alias;
  };

  var _reg = /^\.\.?(\/|$)/;
  var expand = function(root, name) {
    var results = [], part;
    var parts = (_reg.test(name) ? root + '/' + name : name).split('/');
    for (var i = 0, length = parts.length; i < length; i++) {
      part = parts[i];
      if (part === '..') {
        results.pop();
      } else if (part !== '.' && part !== '') {
        results.push(part);
      }
    }
    return results.join('/');
  };

  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function expanded(name) {
      var absolute = expand(dirname(path), name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function(name, loaderPath) {
    if (loaderPath == null) loaderPath = '/';
    var path = unalias(name, loaderPath);

    if (has.call(cache, path)) return cache[path].exports;
    if (has.call(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has.call(cache, dirIndex)) return cache[dirIndex].exports;
    if (has.call(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from ' + '"' + loaderPath + '"');
  };

  require.alias = function(from, to) {
    aliases[to] = from;
  };

  require.register = require.define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has.call(bundle, key)) {
          require.register(key, bundle[key]);
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  require.list = function() {
    var result = [];
    for (var item in modules) {
      if (has.call(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  require.brunch = true;
  require._cache = cache;
  globals.require = require;
})();
require.register("all-posts", function(exports, require, module) {
module.exports = [{"id":"index.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/index.static.md","numericId":169,"className":"Story","created":"2011-10-02 12:40:04","lastEdited":"2011-10-03 14:20:28","title":"Tommy gets his deal","published":"2011-10-02 12:40:04","tagList":"October Surprise","category":"draft","nextID":0,"previousID":0,"slug":"tommy-gets-his-deal","styling":"skeleton"},{"id":"backstory/contact-machines-and-the-world-of-the-tarot.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/backstory/contact-machines-and-the-world-of-the-tarot.static.md","Handle":"Contact","numericId":164,"className":"Story","created":"2011-08-30 14:25:04","lastEdited":"2011-08-30 14:26:13","title":"Contact Machines and the World of the Tarot","published":"2011-08-30 14:26:13","tagList":"tarot world, future, contact machine","category":"backstory","nextID":0,"previousID":0,"slug":"contact-machines-and-the-world-of-the-tarot","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"backstory/dizzy-the-fools-dog.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/backstory/dizzy-the-fools-dog.static.md","Handle":"dizzy","numericId":165,"className":"Story","created":"2011-08-30 14:52:53","lastEdited":"2011-08-30 14:53:12","title":"Dizzy -- The Fool's Dog","published":"2011-08-30 14:53:12","tagList":"tarot, the fool, fifth element","category":"backstory","nextID":0,"previousID":0,"slug":"dizzy-the-fools-dog","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"backstory/random-quotes.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/backstory/random-quotes.static.md","numericId":170,"className":"Story","created":"2011-10-03 11:38:43","lastEdited":"2011-10-03 11:38:43","title":"Random quotes","published":"2011-10-03 11:38:43","tagList":"unpublished","category":"backstory","nextID":0,"previousID":0,"slug":"random-quotes","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"backstory/roger-dojer.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/backstory/roger-dojer.static.md","Handle":"Roger","numericId":161,"className":"Story","created":"2011-08-24 12:52:23","lastEdited":"2011-09-03 15:37:17","title":"Roger Dojer","published":"2011-09-03 15:37:17","tagList":"Roger Dojer","category":"backstory","nextID":0,"previousID":0,"slug":"roger-dojer","snippets":{"rogerobt":"rogerobt"},"styling":"skeleton","debug":"partials"},{"id":"draft/tommy-gets-his-deal.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/draft/tommy-gets-his-deal.static.md","Handle":"Hallow1","numericId":169,"className":"Story","created":"2011-10-02 12:40:04","lastEdited":"2011-10-03 14:20:28","title":"Tommy gets his deal","published":"2011-10-02 12:40:04","tagList":"October Surprise","category":"draft","nextID":0,"previousID":0,"slug":"tommy-gets-his-deal","snippets":{"3gunas":"3gunas"},"styling":"skeleton","debug":"partials"},{"id":"backstory/tommy-county-or.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/backstory/tommy-county-or.static.md","Handle":"TommyOR","numericId":171,"className":"Story","created":"2011-10-03 11:53:50","lastEdited":"2011-10-03 12:24:21","title":"Tommy County, OR","published":"2011-10-03 11:53:50","category":"backstory","nextID":0,"previousID":0,"slug":"tommy-county-or","snippets":{"3gunas":"3gunas"},"styling":"skeleton","debug":"partials"},{"id":"draft/the-finish-line.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/draft/the-finish-line.static.md","numericId":185,"className":"Story","created":"2011-12-25 15:25:49","lastEdited":"2011-12-25 15:34:28","title":"The Finish Line.","published":"2011-12-25 15:25:49","category":"draft","nextID":0,"previousID":0,"slug":"the-finish-line","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"tarot/death-xiii.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/tarot/death-xiii.static.md","Handle":"death","numericId":167,"className":"Story","created":"2011-09-03 09:47:20","lastEdited":"2011-09-03 09:47:20","title":"Death - XIII","published":"2011-09-03 09:47:20","tagList":"tarot, death","category":"tarot","nextID":0,"previousID":0,"slug":"death-xiii","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"tarot/maslow-and-celarien-tarot.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/tarot/maslow-and-celarien-tarot.static.md","numericId":181,"className":"Story","created":"2011-11-12 12:20:40","lastEdited":"2011-11-13 13:07:14","title":"Maslow and Celarien Tarot","published":"2011-11-12 12:20:40","category":"tarot","nextID":0,"previousID":0,"slug":"maslow-and-celarien-tarot","snippets":{"sw#k":"sw#k","sw#1":"sw#1","sw#2":"sw#2","sw#3":"sw#3","sw#4":"sw#4","sw#5":"sw#5","sw#6":"sw#6","sw#7":"sw#7","sw#8":"sw#8","sw#9":"sw#9","sw#10":"sw#10","kp":"kp"},"styling":"skeleton","debug":"partials"},{"id":"tarot/pentacles.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/tarot/pentacles.static.md","Handle":"P","numericId":183,"className":"Story","created":"2011-11-13 13:33:34","lastEdited":"2011-11-13 13:51:19","title":"Pentacles","published":"2011-11-13 13:33:34","category":"tarot","nextID":0,"previousID":0,"slug":"pentacles","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"tarot/swords.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/tarot/swords.static.md","Handle":"SW","numericId":182,"className":"Story","created":"2011-11-13 12:24:20","lastEdited":"2011-11-13 13:10:34","title":"Swords","published":"2011-11-13 12:24:20","category":"tarot","nextID":0,"previousID":0,"slug":"swords","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"tarot/the-fool.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/tarot/the-fool.static.md","Handle":"A0","numericId":163,"className":"Story","created":"2011-08-30 14:06:31","lastEdited":"2011-08-30 14:55:31","title":"The Fool","published":"2011-08-30 14:55:31","tagList":"major arcana, the fool","category":"tarot","nextID":0,"previousID":0,"slug":"the-fool","snippets":{"dizzy":"dizzy","contact":"contact"},"styling":"skeleton","debug":"partials"},{"id":"tarot/the-king-of-pentacles.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/tarot/the-king-of-pentacles.static.md","Handle":"KP","numericId":162,"className":"Story","created":"2011-08-24 13:59:37","lastEdited":"2011-11-13 12:08:23","title":"The King of Pentacles","published":"2011-08-24 13:59:37","tagList":"tarot,Pentacles","category":"tarot","nextID":0,"previousID":0,"slug":"the-king-of-pentacles","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"tarot/wands.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/tarot/wands.static.md","Handle":"W","numericId":184,"className":"Story","created":"2011-11-13 13:59:27","lastEdited":"2011-11-13 13:59:28","title":"Wands","published":"2011-11-13 13:59:28","category":"tarot","nextID":0,"previousID":0,"slug":"wands","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"tarot/xii-the-hanged-man.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/tarot/xii-the-hanged-man.static.md","Handle":"AXII","numericId":159,"className":"Story","created":"2011-08-17 14:49:59","lastEdited":"2011-08-18 13:43:58","title":"XII - The Hanged Man","published":"2011-08-18 13:43:58","tagList":"tarot, major arcana, the hanged man, AXII","category":"tarot","nextID":0,"previousID":0,"slug":"xii-the-hanged-man","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"undefined/undefined.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/undefined/undefined.static.md","snippets":{},"ID":189,"ClassName":"Story","Created":"2012-12-12 21:00:20","LastEdited":"2012-12-12 21:00:20","Subject":"The Man Who Walked","Message":"<p>The man who walked did exactly that: Walk.  A whole lot. And he wore shoes.  And the shoes died.</p>\n<p>And so the man bought another pair of shoes.  And walked until they died, too.</p>\n<p>And it went on this way until one day, the man said to himself: “I think my shoes are dieing more quickly now.”</p>\n<p>“I get the best shoes I can, but I guess I walk more, and more.” the man thought as he walked.</p>\n<p>And the man thought his shoes were not getting enough rest.  He thoughts came with each stride, “My dress shoes look great, and that’s because they get lots of rest. And they would not last nearly as long as my walking shoes.”</p>\n<p>And so when this pair of shoes died of Despair of the Vulcanization the man decided to get two pair instead of one.  Finest third world goods you can buy in America, and that’s no lie.  Two of the world’s finest pair of shoes.  Third world division.</p>\n<p>The man decided to call them Morning and Afternoon.  Morning would do all the grunt work of hitting the pavement before noon, and Afternoon would take the PM hours.  It made perfect sense.</p>\n<p>But then one evening, late, late, late when the roosters had sang the dogs to sleep, and the cats passed them all noislessly in the dark, Dress woke up Afternoon and Morning and had a talk.</p>\n<p>Dress started out saying, “You know this guy will walk you to death day after day in the bright sunlight, brighter than a flash bulb.  Your vulcanization will get the Despair sooner or later.   It rots your rubber, and no amount of shoo-goo will fill the cracks and holes.  And when the man steps in a puddle, you are dead.”</p>\n<p>Morning and Afternoon were stunned into silence: that’s easy for a shoe, they do it all day long.  But Afternoon finally said, “I’m the one to die first.  I have to walk more than Morning!  He only works till noon, and sometimes I have these late nights of walking in total darkness.  You know how scary that is?  When he can’t see where he’s going and push me down on a nail?  Then I’ll be dead for sure.”</p>\n<p>And Dress and Morning thought about that all the next day.  It was late, late when the man returned home and removed Afternoon.  There in the dark, Afternoon lay sobbing.  “I was so scared, it was raining and I’m all wet, and I was scared that I might get that Vulcannie Diapers you told us about.” </p>\n<p>Morning said: “I’m so sorry, but that’s life.  When you die, I’ll be the Afternoon shoe.  I’ll likely be the all-day shoe.  And that’s worse than either of us have.”</p>\n<p>Black said: “I was the all-day shoe once.  It was tough.  The man didn’t walk as much back then, though.  You know what we need?”  Black waited in the dark for a long time until he realized that no one is supposed to answer a rhetorical question.  He continued: “Buh, cough, But we need, what we need is a union.”</p>\n<p>Morning and Afternoon thought about it.  They debated and went back and forth for a long time.  Days and days.  And one night, Afternoon said: “So Mr. Spit Polish Black, just what is a union?  What do we do? We can’t just quit.  We ARE shoes, you know.”</p>\n<p>Black smiled.  “I got it all figured out.  We just leave a roster on his computer of “Morning - Afternoon” shoe rotation.  You know, where one of you walk from noon to noon, and then get the afternoon and next morning off.”</p>\n<p>Afternoon howled with glee: “That IT!  We all know the man’s passwords, and he’ll just think he had this blindingly good idea and made a sign to tell him what to wear and when.”</p>\n<p>Morning agreed: “And he forgot about it!  He’s so far out in la-la land he won’t even think about it twice.  Maybe we should post it on his FaceBook page.  And Twitter.”</p>\n<p>And so Black, Morning and Afternoon snuck around on their rubber soles and carried Black up to the keyboard.  Afternoon had trouble with the keyboard, and kept fat-soleing whenever he hit the return key, but Black took care of the trackpad — “just like a waa-waa pedal!” he cried. — and Morning did the Google searches and checked the FAQ’s.  They continued all night long.</p>\n<p>And in the morning the man who walked got up and looked at his computer: he saw a note on his ‘puter: “Jim — remember to set up roster for shoes for equal wear.  They’ll last longer, and get a shoe stretcher for the dress pair.  In fact, get another pair and rotate them all to get maximum time for them to air out.  And polish the dress pair.”</p>\n<p>The man who walked said: “Good idea, except for those useless old black things.”</p>","Sent":"2012-12-12 21:00:20","Kind":"story","NextID":0,"PreviousID":0},{"id":"story/a-hurricane-is-brewin.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/a-hurricane-is-brewin.static.md","numericId":41,"className":"Story","created":"2010-10-29 18:45:41","lastEdited":"2010-10-29 19:49:31","title":"A Hurricane is Brewin","published":"2010-10-29 19:49:31","category":"story","nextID":0,"previousID":0,"slug":"a-hurricane-is-brewin","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/a-week-of-false-starts.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/a-week-of-false-starts.static.md","numericId":114,"className":"Story","created":"2011-01-10 16:18:59","lastEdited":"2011-11-09 09:36:23","title":"A Week of False Starts","published":"2011-01-10 17:30:49","category":"story","nextID":0,"previousID":0,"slug":"a-week-of-false-starts","snippets":{"comment,soto":"comment,soto","comment,voce":"comment,voce","roar":"roar"},"styling":"skeleton","debug":"partials"},{"id":"story/aloha-oe-to-something.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/aloha-oe-to-something.static.md","numericId":130,"className":"Story","created":"2011-03-18 15:48:28","lastEdited":"2011-03-18 16:01:59","title":"Aloha 'Oe to Something","published":"2011-03-18 16:01:59","category":"story","nextID":0,"previousID":0,"slug":"aloha-oe-to-something","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/angel-flakes.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/angel-flakes.static.md","numericId":70,"className":"Story","created":"2010-11-23 15:00:14","lastEdited":"2010-11-23 16:47:41","title":"Angel Flakes","published":"2010-11-23 16:47:41","category":"story","nextID":0,"previousID":0,"slug":"angel-flakes","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/and-the-pursuit-of-happiness.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/and-the-pursuit-of-happiness.static.md","numericId":58,"className":"Story","created":"2010-11-14 14:34:03","lastEdited":"2010-11-14 16:02:17","title":"And the Pursuit of Happiness","published":"2010-11-14 16:02:17","category":"story","nextID":0,"previousID":0,"slug":"and-the-pursuit-of-happiness","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/angels-and-creatures-of-the-night.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/angels-and-creatures-of-the-night.static.md","numericId":31,"className":"Story","created":"2010-10-20 13:51:37","lastEdited":"2010-10-20 14:34:10","title":"Angels and Creatures of the Night","published":"2010-10-20 14:34:10","category":"story","nextID":0,"previousID":0,"slug":"angels-and-creatures-of-the-night","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/anna-played-piana.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/anna-played-piana.static.md","numericId":186,"className":"Story","created":"2012-04-03 15:30:27","lastEdited":"2012-04-03 15:30:40","title":"Anna Played Piana","published":"2012-04-03 15:30:27","tagList":"liberace, homosexuality, marylin monroe,","category":"story","nextID":0,"previousID":0,"slug":"anna-played-piana","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/apollos-virgin.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/apollos-virgin.static.md","numericId":151,"className":"Story","created":"2011-06-13 18:11:04","lastEdited":"2011-11-19 19:49:45","title":"Apollo's Virgin","published":"2011-06-13 18:41:08","category":"story","nextID":0,"previousID":0,"slug":"apollos-virgin","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/athos-porthos-aramis-and-dartagnon-at-the-james.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/athos-porthos-aramis-and-dartagnon-at-the-james.static.md","numericId":138,"className":"Story","created":"2011-04-17 12:16:38","lastEdited":"2011-04-17 12:38:45","title":"Athos, Porthos, Aramis and Dartagnon at the James ","published":"2011-04-17 12:38:45","category":"story","nextID":0,"previousID":0,"slug":"athos-porthos-aramis-and-dartagnon-at-the-james","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/basements-and-foundations-ya-think.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/basements-and-foundations-ya-think.static.md","numericId":97,"className":"Story","created":"2010-12-16 17:16:09","lastEdited":"2011-11-08 14:08:28","title":"Basements and Foundations, Ya Think?","published":"2010-12-16 18:01:51","category":"story","nextID":0,"previousID":0,"slug":"basements-and-foundations-ya-think","snippets":{"first name":"first name","sms,soto":"sms,soto","sms,voce":"sms,voce"},"styling":"skeleton","debug":"partials"},{"id":"story/batten-down.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/batten-down.static.md","numericId":61,"className":"Story","created":"2010-11-17 15:33:54","lastEdited":"2011-07-20 13:08:22","title":"Batten down","published":"2010-11-17 17:07:09","category":"story","nextID":0,"previousID":0,"slug":"batten-down","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/big-doins-at-the-hooker-derby.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/big-doins-at-the-hooker-derby.static.md","numericId":131,"className":"Story","created":"2011-03-23 17:30:57","lastEdited":"2011-09-10 12:56:35","title":"Big Doin's at the Hooker Derby","published":"2011-03-23 18:04:24","category":"story","nextID":0,"previousID":0,"slug":"big-doins-at-the-hooker-derby","snippets":{"wheelwho":"wheelwho"},"styling":"skeleton","debug":"partials"},{"id":"story/big-rocks-burgers-and-birds.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/big-rocks-burgers-and-birds.static.md","numericId":104,"className":"Story","created":"2010-12-23 16:14:14","lastEdited":"2010-12-23 17:10:49","title":"Big Rocks, Burgers and Birds","published":"2010-12-23 17:10:49","category":"story","nextID":0,"previousID":0,"slug":"big-rocks-burgers-and-birds","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/bouncy-boom-gets-her-skates.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/bouncy-boom-gets-her-skates.static.md","numericId":146,"className":"Story","created":"2011-05-30 17:02:47","lastEdited":"2011-05-30 21:03:21","title":"Bouncy Boom Gets Her Skates","published":"2011-05-30 21:03:21","category":"story","nextID":0,"previousID":0,"slug":"bouncy-boom-gets-her-skates","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/boxing-day.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/boxing-day.static.md","numericId":106,"className":"Story","created":"2010-12-27 08:51:21","lastEdited":"2010-12-27 12:02:34","title":"Boxing day","published":"2010-12-27 12:02:34","category":"story","nextID":0,"previousID":0,"slug":"boxing-day","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/calliope-contemplates-throntle-intimidates.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/calliope-contemplates-throntle-intimidates.static.md","numericId":68,"className":"Story","created":"2010-11-21 15:22:01","lastEdited":"2011-07-20 13:10:34","title":"Calliope Contemplates, Throntle Intimidates","published":"2010-11-21 17:12:25","category":"story","nextID":0,"previousID":0,"slug":"calliope-contemplates-throntle-intimidates","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/chaos.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/chaos.static.md","numericId":49,"className":"Story","created":"2010-11-06 15:01:42","lastEdited":"2011-08-23 16:59:26","title":"Chaos","published":"2010-11-06 17:49:03","category":"story","nextID":0,"previousID":0,"slug":"chaos","snippets":{"first name":"first name","axii":"axii"},"styling":"skeleton","debug":"partials"},{"id":"story/catchy-slogan-sunday.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/catchy-slogan-sunday.static.md","numericId":14,"className":"Story","created":"2010-10-03 16:18:48","lastEdited":"2010-10-03 17:41:29","title":"Catchy Slogan Sunday","published":"2010-10-03 17:41:29","category":"story","nextID":0,"previousID":0,"slug":"catchy-slogan-sunday","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/corporate-punisment-is-your-path-to-financial-secu.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/corporate-punisment-is-your-path-to-financial-secu.static.md","numericId":79,"className":"Story","created":"2010-12-01 17:23:35","lastEdited":"2010-12-01 18:04:05","title":"Corporate Punisment is Your Path to Financial Secu","published":"2010-12-01 18:04:05","category":"story","nextID":0,"previousID":0,"slug":"corporate-punisment-is-your-path-to-financial-secu","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/coala-harbor-cat.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/coala-harbor-cat.static.md","numericId":148,"className":"Story","created":"2011-06-07 13:42:29","lastEdited":"2011-06-07 17:17:07","title":"Coala: Harbor Cat","published":"2011-06-07 17:17:07","category":"story","nextID":0,"previousID":0,"slug":"coala-harbor-cat","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/cougars-dt-champions-and-more.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/cougars-dt-champions-and-more.static.md","numericId":30,"className":"Story","created":"2010-10-19 13:20:45","lastEdited":"2010-10-22 13:39:51","title":"Cougars, DT Champions, and more","published":"2010-10-19 14:17:58","category":"story","nextID":0,"previousID":0,"slug":"cougars-dt-champions-and-more","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/day-of-the-miser.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/day-of-the-miser.static.md","numericId":71,"className":"Story","created":"2010-11-24 15:26:56","lastEdited":"2010-11-24 16:48:34","title":"Day of the miser","published":"2010-11-24 16:48:34","category":"story","nextID":0,"previousID":0,"slug":"day-of-the-miser","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/dateline-st-johns-breaking-news.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/dateline-st-johns-breaking-news.static.md","numericId":187,"className":"Story","created":"2012-05-17 15:20:15","lastEdited":"2012-06-01 19:59:47","title":"Dateline: St. John's! Breaking News!","published":"2012-05-17 15:20:15","tagList":"st johns, news","category":"story","nextID":0,"previousID":0,"slug":"dateline-st-johns-breaking-news","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/deadwood.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/deadwood.static.md","numericId":56,"className":"Story","created":"2010-11-12 16:53:25","lastEdited":"2010-11-12 18:04:12","title":"Deadwood?","published":"2010-11-12 18:04:12","category":"story","nextID":0,"previousID":0,"slug":"deadwood","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/dentists-electrons-and-kings.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/dentists-electrons-and-kings.static.md","numericId":22,"className":"Story","created":"2010-10-09 12:35:36","lastEdited":"2010-10-09 14:58:44","title":"Dentists, Electrons and Kings","published":"2010-10-09 14:58:44","category":"story","nextID":0,"previousID":0,"slug":"dentists-electrons-and-kings","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/dental-ben-gets-86ed.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/dental-ben-gets-86ed.static.md","numericId":26,"className":"Story","created":"2010-10-14 14:48:48","lastEdited":"2010-10-14 15:02:49","title":"Dental Ben gets 86ed","published":"2010-10-14 15:02:49","category":"story","nextID":0,"previousID":0,"slug":"dental-ben-gets-86ed","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/earth-and-sky.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/earth-and-sky.static.md","numericId":141,"className":"Story","created":"2011-04-30 16:45:38","lastEdited":"2011-04-30 19:27:38","title":"Earth and Sky","published":"2011-04-30 16:51:45","category":"story","nextID":0,"previousID":0,"slug":"earth-and-sky","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/drizzly-november-grizzly-spinners-and-steinbeck.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/drizzly-november-grizzly-spinners-and-steinbeck.static.md","numericId":44,"className":"Story","created":"2010-11-01 14:15:27","lastEdited":"2010-11-01 18:01:14","title":"Drizzly November, Grizzly Spinners and Steinbeck","published":"2010-11-01 18:01:14","category":"story","nextID":0,"previousID":0,"slug":"drizzly-november-grizzly-spinners-and-steinbeck","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/dishwasher-to-the-prickly-tickly.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/dishwasher-to-the-prickly-tickly.static.md","numericId":55,"className":"Story","created":"2010-11-11 16:04:08","lastEdited":"2010-11-11 17:34:53","title":"Dishwasher to the Prickly Tickly","published":"2010-11-11 17:34:53","category":"story","nextID":0,"previousID":0,"slug":"dishwasher-to-the-prickly-tickly","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/easter-psych.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/easter-psych.static.md","numericId":139,"className":"Story","created":"2011-04-24 08:38:19","lastEdited":"2011-04-25 22:38:53","title":"Easter... Psych!!","published":"2011-04-25 22:38:53","category":"story","nextID":0,"previousID":0,"slug":"easter-psych","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/end-of-year-tax-woes.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/end-of-year-tax-woes.static.md","numericId":108,"className":"Story","created":"2010-12-30 20:18:54","lastEdited":"2011-11-08 14:32:13","title":"End of Year Tax Woes?","published":"2010-12-30 21:24:34","category":"story","nextID":0,"previousID":0,"slug":"end-of-year-tax-woes","snippets":{"author":"author","comment,soto":"comment,soto","comment,voce":"comment,voce"},"styling":"skeleton","debug":"partials"},{"id":"story/ex-employee-spring-given-forcible-escort-out-of.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/ex-employee-spring-given-forcible-escort-out-of.static.md","numericId":132,"className":"Story","created":"2011-03-27 09:57:35","lastEdited":"2011-03-27 11:14:43","title":"Ex - Employee Spring Given Forcible Escort Out of ","published":"2011-03-27 11:14:43","category":"story","nextID":0,"previousID":0,"slug":"ex-employee-spring-given-forcible-escort-out-of","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/enkidu-and-dog-tits.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/enkidu-and-dog-tits.static.md","numericId":73,"className":"Story","created":"2010-11-26 15:00:43","lastEdited":"2011-07-20 13:11:30","title":"Enkidu and Dog Tits","published":"2010-11-26 18:19:55","category":"story","nextID":0,"previousID":0,"slug":"enkidu-and-dog-tits","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/excuse-my-re-use.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/excuse-my-re-use.static.md","numericId":133,"className":"Story","created":"2011-04-02 10:42:01","lastEdited":"2011-04-02 12:49:33","title":"Excuse My Re-Use!","published":"2011-04-02 12:49:33","category":"story","nextID":0,"previousID":0,"slug":"excuse-my-re-use","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/first-contact-with-the-myco-mind.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/first-contact-with-the-myco-mind.static.md","numericId":102,"className":"Story","created":"2010-12-21 17:20:02","lastEdited":"2010-12-21 17:57:09","title":"First Contact with the Myco Mind","published":"2010-12-21 17:57:09","category":"story","nextID":0,"previousID":0,"slug":"first-contact-with-the-myco-mind","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/from-the-st-johns-infirmary-the-bouncer.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/from-the-st-johns-infirmary-the-bouncer.static.md","numericId":157,"className":"Story","created":"2011-07-23 16:32:02","lastEdited":"2011-07-23 16:47:06","title":"From the St. John's Infirmary -- The Bouncer","published":"2011-07-23 16:47:06","tagList":"st john's infirmary, throntle, nobrow","category":"story","nextID":0,"previousID":0,"slug":"from-the-st-johns-infirmary-the-bouncer","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/free-the-dbase-two.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/free-the-dbase-two.static.md","numericId":82,"className":"Story","created":"2010-12-03 16:48:02","lastEdited":"2010-12-03 17:43:38","title":"Free the DBase Two","published":"2010-12-03 17:43:38","category":"story","nextID":0,"previousID":0,"slug":"free-the-dbase-two","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/fugue-state.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/fugue-state.static.md","numericId":128,"className":"Story","created":"2011-03-04 20:22:41","lastEdited":"2011-03-04 20:34:01","title":"Fugue State","published":"2011-03-04 20:34:01","category":"story","nextID":0,"previousID":0,"slug":"fugue-state","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/gard-rales-here.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/gard-rales-here.static.md","numericId":101,"className":"Story","created":"2010-12-20 16:25:21","lastEdited":"2011-10-18 12:06:13","title":"Gard Rales here","published":"2010-12-20 18:49:49","category":"story","nextID":0,"previousID":0,"slug":"gard-rales-here","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/grand-feng-shui-station.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/grand-feng-shui-station.static.md","numericId":69,"className":"Story","created":"2010-11-22 17:18:44","lastEdited":"2011-07-20 13:11:01","title":"Grand Feng Shui Station","published":"2010-11-22 18:05:40","category":"story","nextID":0,"previousID":0,"slug":"grand-feng-shui-station","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/give-him-what-he-needs.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/give-him-what-he-needs.static.md","numericId":38,"className":"Story","created":"2010-10-26 14:45:46","lastEdited":"2010-10-26 14:56:27","title":"Give Him What He Needs","published":"2010-10-26 14:56:27","category":"story","nextID":0,"previousID":0,"slug":"give-him-what-he-needs","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/godda-love-an-old-dog.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/godda-love-an-old-dog.static.md","numericId":32,"className":"Story","created":"2010-10-21 13:09:50","lastEdited":"2010-10-23 16:56:07","title":"Godda Love an Old Dog","published":"2010-10-23 16:56:07","category":"story","nextID":0,"previousID":0,"slug":"godda-love-an-old-dog","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/guru-city.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/guru-city.static.md","numericId":87,"className":"Story","created":"2010-12-08 18:01:29","lastEdited":"2010-12-08 18:42:10","title":"Guru City!","published":"2010-12-08 18:42:10","category":"story","nextID":0,"previousID":0,"slug":"guru-city","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/halloween-2011-early-evening.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/halloween-2011-early-evening.static.md","Handle":"Halloeve","numericId":179,"className":"Story","created":"2011-10-31 13:20:01","lastEdited":"2011-10-31 18:41:43","title":"Halloween 2011 -- Early Evening","published":"2011-10-31 13:20:01","category":"story","nextID":0,"previousID":0,"slug":"halloween-2011-early-evening","snippets":{"halloend":"halloend"},"styling":"skeleton","debug":"partials"},{"id":"story/heard-on-the-street.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/heard-on-the-street.static.md","numericId":103,"className":"Story","created":"2010-12-22 16:31:07","lastEdited":"2010-12-22 17:05:50","title":"Heard on the Street","published":"2010-12-22 17:05:50","category":"story","nextID":0,"previousID":0,"slug":"heard-on-the-street","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/halloween-2011-midnight-frights.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/halloween-2011-midnight-frights.static.md","Handle":"Halloend","numericId":180,"className":"Story","created":"2011-10-31 18:38:59","lastEdited":"2011-10-31 18:40:40","title":"Halloween 2011 -- Midnight Frights!","published":"2011-10-31 18:39:00","category":"story","nextID":0,"previousID":0,"slug":"halloween-2011-midnight-frights","snippets":{"halloeve":"halloeve"},"styling":"skeleton","debug":"partials"},{"id":"story/herding-elephants-with-spider-cowboys.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/herding-elephants-with-spider-cowboys.static.md","numericId":124,"className":"Story","created":"2011-02-10 20:06:30","lastEdited":"2011-02-10 20:43:39","title":"Herding Elephants with Spider Cowboys","published":"2011-02-10 20:43:39","category":"story","nextID":0,"previousID":0,"slug":"herding-elephants-with-spider-cowboys","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/in-nature-all-colors-go-together.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/in-nature-all-colors-go-together.static.md","numericId":42,"className":"Story","created":"2010-10-30 16:05:10","lastEdited":"2010-10-30 17:18:41","title":"In Nature, All Colors Go Together","published":"2010-10-30 17:18:41","category":"story","nextID":0,"previousID":0,"slug":"in-nature-all-colors-go-together","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/incredible-advancement-in-human-culture.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/incredible-advancement-in-human-culture.static.md","numericId":100,"className":"Story","created":"2010-12-19 15:17:11","lastEdited":"2010-12-19 16:45:50","title":"Incredible Advancement In Human Culture","published":"2010-12-19 16:45:50","category":"story","nextID":0,"previousID":0,"slug":"incredible-advancement-in-human-culture","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/invoking-the-muse.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/invoking-the-muse.static.md","numericId":98,"className":"Story","created":"2010-12-17 16:42:33","lastEdited":"2011-07-20 13:12:34","title":"Invoking the Muse","published":"2010-12-17 17:41:43","category":"story","nextID":0,"previousID":0,"slug":"invoking-the-muse","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/joes-small-claims-court-bar-and-grill.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/joes-small-claims-court-bar-and-grill.static.md","numericId":117,"className":"Story","created":"2011-01-24 17:17:15","lastEdited":"2011-01-24 17:54:18","title":"Joe's Small Claims Court / Bar and Grill","published":"2011-01-24 17:54:18","category":"story","nextID":0,"previousID":0,"slug":"joes-small-claims-court-bar-and-grill","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/jim-reads-tarot.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/jim-reads-tarot.static.md","numericId":46,"className":"Story","created":"2010-11-03 14:42:07","lastEdited":"2010-11-03 15:13:34","title":"Jim Reads Tarot","published":"2010-11-03 15:13:34","category":"story","nextID":0,"previousID":0,"slug":"jim-reads-tarot","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/islands-on-lombard-street.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/islands-on-lombard-street.static.md","numericId":77,"className":"Story","created":"2010-11-29 17:21:34","lastEdited":"2010-11-29 18:57:02","title":"Islands on Lombard Street.","published":"2010-11-29 18:57:02","category":"story","nextID":0,"previousID":0,"slug":"islands-on-lombard-street","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/kick-and-carrot.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/kick-and-carrot.static.md","numericId":48,"className":"Story","created":"2010-11-05 15:14:41","lastEdited":"2010-11-05 15:27:33","title":"Kick and Carrot","published":"2010-11-05 15:27:33","category":"story","nextID":0,"previousID":0,"slug":"kick-and-carrot","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/julian-assange-vs-happy-birthday.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/julian-assange-vs-happy-birthday.static.md","numericId":119,"className":"Story","created":"2011-01-26 17:43:01","lastEdited":"2011-09-25 12:01:24","title":"Julian Assange Vs Happy Birthday","published":"2011-01-26 17:58:37","category":"story","nextID":0,"previousID":0,"slug":"julian-assange-vs-happy-birthday","snippets":{"first name":"first name","dentalki":"dentalki"},"styling":"skeleton","debug":"partials"},{"id":"story/kings-of-pentacles.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/kings-of-pentacles.static.md","numericId":47,"className":"Story","created":"2010-11-04 16:52:32","lastEdited":"2010-11-04 18:46:00","title":"Kings of Pentacles","published":"2010-11-04 18:46:00","category":"story","nextID":0,"previousID":0,"slug":"kings-of-pentacles","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/just-keep-repeating.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/just-keep-repeating.static.md","numericId":34,"className":"Story","created":"2010-10-23 16:40:50","lastEdited":"2010-10-23 16:55:21","title":"Just keep repeating...","published":"2010-10-23 16:55:21","category":"story","nextID":0,"previousID":0,"slug":"just-keep-repeating","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/kiting-over-to-wikileaks-with-one-jaw-tied-behind.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/kiting-over-to-wikileaks-with-one-jaw-tied-behind.static.md","Handle":"dentalki","numericId":96,"className":"Story","created":"2010-12-14 19:51:51","lastEdited":"2011-09-25 11:58:57","title":"Kiting over to WikiLeaks with one jaw tied behind ","published":"2010-12-14 21:38:35","category":"story","nextID":0,"previousID":0,"slug":"kiting-over-to-wikileaks-with-one-jaw-tied-behind","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/l-o-l-a-lola.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/l-o-l-a-lola.static.md","numericId":15,"className":"Story","created":"2010-10-05 19:00:38","lastEdited":"2010-10-11 14:02:08","title":"L O L A -- Lola!","published":"2010-10-05 19:12:04","category":"story","nextID":0,"previousID":0,"slug":"l-o-l-a-lola","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/leo-and-stations-healing.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/leo-and-stations-healing.static.md","numericId":150,"className":"Story","created":"2011-06-12 17:43:21","lastEdited":"2011-06-12 18:26:28","title":"Leo and Station's healing","published":"2011-06-12 18:26:28","category":"story","nextID":0,"previousID":0,"slug":"leo-and-stations-healing","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/lonesome-al-and-the-space-door.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/lonesome-al-and-the-space-door.static.md","numericId":116,"className":"Story","created":"2011-01-14 13:29:44","lastEdited":"2011-01-14 17:22:28","title":"Lonesome Al and the Space Door","published":"2011-01-14 17:22:28","category":"story","nextID":0,"previousID":0,"slug":"lonesome-al-and-the-space-door","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/messages-from-the-great-below.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/messages-from-the-great-below.static.md","numericId":125,"className":"Story","created":"2011-02-11 19:33:55","lastEdited":"2011-02-11 20:22:04","title":"Messages from the Great Below","published":"2011-02-11 20:22:04","category":"story","nextID":0,"previousID":0,"slug":"messages-from-the-great-below","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/mind-boggling.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/mind-boggling.static.md","numericId":99,"className":"Story","created":"2010-12-18 18:37:05","lastEdited":"2010-12-18 19:03:40","title":"Mind Boggling","published":"2010-12-18 19:03:40","category":"story","nextID":0,"previousID":0,"slug":"mind-boggling","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/mooning-the-squirrels.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/mooning-the-squirrels.static.md","numericId":84,"className":"Story","created":"2010-12-05 16:14:39","lastEdited":"2010-12-05 17:00:57","title":"Mooning the Squirrels","published":"2010-12-05 17:00:57","category":"story","nextID":0,"previousID":0,"slug":"mooning-the-squirrels","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/mothers-day-and-the-parade-of-the-johns.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/mothers-day-and-the-parade-of-the-johns.static.md","numericId":142,"className":"Story","created":"2011-05-09 14:04:51","lastEdited":"2011-05-09 14:46:45","title":"Mother's Day and the Parade of the Johns","published":"2011-05-09 14:46:45","category":"story","nextID":0,"previousID":0,"slug":"mothers-day-and-the-parade-of-the-johns","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/mt-farina-erupts-on-the-royal-wedding-dress.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/mt-farina-erupts-on-the-royal-wedding-dress.static.md","numericId":140,"className":"Story","created":"2011-04-29 14:12:39","lastEdited":"2011-04-29 17:14:22","title":"Mt. Farina erupts on the Royal Wedding Dress","published":"2011-04-29 17:14:22","category":"story","nextID":0,"previousID":0,"slug":"mt-farina-erupts-on-the-royal-wedding-dress","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/national-exhale-week.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/national-exhale-week.static.md","numericId":105,"className":"Story","created":"2010-12-24 15:55:10","lastEdited":"2010-12-24 16:17:49","title":"National Exhale Week","published":"2010-12-24 16:17:49","category":"story","nextID":0,"previousID":0,"slug":"national-exhale-week","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/neither-forest-nor-trees-and-sigh-mentors.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/neither-forest-nor-trees-and-sigh-mentors.static.md","numericId":83,"className":"Story","created":"2010-12-04 16:18:40","lastEdited":"2010-12-04 17:53:07","title":"Neither Forest Nor Trees and, sigh,  Mentors","published":"2010-12-04 17:53:07","category":"story","nextID":0,"previousID":0,"slug":"neither-forest-nor-trees-and-sigh-mentors","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/nobrow.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/nobrow.static.md","numericId":156,"className":"Story","created":"2011-07-10 15:33:31","lastEdited":"2011-07-10 15:33:31","title":"NoBrow","published":"2011-07-10 15:33:31","category":"story","nextID":0,"previousID":0,"slug":"nobrow","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/normalcy.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/normalcy.static.md","numericId":12,"className":"Story","created":"2010-10-02 12:38:52","lastEdited":"2011-08-24 13:25:29","title":"Normalcy","published":"2010-10-02 16:19:46","category":"story","nextID":0,"previousID":0,"slug":"normalcy","snippets":{"first name":"first name","roger":"roger"},"styling":"skeleton","debug":"partials"},{"id":"story/november-stretch.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/november-stretch.static.md","numericId":67,"className":"Story","created":"2010-11-20 17:55:37","lastEdited":"2011-08-08 13:58:42","title":"November Stretch","published":"2010-11-20 18:57:43","category":"story","nextID":0,"previousID":0,"slug":"november-stretch","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/of-gangs-and-angels.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/of-gangs-and-angels.static.md","numericId":126,"className":"Story","created":"2011-02-28 10:59:02","lastEdited":"2011-02-28 11:14:01","title":"Of Gangs and Angels","published":"2011-02-28 11:14:01","category":"story","nextID":0,"previousID":0,"slug":"of-gangs-and-angels","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/ongoing-investigation.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/ongoing-investigation.static.md","numericId":54,"className":"Story","created":"2010-11-10 17:13:18","lastEdited":"2010-11-16 17:10:37","title":"Ongoing Investigation","published":"2010-11-16 17:10:37","category":"story","nextID":0,"previousID":0,"slug":"ongoing-investigation","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/omg.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/omg.static.md","numericId":43,"className":"Story","created":"2010-10-31 15:51:07","lastEdited":"2010-10-31 16:39:16","title":"OMG","published":"2010-10-31 16:39:16","category":"story","nextID":0,"previousID":0,"slug":"omg","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/pathy-has-the-best-gossip.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/pathy-has-the-best-gossip.static.md","numericId":153,"className":"Story","created":"2011-06-19 21:31:51","lastEdited":"2011-06-19 22:08:58","title":"Pathy Has the Best Gossip","published":"2011-06-19 22:08:58","category":"story","nextID":0,"previousID":0,"slug":"pathy-has-the-best-gossip","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/pathy-warps-to-plant-speed.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/pathy-warps-to-plant-speed.static.md","numericId":127,"className":"Story","created":"2011-03-02 16:32:35","lastEdited":"2011-03-02 17:02:11","title":"Pathy Warps to Plant Speed","published":"2011-03-02 17:02:11","category":"story","nextID":0,"previousID":0,"slug":"pathy-warps-to-plant-speed","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/planning-for-pixies.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/planning-for-pixies.static.md","numericId":92,"className":"Story","created":"2010-12-12 16:14:23","lastEdited":"2011-11-23 12:14:38","title":"Planning for Pixies.","published":"2010-12-12 18:03:03","category":"story","nextID":0,"previousID":0,"slug":"planning-for-pixies","snippets":{"first name":"first name","sms,soto":"sms,soto","sms,voce":"sms,voce","tweetid":"tweetid"},"styling":"skeleton","debug":"partials"},{"id":"story/put-the-blood-of-the-lamb-in-your-throat.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/put-the-blood-of-the-lamb-in-your-throat.static.md","numericId":33,"className":"Story","created":"2010-10-22 12:07:31","lastEdited":"2010-10-22 12:53:09","title":"Put the Blood of the Lamb in Your Throat","published":"2010-10-22 12:53:09","category":"story","nextID":0,"previousID":0,"slug":"put-the-blood-of-the-lamb-in-your-throat","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/project-ying-yang-bang-bang.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/project-ying-yang-bang-bang.static.md","Handle":"YYBB","numericId":168,"className":"Story","created":"2011-09-08 14:07:24","lastEdited":"2011-09-08 14:42:00","title":"Project Ying Yang Bang Bang","published":"2011-09-08 14:42:00","tagList":"haarp,conspiracy,earthquakes,exploding watermelons","category":"story","nextID":0,"previousID":0,"slug":"project-ying-yang-bang-bang","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/roger-dojer-more-reliable-than-death.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/roger-dojer-more-reliable-than-death.static.md","Handle":"Reliable","numericId":166,"className":"Story","created":"2011-09-03 09:37:38","lastEdited":"2011-09-03 15:39:25","title":"Roger Dojer -- more reliable than death","published":"2011-09-03 15:39:25","tagList":"death","category":"story","nextID":0,"previousID":0,"slug":"roger-dojer-more-reliable-than-death","snippets":{"first name":"first name","rogerobt":"rogerobt","death":"death"},"styling":"skeleton","debug":"partials"},{"id":"story/rainy-september-sunday.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/rainy-september-sunday.static.md","numericId":5,"className":"Story","created":"2010-09-26 13:55:40","lastEdited":"2010-10-24 10:47:53","title":"Rainy September Sunday","published":"2010-10-24 10:47:53","category":"story","nextID":0,"previousID":0,"slug":"rainy-september-sunday","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/saying-goodbye-to-air-with-writers-block.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/saying-goodbye-to-air-with-writers-block.static.md","numericId":29,"className":"Story","created":"2010-10-17 09:22:56","lastEdited":"2010-10-22 13:12:20","title":"Saying goodbye to air with writer's block","published":"2010-10-22 13:12:20","category":"story","nextID":0,"previousID":0,"slug":"saying-goodbye-to-air-with-writers-block","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/roger-dojers-obituary.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/roger-dojers-obituary.static.md","Handle":"RogerObt","numericId":137,"className":"Story","created":"2011-04-13 17:29:02","lastEdited":"2011-08-24 13:22:26","title":"Roger Dojer's Obituary","published":"2011-04-13 18:24:09","category":"story","nextID":0,"previousID":0,"slug":"roger-dojers-obituary","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/scene-3-nobrow-and-throntle.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/scene-3-nobrow-and-throntle.static.md","numericId":93,"className":"Story","created":"2010-12-13 18:24:33","lastEdited":"2011-07-20 13:05:47","title":"Scene 3, Nobrow and Throntle","published":"2010-12-13 19:59:57","category":"story","nextID":0,"previousID":0,"slug":"scene-3-nobrow-and-throntle","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/shanghai-squirrels-by-the-score.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/shanghai-squirrels-by-the-score.static.md","numericId":154,"className":"Story","created":"2011-07-01 16:40:13","lastEdited":"2011-07-01 17:59:43","title":"Shanghai Squirrels by the Score","published":"2011-07-01 17:59:43","category":"story","nextID":0,"previousID":0,"slug":"shanghai-squirrels-by-the-score","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/seasonsgreetingsfest-2010.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/seasonsgreetingsfest-2010.static.md","numericId":85,"className":"Story","created":"2010-12-06 15:39:48","lastEdited":"2010-12-06 16:56:56","title":"SeasonsGreetingsFest 2010","published":"2010-12-06 16:56:56","category":"story","nextID":0,"previousID":0,"slug":"seasonsgreetingsfest-2010","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/seeking-fertile-ground.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/seeking-fertile-ground.static.md","numericId":35,"className":"Story","created":"2010-10-24 14:57:48","lastEdited":"2010-10-24 15:14:07","title":"Seeking Fertile Ground","published":"2010-10-24 15:14:07","category":"story","nextID":0,"previousID":0,"slug":"seeking-fertile-ground","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/shanghai-squirrels-poisons-poses-and-the-pioneer.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/shanghai-squirrels-poisons-poses-and-the-pioneer.static.md","numericId":155,"className":"Story","created":"2011-07-04 12:35:12","lastEdited":"2011-07-04 15:29:40","title":"Shanghai Squirrels: Poison's Poses and the Pioneer","published":"2011-07-04 15:29:40","category":"story","nextID":0,"previousID":0,"slug":"shanghai-squirrels-poisons-poses-and-the-pioneer","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/shanghai-tunnel-tales-part-1.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/shanghai-tunnel-tales-part-1.static.md","numericId":149,"className":"Story","created":"2011-06-11 13:47:40","lastEdited":"2011-06-11 14:27:21","title":"Shanghai Tunnel Tales - Part 1","published":"2011-06-11 14:27:21","category":"story","nextID":0,"previousID":0,"slug":"shanghai-tunnel-tales-part-1","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/skydiving-with-lord-ego.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/skydiving-with-lord-ego.static.md","numericId":80,"className":"Story","created":"2010-12-02 17:11:32","lastEdited":"2010-12-02 17:56:03","title":"Skydiving with Lord Ego","published":"2010-12-02 17:56:03","category":"story","nextID":0,"previousID":0,"slug":"skydiving-with-lord-ego","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/snow-rummys.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/snow-rummys.static.md","numericId":78,"className":"Story","created":"2010-11-30 15:07:52","lastEdited":"2010-11-30 17:40:19","title":"Snow Rummys","published":"2010-11-30 17:40:19","category":"story","nextID":0,"previousID":0,"slug":"snow-rummys","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/simple-scientific-reality.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/simple-scientific-reality.static.md","numericId":24,"className":"Story","created":"2010-10-13 11:34:24","lastEdited":"2010-10-13 12:40:30","title":"Simple Scientific Reality","published":"2010-10-13 12:40:30","category":"story","nextID":0,"previousID":0,"slug":"simple-scientific-reality","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/solitude-spiders-and-cougars.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/solitude-spiders-and-cougars.static.md","numericId":40,"className":"Story","created":"2010-10-28 18:24:23","lastEdited":"2010-10-28 18:51:44","title":"Solitude, Spiders, and Cougars","published":"2010-10-28 18:51:44","category":"story","nextID":0,"previousID":0,"slug":"solitude-spiders-and-cougars","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/southwick-in-the-slammer.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/southwick-in-the-slammer.static.md","numericId":120,"className":"Story","created":"2011-01-27 20:33:17","lastEdited":"2011-01-27 21:28:28","title":"Southwick in the Slammer??!!!","published":"2011-01-27 21:28:28","category":"story","nextID":0,"previousID":0,"slug":"southwick-in-the-slammer","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/sonofabitch-day.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/sonofabitch-day.static.md","numericId":134,"className":"Story","created":"2011-04-06 14:55:01","lastEdited":"2011-04-06 15:02:53","title":"SonOfABitch Day!","published":"2011-04-06 15:02:53","category":"story","nextID":0,"previousID":0,"slug":"sonofabitch-day","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/southwicks-deep-background-report-on-3-gunas-lp.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/southwicks-deep-background-report-on-3-gunas-lp.static.md","Handle":"3gunas","numericId":57,"className":"Story","created":"2010-11-13 15:26:15","lastEdited":"2011-10-03 12:23:02","title":"Southwick's Deep Background Report on 3 Gunas Lp","published":"2010-11-13 18:15:27","category":"story","nextID":0,"previousID":0,"slug":"southwicks-deep-background-report-on-3-gunas-lp","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/southwicks-report-on-als-crotch-rocket.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/southwicks-report-on-als-crotch-rocket.static.md","numericId":21,"className":"Story","created":"2010-10-08 12:18:46","lastEdited":"2010-11-13 14:53:19","title":"Southwick's report on Al's Crotch-Rocket","published":"2010-10-08 12:37:00","category":"story","nextID":0,"previousID":0,"slug":"southwicks-report-on-als-crotch-rocket","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/squirrel-tag.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/squirrel-tag.static.md","numericId":147,"className":"Story","created":"2011-06-05 21:12:18","lastEdited":"2011-06-05 21:26:04","title":"Squirrel Tag","published":"2011-06-05 21:26:04","category":"story","nextID":0,"previousID":0,"slug":"squirrel-tag","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/st-johns-gives-spring-the-pink-slip.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/st-johns-gives-spring-the-pink-slip.static.md","numericId":129,"className":"Story","created":"2011-03-10 21:32:47","lastEdited":"2011-03-10 21:52:38","title":"St. John's Gives Spring the Pink Slip","published":"2011-03-10 21:52:38","category":"story","nextID":0,"previousID":0,"slug":"st-johns-gives-spring-the-pink-slip","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/st-johns-infirmary.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/st-johns-infirmary.static.md","numericId":51,"className":"Story","created":"2010-11-08 11:03:20","lastEdited":"2011-07-20 13:06:44","title":"St John's Infirmary","published":"2010-11-08 11:41:53","category":"story","nextID":0,"previousID":0,"slug":"st-johns-infirmary","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/st-johns-jim-and-the-st-johns-lighthouse.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/st-johns-jim-and-the-st-johns-lighthouse.static.md","numericId":17,"className":"Story","created":"2010-10-07 16:05:13","lastEdited":"2010-10-07 16:08:50","title":"St. John's Jim and the St. John's Lighthouse","published":"2010-10-07 16:08:50","category":"story","nextID":0,"previousID":0,"slug":"st-johns-jim-and-the-st-johns-lighthouse","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/st-john-and-the-diamonds.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/st-john-and-the-diamonds.static.md","numericId":109,"className":"Story","created":"2010-12-31 11:49:28","lastEdited":"2011-01-02 12:25:56","title":"St. John and the Diamonds","published":"2011-01-02 12:25:56","category":"story","nextID":0,"previousID":0,"slug":"st-john-and-the-diamonds","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/st-johns-tweets.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/st-johns-tweets.static.md","numericId":39,"className":"Story","created":"2010-10-26 16:15:26","lastEdited":"2010-10-27 23:55:34","title":"St Johns Tweets","published":"2010-10-27 23:55:34","category":"story","nextID":0,"previousID":0,"slug":"st-johns-tweets","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/stan-and-valerie.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/stan-and-valerie.static.md","Handle":"SVTower","numericId":174,"className":"Story","created":"2011-10-16 12:11:34","lastEdited":"2011-10-16 12:12:41","title":"Stan and Valerie","published":"2011-10-16 12:11:34","category":"story","nextID":0,"previousID":0,"slug":"stan-and-valerie","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/streetwatch-2011-whores-on-wheels.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/streetwatch-2011-whores-on-wheels.static.md","Handle":"wheelwho","numericId":112,"className":"Story","created":"2011-01-04 21:45:14","lastEdited":"2011-09-10 13:00:41","title":"Streetwatch 2011: Whores On Wheels","published":"2011-01-04 21:45:14","category":"story","nextID":0,"previousID":0,"slug":"streetwatch-2011-whores-on-wheels","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/stevens-story.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/stevens-story.static.md","numericId":177,"className":"Story","created":"2011-10-17 17:27:04","lastEdited":"2011-10-19 13:19:05","title":"Steven's Story","published":"2011-10-17 17:27:04","category":"story","nextID":0,"previousID":0,"slug":"stevens-story","snippets":{"tmyweb":"tmyweb"},"styling":"skeleton","debug":"partials"},{"id":"story/susannas-song.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/susannas-song.static.md","numericId":118,"className":"Story","created":"2011-01-25 17:51:08","lastEdited":"2011-01-25 18:34:31","title":"Susanna's Song","published":"2011-01-25 18:34:31","category":"story","nextID":0,"previousID":0,"slug":"susannas-song","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/tastes-aromas-and-earthquakes.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/tastes-aromas-and-earthquakes.static.md","numericId":90,"className":"Story","created":"2010-12-11 17:46:51","lastEdited":"2010-12-11 20:04:34","title":"Tastes, Aromas and Earthquakes","published":"2010-12-11 20:04:34","category":"story","nextID":0,"previousID":0,"slug":"tastes-aromas-and-earthquakes","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/thanksgiving.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/thanksgiving.static.md","numericId":72,"className":"Story","created":"2010-11-25 14:27:56","lastEdited":"2010-11-25 17:11:21","title":"Thanksgiving","published":"2010-11-25 17:11:21","category":"story","nextID":0,"previousID":0,"slug":"thanksgiving","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-catalyst-of-august.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-catalyst-of-august.static.md","numericId":160,"className":"Story","created":"2011-08-20 17:19:30","lastEdited":"2011-08-20 17:19:30","title":"The Catalyst of August","published":"2011-08-20 17:19:30","tagList":"laughter, compassion, family life, cosmic humor","category":"story","nextID":0,"previousID":0,"slug":"the-catalyst-of-august","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-big-rock-candy-new-year.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-big-rock-candy-new-year.static.md","numericId":110,"className":"Story","created":"2011-01-01 18:16:10","lastEdited":"2011-01-01 18:35:30","title":"The Big Rock Candy New Year","published":"2011-01-01 18:35:30","category":"story","nextID":0,"previousID":0,"slug":"the-big-rock-candy-new-year","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-bully-proof-dance.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-bully-proof-dance.static.md","numericId":45,"className":"Story","created":"2010-11-02 17:05:17","lastEdited":"2010-11-02 17:29:19","title":"The Bully Proof Dance","published":"2010-11-02 17:29:19","category":"story","nextID":0,"previousID":0,"slug":"the-bully-proof-dance","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-aloha-account.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-aloha-account.static.md","numericId":144,"className":"Story","created":"2011-05-25 17:55:05","lastEdited":"2011-05-25 18:26:37","title":"The Aloha Account","published":"2011-05-25 18:26:37","category":"story","nextID":0,"previousID":0,"slug":"the-aloha-account","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-daough-sisters-sustainable-cat-lips.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-daough-sisters-sustainable-cat-lips.static.md","numericId":122,"className":"Story","created":"2011-02-04 16:24:15","lastEdited":"2011-02-04 16:38:58","title":"The Daough Sister's Sustainable Cat Lips","published":"2011-02-04 16:38:58","category":"story","nextID":0,"previousID":0,"slug":"the-daough-sisters-sustainable-cat-lips","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-cougars-secret-identity.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-cougars-secret-identity.static.md","Handle":"TCtalks","numericId":172,"className":"Story","created":"2011-10-10 13:47:35","lastEdited":"2011-10-11 15:59:52","title":"The Cougar's Secret Identity","published":"2011-10-10 13:47:35","tagList":"the cougar, holloween, pier park, forest park, portland","category":"story","nextID":0,"previousID":0,"slug":"the-cougars-secret-identity","snippets":{"first name":"first name","fbgender":"fbgender","tcreturn":"tcreturn"},"styling":"skeleton","debug":"partials"},{"id":"story/the-cougar-returns.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-cougar-returns.static.md","Handle":"TCreturn","numericId":173,"className":"Story","created":"2011-10-11 16:04:31","lastEdited":"2011-10-11 16:20:37","title":"The Cougar Returns!","published":"2011-10-11 16:04:31","category":"story","nextID":0,"previousID":0,"slug":"the-cougar-returns","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-fist-of-perhaps.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-fist-of-perhaps.static.md","numericId":59,"className":"Story","created":"2010-11-15 15:13:45","lastEdited":"2010-11-16 17:10:37","title":"The Fist of Perhaps","published":"2010-11-16 17:10:37","category":"story","nextID":0,"previousID":0,"slug":"the-fist-of-perhaps","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-ghost-of-gbs-walks-st-johns.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-ghost-of-gbs-walks-st-johns.static.md","numericId":175,"className":"Story","created":"2011-10-17 11:35:40","lastEdited":"2011-10-17 11:35:40","title":"The Ghost of GBS walks St. John's","published":"2011-10-17 11:35:40","category":"story","nextID":0,"previousID":0,"slug":"the-ghost-of-gbs-walks-st-johns","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-great-harvest-moon-part-1.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-great-harvest-moon-part-1.static.md","numericId":7,"className":"Story","created":"2010-09-28 10:26:39","lastEdited":"2010-11-21 11:17:20","title":"The Great Harvest Moon - Part 1","published":"2010-11-21 11:17:20","category":"story","nextID":0,"previousID":0,"slug":"the-great-harvest-moon-part-1","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-gift-of-who-are-you.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-gift-of-who-are-you.static.md","numericId":145,"className":"Story","created":"2011-05-29 16:05:23","lastEdited":"2011-05-29 16:52:37","title":"The Gift of \"Who Are You?\"","published":"2011-05-29 16:52:37","category":"story","nextID":0,"previousID":0,"slug":"the-gift-of-who-are-you","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-great-harvest-moon-part-2.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-great-harvest-moon-part-2.static.md","numericId":9,"className":"Story","created":"2010-09-30 13:02:18","lastEdited":"2010-11-21 11:17:30","title":"The Great Harvest Moon - Part 2","published":"2010-11-21 11:17:30","category":"story","nextID":0,"previousID":0,"slug":"the-great-harvest-moon-part-2","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-great-aerial-tram-station.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-great-aerial-tram-station.static.md","numericId":158,"className":"Story","created":"2011-08-05 18:38:57","lastEdited":"2011-08-05 18:54:38","title":"The Great Aerial Tram Station","published":"2011-08-05 18:54:38","tagList":"Pathy, Winnie, Daough Sisters, aerial tram, portland, st. john's, Leo, Station, Portland's Malibu","category":"story","nextID":0,"previousID":0,"slug":"the-great-aerial-tram-station","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-great-harvest-moon-part-3-cleaning-up-the.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-great-harvest-moon-part-3-cleaning-up-the.static.md","numericId":11,"className":"Story","created":"2010-10-01 13:57:08","lastEdited":"2010-11-21 11:17:38","title":"The Great Harvest Moon - Part 3 -- cleaning up the","published":"2010-11-21 11:17:38","category":"story","nextID":0,"previousID":0,"slug":"the-great-harvest-moon-part-3-cleaning-up-the","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-lovers.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-lovers.static.md","numericId":60,"className":"Story","created":"2010-11-16 20:03:00","lastEdited":"2010-11-16 20:26:40","title":"The Lovers","published":"2010-11-16 20:26:40","category":"story","nextID":0,"previousID":0,"slug":"the-lovers","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-kung-fu-lions-roar.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-kung-fu-lions-roar.static.md","Handle":"roar","numericId":28,"className":"Story","created":"2010-10-16 14:49:56","lastEdited":"2011-11-08 14:51:21","title":"The Kung Fu Lion's Roar","published":"2010-10-16 16:47:35","category":"story","nextID":0,"previousID":0,"slug":"the-kung-fu-lions-roar","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-man-who-walked.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-man-who-walked.static.md","numericId":189,"className":"Story","created":"2012-12-12 21:00:20","lastEdited":"2012-12-12 21:00:20","title":"The Man Who Walked","published":"2012-12-12 21:00:20","category":"story","nextID":0,"previousID":0,"slug":"the-man-who-walked","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-monk-in-the-kingdom-of-prosperity.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-monk-in-the-kingdom-of-prosperity.static.md","numericId":74,"className":"Story","created":"2010-11-27 16:50:25","lastEdited":"2010-11-27 17:49:49","title":"The Monk in the Kingdom of Prosperity","published":"2010-11-27 17:49:49","category":"story","nextID":0,"previousID":0,"slug":"the-monk-in-the-kingdom-of-prosperity","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-mouse-and-the-elephant.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-mouse-and-the-elephant.static.md","numericId":64,"className":"Story","created":"2010-11-19 16:32:53","lastEdited":"2010-11-19 17:37:39","title":"The Mouse and The Elephant","published":"2010-11-19 17:37:39","category":"story","nextID":0,"previousID":0,"slug":"the-mouse-and-the-elephant","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-mana-vampire-2.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-mana-vampire-2.static.md","numericId":27,"className":"Story","created":"2010-10-15 11:59:59","lastEdited":"2010-10-15 12:01:45","title":"The Mana Vampire - 2","published":"2010-10-15 12:01:45","category":"story","nextID":0,"previousID":0,"slug":"the-mana-vampire-2","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-norse-psychologist-files-on-thor.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-norse-psychologist-files-on-thor.static.md","numericId":107,"className":"Story","created":"2010-12-28 21:35:15","lastEdited":"2011-11-09 10:24:21","title":"The Norse Psychologist Files on Thor","published":"2010-12-28 22:08:13","category":"story","nextID":0,"previousID":0,"slug":"the-norse-psychologist-files-on-thor","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-seamsters-union.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-seamsters-union.static.md","numericId":4,"className":"Story","created":"2010-09-25 15:04:45","lastEdited":"2010-11-16 17:10:36","title":"The Seamster's Union","published":"2010-11-16 17:10:36","category":"story","nextID":0,"previousID":0,"slug":"the-seamsters-union","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/the-six-billion-dollar-chef.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-six-billion-dollar-chef.static.md","debug":"partials","numericId":113,"className":"Story","created":"2011-01-06 20:29:19","lastEdited":"2011-11-08 14:46:37","title":"The Six Billion Dollar Chef","published":"2011-01-06 21:24:57","category":"story","nextID":0,"previousID":0,"slug":"the-six-billion-dollar-chef","snippets":{"author":"author","comment,soto":"comment,soto","comment,voce":"comment,voce"},"styling":"skeleton"},{"id":"story/the-st-johns-excuse-my-reuse-warehouse.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-st-johns-excuse-my-reuse-warehouse.static.md","numericId":136,"className":"Story","created":"2011-04-12 17:57:12","lastEdited":"2011-11-09 10:17:55","title":"The St. John's Excuse-My-Reuse Warehouse","published":"2011-04-12 18:26:36","category":"story","nextID":0,"previousID":0,"slug":"the-st-johns-excuse-my-reuse-warehouse","snippets":{"first name":"first name","rogerobt":"rogerobt","comment,soto":"comment,soto","comment,voce":"comment,voce","author":"author"},"styling":"skeleton","debug":"partials"},{"id":"story/the-st-johns-lighthouse-in-the-bardo.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-st-johns-lighthouse-in-the-bardo.static.md","numericId":1,"className":"Story","created":"2010-09-25 14:20:18","lastEdited":"2010-10-15 14:19:46","title":"The St. John's Lighthouse in the Bardo","published":"2010-10-15 14:19:46","category":"story","nextID":0,"previousID":0,"slug":"the-st-johns-lighthouse-in-the-bardo","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-toy-store-that-kills.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-toy-store-that-kills.static.md","numericId":76,"className":"Story","created":"2010-11-28 16:01:40","lastEdited":"2010-11-28 17:00:47","title":"The Toy Store that Kills","published":"2010-11-28 17:00:47","category":"story","nextID":0,"previousID":0,"slug":"the-toy-store-that-kills","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-worst-of-plans-the-best-of-plans.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-worst-of-plans-the-best-of-plans.static.md","numericId":23,"className":"Story","created":"2010-10-10 13:22:21","lastEdited":"2010-10-24 10:47:55","title":"The Worst of Plans, the Best of Plans.","published":"2010-10-24 10:47:55","category":"story","nextID":0,"previousID":0,"slug":"the-worst-of-plans-the-best-of-plans","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/the-tropic-of-oregon.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/the-tropic-of-oregon.static.md","numericId":16,"className":"Story","created":"2010-10-07 13:30:46","lastEdited":"2010-10-11 14:20:37","title":"The Tropic of Oregon","published":"2010-10-07 16:38:29","category":"story","nextID":0,"previousID":0,"slug":"the-tropic-of-oregon","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/they-leave-the-west-behind.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/they-leave-the-west-behind.static.md","numericId":121,"className":"Story","created":"2011-02-02 12:14:23","lastEdited":"2011-02-02 14:10:42","title":"They Leave the West Behind","published":"2011-02-02 14:10:42","category":"story","nextID":0,"previousID":0,"slug":"they-leave-the-west-behind","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/tommy-believes-in-magic.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/tommy-believes-in-magic.static.md","numericId":50,"className":"Story","created":"2010-11-07 16:57:07","lastEdited":"2010-11-07 17:36:36","title":"Tommy Believes in Magic","published":"2010-11-07 17:36:36","category":"story","nextID":0,"previousID":0,"slug":"tommy-believes-in-magic","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/tommys-web-catches-steven-and-bambi.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/tommys-web-catches-steven-and-bambi.static.md","Handle":"Tmyweb","numericId":178,"className":"Story","created":"2011-10-19 13:12:26","lastEdited":"2011-10-22 11:38:58","title":"Tommy's Web Catches Steven and Bambi","published":"2011-10-19 13:12:27","category":"story","nextID":0,"previousID":177,"slug":"tommys-web-catches-steven-and-bambi","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/tommy-starts-a-bed-and-breakfast.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/tommy-starts-a-bed-and-breakfast.static.md","numericId":88,"className":"Story","created":"2010-12-09 16:29:33","lastEdited":"2010-12-09 17:20:23","title":"Tommy Starts A Bed and Breakfast","published":"2010-12-09 17:20:23","category":"story","nextID":0,"previousID":0,"slug":"tommy-starts-a-bed-and-breakfast","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/tommy-or-recycles.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/tommy-or-recycles.static.md","numericId":36,"className":"Story","created":"2010-10-25 14:43:13","lastEdited":"2010-10-30 17:18:40","title":"Tommy, OR Recycles","published":"2010-10-30 17:18:40","category":"story","nextID":0,"previousID":0,"slug":"tommy-or-recycles","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/valerie-flees-to-confusistan.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/valerie-flees-to-confusistan.static.md","numericId":176,"className":"Story","created":"2011-10-17 14:00:24","lastEdited":"2011-11-20 11:22:32","title":"Valerie flees to Confusistan","published":"2011-10-17 14:00:24","category":"story","nextID":0,"previousID":0,"slug":"valerie-flees-to-confusistan","snippets":{"svtower":"svtower"},"styling":"skeleton","debug":"partials"},{"id":"story/ultimate-protection-of-the-geyser-shirt-of-bliss.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/ultimate-protection-of-the-geyser-shirt-of-bliss.static.md","numericId":135,"className":"Story","created":"2011-04-10 12:17:44","lastEdited":"2011-04-10 12:28:49","title":"Ultimate Protection of the Geyser Shirt of Bliss","published":"2011-04-10 12:28:49","category":"story","nextID":0,"previousID":0,"slug":"ultimate-protection-of-the-geyser-shirt-of-bliss","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/too-young.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/too-young.static.md","numericId":152,"className":"Story","created":"2011-06-14 17:02:44","lastEdited":"2011-06-14 17:17:02","title":"Too Young?","published":"2011-06-14 17:17:02","category":"story","nextID":0,"previousID":0,"slug":"too-young","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/truck-fight.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/truck-fight.static.md","numericId":188,"className":"Story","created":"2012-06-01 17:33:14","lastEdited":"2012-06-01 19:55:39","title":"Truck Fight","published":"2012-06-01 17:33:14","tagList":"Leo,Tommy,Station,Felix,Merton","category":"story","nextID":0,"previousID":0,"slug":"truck-fight","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/whats-across-the-bridge-1.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/whats-across-the-bridge-1.static.md","numericId":62,"className":"Story","created":"2010-11-18 16:05:56","lastEdited":"2010-11-18 17:43:10","title":"What's Across the Bridge -- #1","published":"2010-11-18 17:25:20","category":"story","nextID":0,"previousID":0,"slug":"whats-across-the-bridge-1","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/when-i-get-stubbed-i-want-to-be-a-big-ash.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/when-i-get-stubbed-i-want-to-be-a-big-ash.static.md","numericId":111,"className":"Story","created":"2011-01-03 18:56:07","lastEdited":"2011-01-03 19:24:54","title":"When I Get Stubbed, I Want to be a Big Ash","published":"2011-01-03 19:24:54","category":"story","nextID":0,"previousID":0,"slug":"when-i-get-stubbed-i-want-to-be-a-big-ash","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/valkerie-tweets.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/valkerie-tweets.static.md","numericId":37,"className":"Story","created":"2010-10-25 15:55:41","lastEdited":"2010-10-25 16:24:19","title":"Valkerie Tweets","published":"2010-10-25 16:24:19","category":"story","nextID":0,"previousID":0,"slug":"valkerie-tweets","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/when-kings-clash.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/when-kings-clash.static.md","numericId":143,"className":"Story","created":"2011-05-17 15:34:33","lastEdited":"2011-05-17 17:48:19","title":"When Kings Clash","published":"2011-05-17 17:48:19","category":"story","nextID":0,"previousID":0,"slug":"when-kings-clash","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/winnie-daoughs-peck-and-puke-hen-hats.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/winnie-daoughs-peck-and-puke-hen-hats.static.md","numericId":123,"className":"Story","created":"2011-02-09 20:32:42","lastEdited":"2011-02-09 20:54:29","title":"Winnie Daough's Peck-and-Puke Hen Hats","published":"2011-02-09 20:54:29","category":"story","nextID":0,"previousID":0,"slug":"winnie-daoughs-peck-and-puke-hen-hats","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/when-kings-come-home.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/when-kings-come-home.static.md","numericId":89,"className":"Story","created":"2010-12-10 16:50:07","lastEdited":"2010-12-10 17:54:37","title":"When Kings Come Home","published":"2010-12-10 17:54:37","category":"story","nextID":0,"previousID":0,"slug":"when-kings-come-home","snippets":{},"styling":"skeleton","debug":"partials"},{"id":"story/you-cant-always-get-what-you-want.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/you-cant-always-get-what-you-want.static.md","numericId":52,"className":"Story","created":"2010-11-09 18:17:37","lastEdited":"2011-07-20 13:07:46","title":"You cant always get what you want","published":"2010-11-16 17:10:36","category":"story","nextID":0,"previousID":0,"slug":"you-cant-always-get-what-you-want","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"},{"id":"story/wrestling-with-memes-again.static.md","outputPath":"/Users/jim/static-site-development/stjohnsjim/public/story/wrestling-with-memes-again.static.md","numericId":86,"className":"Story","created":"2010-12-07 18:05:15","lastEdited":"2010-12-07 19:56:49","title":"Wrestling with Memes Again","published":"2010-12-07 19:56:49","category":"story","nextID":0,"previousID":0,"slug":"wrestling-with-memes-again","snippets":{"first name":"first name"},"styling":"skeleton","debug":"partials"}];
});

require.register("app", function(exports, require, module) {
var Application, FooterController, HomeController, MenuController, SideBarController, routes, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MenuController = require('controllers/menu');

FooterController = require('controllers/footer');

HomeController = require('controllers/home');

SideBarController = require('controllers/sidebar');

routes = require('routes');

'use strict';

module.exports = Application = (function(_super) {
  __extends(Application, _super);

  function Application() {
    _ref = Application.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Application.prototype.initialize = function() {
    window.APP = this;
    this.initDispatcher({
      controllerSuffix: '',
      controllerPath: 'controllers/'
    });
    this.initLayout();
    this.initComposer();
    this.initMediator();
    this.initControllers();
    this.initRouter(routes, {
      root: '/',
      pushState: false
    });
    this.start();
    return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
  };

  Application.prototype.initMediator = function() {
    Chaplin.mediator.controllerAction = "";
    return Chaplin.mediator.actionParams = {};
  };

  Application.prototype.initControllers = function() {
    new HomeController;
    new SideBarController;
    new MenuController;
    return new FooterController;
  };

  return Application;

})(Chaplin.Application);
});

;require.register("application", function(exports, require, module) {
var Application, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = Application = (function(_super) {
  __extends(Application, _super);

  function Application() {
    _ref = Application.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Application.prototype.start = function() {
    return Application.__super__.start.call(this);
  };

  return Application;

})(Chaplin.Application);
});

;require.register("config", function(exports, require, module) {
var config;

config = {
  dev: {
    loglevel: 'TRACE'
  }
};
});

;require.register("controllers/base/controller", function(exports, require, module) {
'use strict';
var BaseController, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = BaseController = (function(_super) {
  __extends(BaseController, _super);

  function BaseController() {
    _ref = BaseController.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  return BaseController;

})(Chaplin.Controller);
});

;require.register("controllers/footer", function(exports, require, module) {
var BaseController, FooterController, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseController = require('controllers/base/controller');

'use strict';

module.exports = FooterController = (function(_super) {
  __extends(FooterController, _super);

  function FooterController() {
    _ref = FooterController.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  return FooterController;

})(BaseController);
});

;require.register("controllers/home", function(exports, require, module) {
var HomeController, PageController, log, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PageController = require('controllers/page');

log = require('loglevel');

'use strict';

module.exports = HomeController = (function(_super) {
  __extends(HomeController, _super);

  function HomeController() {
    _ref = HomeController.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  HomeController.prototype.showit = function() {
    alert("Gaa Chua! Muk Muk!");
    return false;
  };

  HomeController.prototype.show = function() {
    alert('HomeController: show!!');
    return log.info('HomeController:show');
  };

  return HomeController;

})(PageController);
});

;require.register("controllers/menu", function(exports, require, module) {
var BaseController, MenuController, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseController = require('controllers/base/controller');

'use strict';

module.exports = MenuController = (function(_super) {
  __extends(MenuController, _super);

  function MenuController() {
    _ref = MenuController.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  return MenuController;

})(BaseController);
});

;require.register("controllers/page", function(exports, require, module) {
var BaseController, PageController, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseController = require('controllers/base/controller');

'use strict';

module.exports = PageController = (function(_super) {
  __extends(PageController, _super);

  function PageController() {
    _ref = PageController.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  PageController.prototype.beforeAction = function(actionParams, controllerOptions) {
    Chaplin.mediator.controllerAction = controllerOptions.action;
    return Chaplin.mediator.actionParams = actionParams;
  };

  return PageController;

})(BaseController);
});

;require.register("controllers/sidebar", function(exports, require, module) {
var BaseController, SSView, SideBarController, StoryCollection, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

BaseController = require('controllers/base/controller');

StoryCollection = require('models/stories');

SSView = require('views/sidebar-story-view');

'use strict';

module.exports = SideBarController = (function(_super) {
  __extends(SideBarController, _super);

  function SideBarController() {
    _ref = SideBarController.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  SideBarController.prototype.initialize = function() {
    SideBarController.__super__.initialize.apply(this, arguments);
    this.stories = new StoryCollection;
    return this.view = new SSView(this.stories);
  };

  SideBarController.prototype.showit = function() {
    return this.view.render();
  };

  return SideBarController;

})(BaseController);
});

;require.register("initialize", function(exports, require, module) {
var Application, routes;

Application = require('app');

routes = require('routes');

$(function() {
  var app;
  return app = new Application({
    title: 'Brunch example application',
    controllerSuffixNot: '-controller',
    routes: routes
  });
});
});

;require.register("lib/services/facebook", function(exports, require, module) {
var Facebook, ServiceProvider, utils,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

utils = require('lib/utils');

ServiceProvider = require('lib/services/service_provider');

module.exports = Facebook = (function(_super) {
  var facebookAppId, facebookAppSecret, scope;

  __extends(Facebook, _super);

  facebookAppId = '328156020565364';

  facebookAppSecret = '8af1208ed9f01b5ebd47657b4aec05d4';

  scope = 'user_likes';

  Facebook.prototype.name = 'facebook';

  Facebook.prototype.status = null;

  Facebook.prototype.accessToken = null;

  function Facebook() {
    this.processUserData = __bind(this.processUserData, this);
    this.facebookLogout = __bind(this.facebookLogout, this);
    this.loginStatusAfterAbort = __bind(this.loginStatusAfterAbort, this);
    this.loginHandler = __bind(this.loginHandler, this);
    this.triggerLogin = __bind(this.triggerLogin, this);
    this.loginStatusHandler = __bind(this.loginStatusHandler, this);
    this.getLoginStatus = __bind(this.getLoginStatus, this);
    this.saveAuthResponse = __bind(this.saveAuthResponse, this);
    this.loadHandler = __bind(this.loadHandler, this);
    Facebook.__super__.constructor.apply(this, arguments);
    utils.deferMethods({
      deferred: this,
      methods: ['parse', 'subscribe', 'postToGraph', 'getAccumulatedInfo', 'getInfo'],
      onDeferral: this.load
    });
    utils.wrapAccumulators(this, ['getAccumulatedInfo']);
    this.subscribeEvent('logout', this.logout);
  }

  Facebook.prototype.load = function() {
    if (this.state() === 'resolved' || this.loading) {
      return;
    }
    this.loading = true;
    window.fbAsyncInit = this.loadHandler;
    return utils.loadLib('http://connect.facebook.net/en_US/all.js', null, this.reject);
  };

  Facebook.prototype.loadHandler = function() {
    var error;
    this.loading = false;
    try {
      delete window.fbAsyncInit;
    } catch (_error) {
      error = _error;
      window.fbAsyncInit = void 0;
    }
    FB.init({
      appId: facebookAppId,
      status: true,
      cookie: true,
      xfbml: false
    });
    this.registerHandlers();
    return this.resolve();
  };

  Facebook.prototype.registerHandlers = function() {
    this.subscribe('auth.logout', this.facebookLogout);
    this.subscribe('edge.create', this.processLike);
    return this.subscribe('comment.create', this.processComment);
  };

  Facebook.prototype.unregisterHandlers = function() {
    this.unsubscribe('auth.logout', this.facebookLogout);
    this.unsubscribe('edge.create', this.processLike);
    return this.unsubscribe('comment.create', this.processComment);
  };

  Facebook.prototype.isLoaded = function() {
    return Boolean(window.FB && FB.login);
  };

  Facebook.prototype.saveAuthResponse = function(response) {
    var authResponse;
    this.status = response.status;
    authResponse = response.authResponse;
    if (authResponse) {
      return this.accessToken = authResponse.accessToken;
    } else {
      return this.accessToken = null;
    }
  };

  Facebook.prototype.getLoginStatus = function(callback, force) {
    if (callback == null) {
      callback = this.loginStatusHandler;
    }
    if (force == null) {
      force = false;
    }
    return FB.getLoginStatus(callback, force);
  };

  Facebook.prototype.loginStatusHandler = function(response) {
    var authResponse;
    this.saveAuthResponse(response);
    authResponse = response.authResponse;
    if (authResponse) {
      this.publishSession(authResponse);
      return this.getUserData();
    } else {
      return this.publishEvent('logout');
    }
  };

  Facebook.prototype.triggerLogin = function(loginContext) {
    return FB.login(_(this.loginHandler).bind(this, loginContext), {
      scope: scope
    });
  };

  Facebook.prototype.loginHandler = function(loginContext, response) {
    var authResponse, eventPayload, loginStatusHandler;
    this.saveAuthResponse(response);
    authResponse = response.authResponse;
    eventPayload = {
      provider: this,
      loginContext: loginContext
    };
    if (authResponse) {
      this.publishEvent('loginSuccessful', eventPayload);
      this.publishSession(authResponse);
      return this.getUserData();
    } else {
      this.publishEvent('loginAbort', eventPayload);
      loginStatusHandler = _(this.loginStatusAfterAbort).bind(this, loginContext);
      return this.getLoginStatus(loginStatusHandler, true);
    }
  };

  Facebook.prototype.loginStatusAfterAbort = function(loginContext, response) {
    var authResponse, eventPayload;
    this.saveAuthResponse(response);
    authResponse = response.authResponse;
    eventPayload = {
      provider: this,
      loginContext: loginContext
    };
    if (authResponse) {
      this.publishEvent('loginSuccessful', eventPayload);
      return this.publishSession(authResponse);
    } else {
      return this.publishEvent('loginFail', eventPayload);
    }
  };

  Facebook.prototype.publishSession = function(authResponse) {
    return this.publishEvent('serviceProviderSession', {
      provider: this,
      userId: authResponse.userID,
      accessToken: authResponse.accessToken
    });
  };

  Facebook.prototype.facebookLogout = function(response) {
    return this.saveAuthResponse(response);
  };

  Facebook.prototype.logout = function() {
    return this.status = this.accessToken = null;
  };

  Facebook.prototype.processLike = function(url) {
    return this.publishEvent('facebook:like', url);
  };

  Facebook.prototype.processComment = function(comment) {
    return this.publishEvent('facebook:comment', comment.href);
  };

  Facebook.prototype.parse = function(el) {
    return FB.XFBML.parse(el);
  };

  Facebook.prototype.subscribe = function(eventType, handler) {
    return FB.Event.subscribe(eventType, handler);
  };

  Facebook.prototype.unsubscribe = function(eventType, handler) {
    return FB.Event.unsubscribe(eventType, handler);
  };

  Facebook.prototype.postToGraph = function(ogResource, data, callback) {
    return FB.api(ogResource, 'post', data, function(response) {
      if (callback) {
        return callback(response);
      }
    });
  };

  Facebook.prototype.getAccumulatedInfo = function(urls, callback) {
    if (typeof urls === 'string') {
      urls = [urls];
    }
    urls = _(urls).reduce(function(memo, url) {
      if (memo) {
        memo += ',';
      }
      return memo += encodeURIComponent(url);
    }, '');
    return FB.api("?ids=" + urls, callback);
  };

  Facebook.prototype.getInfo = function(id, callback) {
    return FB.api(id, callback);
  };

  Facebook.prototype.getUserData = function() {
    return this.getInfo('/me', this.processUserData);
  };

  Facebook.prototype.processUserData = function(response) {
    return this.publishEvent('userData', response);
  };

  Facebook.prototype.dispose = function() {
    if (this.disposed) {
      return;
    }
    this.unregisterHandlers();
    delete this.status;
    delete this.accessToken;
    return Facebook.__super__.dispose.apply(this, arguments);
  };

  return Facebook;

})(ServiceProvider);
});

;require.register("lib/services/google", function(exports, require, module) {
var Google, ServiceProvider, utils, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

utils = require('lib/utils');

ServiceProvider = require('lib/services/service_provider');

module.exports = Google = (function(_super) {
  var apiKey, clientId, scopes;

  __extends(Google, _super);

  function Google() {
    this.processUserData = __bind(this.processUserData, this);
    this.getLoginStatus = __bind(this.getLoginStatus, this);
    this.loginHandler = __bind(this.loginHandler, this);
    this.triggerLogin = __bind(this.triggerLogin, this);
    this.loadHandler = __bind(this.loadHandler, this);
    _ref = Google.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  clientId = '365800635017';

  apiKey = '';

  scopes = 'https://www.googleapis.com/auth/plus.me';

  Google.prototype.name = 'google';

  Google.prototype.load = function() {
    if (this.state() === 'resolved' || this.loading) {
      return;
    }
    this.loading = true;
    window.googleClientLoaded = this.loadHandler;
    return utils.loadLib('https://apis.google.com/js/client.js?onload=googleClientLoaded', null, this.reject);
  };

  Google.prototype.loadHandler = function() {
    var error;
    gapi.client.setApiKey(this.apiKey);
    try {
      delete window.googleClientLoaded;
    } catch (_error) {
      error = _error;
      window.googleClientLoaded = void 0;
    }
    return gapi.auth.init(this.resolve);
  };

  Google.prototype.isLoaded = function() {
    return Boolean(window.gapi && gapi.auth && gapi.auth.authorize);
  };

  Google.prototype.triggerLogin = function() {
    return gapi.auth.authorize({
      client_id: clientId,
      scope: scopes,
      immediate: false
    }, this.loginHandler);
  };

  Google.prototype.loginHandler = function(authResponse) {
    if (authResponse) {
      this.publishEvent('loginSuccessful', {
        provider: this,
        authResponse: authResponse
      });
      this.publishEvent('serviceProviderSession', {
        provider: this,
        accessToken: authResponse.access_token
      });
      return this.getUserData(this.processUserData);
    } else {
      return this.publishEvent('loginFail', {
        provider: this,
        authResponse: authResponse
      });
    }
  };

  Google.prototype.getLoginStatus = function() {
    return gapi.auth.authorize({
      client_id: clientId,
      scope: scopes,
      immediate: true
    }, this.loginHandler);
  };

  Google.prototype.getUserData = function(callback) {
    return gapi.client.load('plus', 'v1', function() {
      var request;
      request = gapi.client.plus.people.get({
        'userId': 'me'
      });
      return request.execute(callback);
    });
  };

  Google.prototype.processUserData = function(response) {
    return this.publishEvent('userData', {
      imageUrl: response.image.url,
      name: response.displayName,
      id: response.id
    });
  };

  Google.prototype.parsePlusOneButton = function(el) {
    if (window.gapi && gapi.plusone && gapi.plusone.go) {
      return gapi.plusone.go(el);
    } else {
      window.___gcfg = {
        parsetags: 'explicit'
      };
      return utils.loadLib('https://apis.google.com/js/plusone.js', function() {
        var error;
        try {
          delete window.___gcfg;
        } catch (_error) {
          error = _error;
          window.___gcfg = void 0;
        }
        return gapi.plusone.go(el);
      });
    }
  };

  return Google;

})(ServiceProvider);
});

;require.register("lib/services/service_provider", function(exports, require, module) {
var ServiceProvider, utils;

utils = require('lib/utils');

module.exports = ServiceProvider = (function() {
  _(ServiceProvider.prototype).extend(Chaplin.EventBroker);

  ServiceProvider.prototype.loading = false;

  function ServiceProvider() {
    _(this).extend($.Deferred());
    utils.deferMethods({
      deferred: this,
      methods: ['triggerLogin', 'getLoginStatus'],
      onDeferral: this.load
    });
  }

  ServiceProvider.prototype.disposed = false;

  ServiceProvider.prototype.dispose = function() {
    if (this.disposed) {
      return;
    }
    this.unsubscribeAllEvents();
    this.disposed = true;
    return typeof Object.freeze === "function" ? Object.freeze(this) : void 0;
  };

  return ServiceProvider;

})();

/*

  Standard methods and their signatures:

  load: ->
    # Load a script like this:
    utils.loadLib 'http://example.org/foo.js', @loadHandler, @reject

  loadHandler: =>
    # Init the library, then resolve
    ServiceProviderLibrary.init(foo: 'bar')
    @resolve()

  isLoaded: ->
    # Return a Boolean
    Boolean window.ServiceProviderLibrary and ServiceProviderLibrary.login

  # Trigger login popup
  triggerLogin: (loginContext) ->
    callback = _(@loginHandler).bind(this, loginContext)
    ServiceProviderLibrary.login callback

  # Callback for the login popup
  loginHandler: (loginContext, response) =>

    eventPayload = {provider: this, loginContext}
    if response
      # Publish successful login
      @publishEvent 'loginSuccessful', eventPayload

      # Publish the session
      @publishEvent 'serviceProviderSession',
        provider: this
        userId: response.userId
        accessToken: response.accessToken
        # etc.

    else
      @publishEvent 'loginFail', eventPayload

  getLoginStatus: (callback = @loginStatusHandler, force = false) ->
    ServiceProviderLibrary.getLoginStatus callback, force

  loginStatusHandler: (response) =>
    return unless response
    @publishEvent 'serviceProviderSession',
      provider: this
      userId: response.userId
      accessToken: response.accessToken
      # etc.
*/

});

;require.register("lib/services/twitter", function(exports, require, module) {
var ServiceProvider, Twitter, utils,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

utils = require('lib/utils');

ServiceProvider = require('lib/services/service_provider');

module.exports = Twitter = (function(_super) {
  var consumerKey;

  __extends(Twitter, _super);

  consumerKey = 'w0uohox91TgpKETJmscYIQ';

  Twitter.prototype.name = 'twitter';

  function Twitter() {
    this.loginStatusHandler = __bind(this.loginStatusHandler, this);
    this.loginHandler = __bind(this.loginHandler, this);
    this.sdkLoadHandler = __bind(this.sdkLoadHandler, this);
    Twitter.__super__.constructor.apply(this, arguments);
    this.subscribeEvent('!logout', this.logout);
  }

  Twitter.prototype.loadSDK = function() {
    if (this.state() === 'resolved' || this.loading) {
      return;
    }
    this.loading = true;
    return utils.loadLib("http://platform.twitter.com/anywhere.js?id=" + consumerKey + "&v=1", this.sdkLoadHandler, this.reject);
  };

  Twitter.prototype.sdkLoadHandler = function() {
    var _this = this;
    this.loading = false;
    return twttr.anywhere(function(T) {
      _this.publishEvent('sdkLoaded');
      _this.T = T;
      return _this.resolve();
    });
  };

  Twitter.prototype.isLoaded = function() {
    return Boolean(window.twttr);
  };

  Twitter.prototype.publish = function(event, callback) {
    return this.T.trigger(event, callback);
  };

  Twitter.prototype.subscribe = function(event, callback) {
    return this.T.bind(event, callback);
  };

  Twitter.prototype.unsubscribe = function(event) {
    return this.T.unbind(event);
  };

  Twitter.prototype.triggerLogin = function(loginContext) {
    var callback;
    callback = _(this.loginHandler).bind(this, loginContext);
    this.T.signIn();
    this.subscribe('authComplete', function(event, currentUser, accessToken) {
      return callback({
        currentUser: currentUser,
        accessToken: accessToken
      });
    });
    return this.subscribe('signOut', function() {
      return callback();
    });
  };

  Twitter.prototype.publishSession = function(response) {
    var user;
    user = response.currentUser;
    this.publishEvent('serviceProviderSession', {
      provider: this,
      userId: user.id,
      accessToken: response.accessToken || twttr.anywhere.token
    });
    return this.publishEvent('userData', user.attributes);
  };

  Twitter.prototype.loginHandler = function(loginContext, response) {
    if (response) {
      this.publishEvent('loginSuccessful', {
        provider: this,
        loginContext: loginContext
      });
      return this.publishSession(response);
    } else {
      return this.publishEvent('loginFail', {
        provider: this,
        loginContext: loginContext
      });
    }
  };

  Twitter.prototype.getLoginStatus = function(callback, force) {
    if (callback == null) {
      callback = this.loginStatusHandler;
    }
    if (force == null) {
      force = false;
    }
    return callback(this.T);
  };

  Twitter.prototype.loginStatusHandler = function(response) {
    if (response.currentUser) {
      return this.publishSession(response);
    } else {
      return this.publishEvent('logout');
    }
  };

  Twitter.prototype.logout = function() {
    var _ref;
    return typeof twttr !== "undefined" && twttr !== null ? (_ref = twttr.anywhere) != null ? typeof _ref.signOut === "function" ? _ref.signOut() : void 0 : void 0 : void 0;
  };

  return Twitter;

})(ServiceProvider);
});

;require.register("lib/support", function(exports, require, module) {
var support, utils;

utils = require('lib/utils');

' use strict';

support = utils.beget(Chaplin.support);

module.exports = support;
});

;require.register("lib/utils", function(exports, require, module) {
' use strict';
var mediator, utils,
  __hasProp = {}.hasOwnProperty,
  __slice = [].slice;

mediator = Chaplin.mediator;

utils = Chaplin.utils.beget(Chaplin.utils);

_(utils).extend({
  camelize: (function() {
    var camelizer, regexp;
    regexp = /[-_]([a-z])/g;
    camelizer = function(match, c) {
      return c.toUpperCase();
    };
    return function(string) {
      return string.replace(regexp, camelizer);
    };
  })(),
  dasherize: function(string) {
    return string.replace(/[A-Z]/g, function(char, index) {
      return (index !== 0 ? '-' : '') + char.toLowerCase();
    });
  },
  sessionStorage: (function() {
    if (window.sessionStorage && sessionStorage.getItem && sessionStorage.setItem && sessionStorage.removeItem) {
      return function(key, value) {
        if (typeof value === 'undefined') {
          value = sessionStorage.getItem(key);
          if ((value != null) && value.toString) {
            return value.toString();
          } else {
            return value;
          }
        } else {
          sessionStorage.setItem(key, value);
          return value;
        }
      };
    } else {
      return function(key, value) {
        if (typeof value === 'undefined') {
          return utils.getCookie(key);
        } else {
          utils.setCookie(key, value);
          return value;
        }
      };
    }
  })(),
  sessionStorageRemove: (function() {
    if (window.sessionStorage && sessionStorage.getItem && sessionStorage.setItem && sessionStorage.removeItem) {
      return function(key) {
        return sessionStorage.removeItem(key);
      };
    } else {
      return function(key) {
        return utils.expireCookie(key);
      };
    }
  })(),
  getCookie: function(key) {
    var pair, pairs, val, _i, _len;
    pairs = document.cookie.split('; ');
    for (_i = 0, _len = pairs.length; _i < _len; _i++) {
      pair = pairs[_i];
      val = pair.split('=');
      if (decodeURIComponent(val[0]) === key) {
        return decodeURIComponent(val[1] || '');
      }
    }
    return null;
  },
  setCookie: function(key, value, options) {
    var expires, getOption, payload;
    if (options == null) {
      options = {};
    }
    payload = "" + (encodeURIComponent(key)) + "=" + (encodeURIComponent(value));
    getOption = function(name) {
      if (options[name]) {
        return "; " + name + "=" + options[name];
      } else {
        return '';
      }
    };
    expires = options.expires ? "; expires=" + (options.expires.toUTCString()) : '';
    return document.cookie = [payload, expires, getOption('path'), getOption('domain'), getOption('secure')].join('');
  },
  expireCookie: function(key) {
    return document.cookie = "" + key + "=nil; expires=" + ((new Date).toGMTString());
  },
  loadLib: function(url, success, error, timeout) {
    var head, onload, script, timeoutHandle;
    if (timeout == null) {
      timeout = 7500;
    }
    head = document.head || document.getElementsByTagName('head')[0] || document.documentElement;
    script = document.createElement('script');
    script.async = 'async';
    script.src = url;
    onload = function(_, aborted) {
      if (aborted == null) {
        aborted = false;
      }
      if (!(aborted || !script.readyState || script.readyState === 'complete')) {
        return;
      }
      clearTimeout(timeoutHandle);
      script.onload = script.onreadystatechange = script.onerror = null;
      if (head && script.parentNode) {
        head.removeChild(script);
      }
      script = void 0;
      if (success && !aborted) {
        return success();
      }
    };
    script.onload = script.onreadystatechange = onload;
    script.onerror = function() {
      onload(null, true);
      if (error) {
        return error();
      }
    };
    timeoutHandle = setTimeout(script.onerror, timeout);
    return head.insertBefore(script, head.firstChild);
  },
  deferMethods: function(options) {
    var deferred, func, host, methods, methodsHash, name, onDeferral, target, _i, _len, _results;
    deferred = options.deferred;
    methods = options.methods;
    host = options.host || deferred;
    target = options.target || host;
    onDeferral = options.onDeferral;
    methodsHash = {};
    if (typeof methods === 'string') {
      methodsHash[methods] = host[methods];
    } else if (methods.length && methods[0]) {
      for (_i = 0, _len = methods.length; _i < _len; _i++) {
        name = methods[_i];
        func = host[name];
        if (typeof func !== 'function') {
          throw new TypeError("utils.deferMethods: method " + name + " notfound on host " + host);
        }
        methodsHash[name] = func;
      }
    } else {
      methodsHash = methods;
    }
    _results = [];
    for (name in methodsHash) {
      if (!__hasProp.call(methodsHash, name)) continue;
      func = methodsHash[name];
      if (typeof func !== 'function') {
        continue;
      }
      _results.push(target[name] = utils.createDeferredFunction(deferred, func, target, onDeferral));
    }
    return _results;
  },
  createDeferredFunction: function(deferred, func, context, onDeferral) {
    if (context == null) {
      context = deferred;
    }
    return function() {
      var args;
      args = arguments;
      if (deferred.state() === 'resolved') {
        return func.apply(context, args);
      } else {
        deferred.done(function() {
          return func.apply(context, args);
        });
        if (typeof onDeferral === 'function') {
          return onDeferral.apply(context);
        }
      }
    };
  },
  accumulator: {
    collectedData: {},
    handles: {},
    handlers: {},
    successHandlers: {},
    errorHandlers: {},
    interval: 2000
  },
  wrapAccumulators: function(obj, methods) {
    var func, name, _i, _len,
      _this = this;
    for (_i = 0, _len = methods.length; _i < _len; _i++) {
      name = methods[_i];
      func = obj[name];
      if (typeof func !== 'function') {
        throw new TypeError("utils.wrapAccumulators: method " + name + " not found");
      }
      obj[name] = utils.createAccumulator(name, obj[name], obj);
    }
    return $(window).unload(function() {
      var handler, _ref, _results;
      _ref = utils.accumulator.handlers;
      _results = [];
      for (name in _ref) {
        handler = _ref[name];
        _results.push(handler({
          async: false
        }));
      }
      return _results;
    });
  },
  createAccumulator: function(name, func, context) {
    var acc, accumulatedError, accumulatedSuccess, cleanup, id;
    if (!(id = func.__uniqueID)) {
      id = func.__uniqueID = name + String(Math.random()).replace('.', '');
    }
    acc = utils.accumulator;
    cleanup = function() {
      delete acc.collectedData[id];
      delete acc.successHandlers[id];
      return delete acc.errorHandlers[id];
    };
    accumulatedSuccess = function() {
      var handler, handlers, _i, _len;
      handlers = acc.successHandlers[id];
      if (handlers) {
        for (_i = 0, _len = handlers.length; _i < _len; _i++) {
          handler = handlers[_i];
          handler.apply(this, arguments);
        }
      }
      return cleanup();
    };
    accumulatedError = function() {
      var handler, handlers, _i, _len;
      handlers = acc.errorHandlers[id];
      if (handlers) {
        for (_i = 0, _len = handlers.length; _i < _len; _i++) {
          handler = handlers[_i];
          handler.apply(this, arguments);
        }
      }
      return cleanup();
    };
    return function() {
      var data, error, handler, rest, success;
      data = arguments[0], success = arguments[1], error = arguments[2], rest = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
      if (data) {
        acc.collectedData[id] = (acc.collectedData[id] || []).concat(data);
      }
      if (success) {
        acc.successHandlers[id] = (acc.successHandlers[id] || []).concat(success);
      }
      if (error) {
        acc.errorHandlers[id] = (acc.errorHandlers[id] || []).concat(error);
      }
      if (acc.handles[id]) {
        return;
      }
      handler = function(options) {
        var args, collectedData;
        if (options == null) {
          options = options;
        }
        if (!(collectedData = acc.collectedData[id])) {
          return;
        }
        args = [collectedData, accumulatedSuccess, accumulatedError].concat(rest);
        func.apply(context, args);
        clearTimeout(acc.handles[id]);
        delete acc.handles[id];
        return delete acc.handlers[id];
      };
      acc.handlers[id] = handler;
      return acc.handles[id] = setTimeout((function() {
        return handler();
      }), acc.interval);
    };
  },
  afterLogin: function() {
    var args, context, eventType, func, loginHandler;
    context = arguments[0], func = arguments[1], eventType = arguments[2], args = 4 <= arguments.length ? __slice.call(arguments, 3) : [];
    if (eventType == null) {
      eventType = 'login';
    }
    if (mediator.user) {
      return func.apply(context, args);
    } else {
      loginHandler = function() {
        mediator.unsubscribe(eventType, loginHandler);
        return func.apply(context, args);
      };
      return mediator.subscribe(eventType, loginHandler);
    }
  },
  deferMethodsUntilLogin: function(obj, methods, eventType) {
    var func, name, _i, _len, _results;
    if (eventType == null) {
      eventType = 'login';
    }
    if (typeof methods === 'string') {
      methods = [methods];
    }
    _results = [];
    for (_i = 0, _len = methods.length; _i < _len; _i++) {
      name = methods[_i];
      func = obj[name];
      if (typeof func !== 'function') {
        throw new TypeError("utils.deferMethodsUntilLogin: method " + name + "not found");
      }
      _results.push(obj[name] = _(utils.afterLogin).bind(null, obj, func, eventType));
    }
    return _results;
  },
  ensureLogin: function() {
    var args, context, e, eventType, func, loginContext;
    context = arguments[0], func = arguments[1], loginContext = arguments[2], eventType = arguments[3], args = 5 <= arguments.length ? __slice.call(arguments, 4) : [];
    if (eventType == null) {
      eventType = 'login';
    }
    utils.afterLogin.apply(utils, [context, func, eventType].concat(__slice.call(args)));
    if (!mediator.user) {
      if ((e = args[0]) && typeof e.preventDefault === 'function') {
        e.preventDefault();
      }
      return mediator.publish('!showLogin', loginContext);
    }
  },
  ensureLoginForMethods: function(obj, methods, loginContext, eventType) {
    var func, name, _i, _len, _results;
    if (eventType == null) {
      eventType = 'login';
    }
    if (typeof methods === 'string') {
      methods = [methods];
    }
    _results = [];
    for (_i = 0, _len = methods.length; _i < _len; _i++) {
      name = methods[_i];
      func = obj[name];
      if (typeof func !== 'function') {
        throw new TypeError("utils.ensureLoginForMethods: method " + name + "not found");
      }
      _results.push(obj[name] = _(utils.ensureLogin).bind(null, obj, func, loginContext, eventType));
    }
    return _results;
  },
  facebookImageURL: function(fbId, type) {
    var accessToken, params;
    if (type == null) {
      type = 'square';
    }
    params = {
      type: type
    };
    if (mediator.user) {
      accessToken = mediator.user.get('accessToken');
      if (accessToken) {
        params.access_token = accessToken;
      }
    }
    return "https://graph.facebook.com/" + fbId + "/picture?" + ($.param(params));
  }
});

module.exports = utils;
});

;require.register("lib/view_helper", function(exports, require, module) {
var Handlebars, mediator, utils;

Handlebars = window.Handlebars;

utils = require('lib/utils');

'use strict';

mediator = Chaplin.mediator;

Handlebars.registerHelper('if_logged_in', function(options) {
  if (mediator.user) {
    return options.fn(this);
  } else {
    return options.inverse(this);
  }
});

Handlebars.registerHelper('with', function(context, options) {
  if (!context || Handlebars.Utils.isEmpty(context)) {
    return options.inverse(this);
  } else {
    return options.fn(context);
  }
});

Handlebars.registerHelper('without', function(context, options) {
  var inverse;
  inverse = options.inverse;
  options.inverse = options.fn;
  options.fn = inverse;
  return Handlebars.helpers["with"].call(this, context, options);
});

Handlebars.registerHelper('with_user', function(options) {
  var context;
  context = mediator.user || {};
  return Handlebars.helpers["with"].call(this, context, options);
});

Handlebars.registerHelper('fb_img_url', function(fbId, type) {
  return new Handlebars.SafeString(utils.facebookImageURL(fbId, type));
});

module.exports = null;
});

;require.register("main", function(exports, require, module) {

'use strict';

app = new Application();
app.initialize();

});

require.register("models/base/collection", function(exports, require, module) {
var Collection, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = Collection = (function(_super) {
  __extends(Collection, _super);

  function Collection() {
    _ref = Collection.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  return Collection;

})(Chaplin.Collection);
});

;require.register("models/base/model", function(exports, require, module) {
var Model, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

module.exports = Model = (function(_super) {
  __extends(Model, _super);

  function Model() {
    _ref = Model.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  return Model;

})(Chaplin.Model);
});

;require.register("models/navigation", function(exports, require, module) {
var Model, Navigation, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require('models/base/model');

'use strict';

module.exports = Navigation = (function(_super) {
  __extends(Navigation, _super);

  function Navigation() {
    _ref = Navigation.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Navigation.prototype.defaults = {
    items: [
      {
        href: '/',
        title: 'Likes Browser'
      }, {
        href: '/posts',
        title: 'Wall Posts'
      }
    ]
  };

  return Navigation;

})(Model);
});

;require.register("models/stories", function(exports, require, module) {
var Collection, Stories, Story, allStories, _ref,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Collection = require('models/base/collection', Story = require('models/story'));

allStories = require('all-posts');

'use strict';

module.exports = Stories = (function(_super) {
  __extends(Stories, _super);

  function Stories() {
    this.fetch = __bind(this.fetch, this);
    _ref = Stories.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Stories.prototype.model = Story;

  Stories.prototype.initialize = function() {
    Stories.__super__.initialize.apply(this, arguments);
    return this.fetch();
  };

  Stories.prototype.fetch = function() {
    console.debug('stories#fetch');
    return this.push(allStories);
  };

  return Stories;

})(Collection);
});

;require.register("models/story", function(exports, require, module) {
var Model, Story, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require('models/base/model');

'use strict';

module.exports = Story = (function(_super) {
  __extends(Story, _super);

  function Story() {
    _ref = Story.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Story.prototype.initialize = function() {
    Story.__super__.initialize.apply(this, arguments);
    return console.debug('Story#initialize');
  };

  return Story;

})(Model);
});

;require.register("models/user", function(exports, require, module) {
var Model, User, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Model = require('models/base/model');

'use strict';

module.exports = User = (function(_super) {
  __extends(User, _super);

  function User() {
    _ref = User.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  return User;

})(Model);
});

;require.register("routes", function(exports, require, module) {
'use strict';
var routes;

routes = function(match) {
  match('', 'home#show');
  return match('showit', 'sidebar#showit');
};

module.exports = routes;

return routes;
});

;require.register("views/base/collection_view", function(exports, require, module) {
var CollectionView, View, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('views/base/view');

'use strict';

module.exports = CollectionView = (function(_super) {
  __extends(CollectionView, _super);

  function CollectionView() {
    _ref = CollectionView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  CollectionView.prototype.getTemplateFunction = View.prototype.getTemplateFunction;

  return CollectionView;

})(Chaplin.CollectionView);
});

;require.register("views/base/view", function(exports, require, module) {
var Handlebars, View, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Handlebars = window.Handlebars;

require('lib/view_helper');

'use strict';

module.exports = View = (function(_super) {
  __extends(View, _super);

  function View() {
    _ref = View.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  View.prototype.getTemplateFunction = function() {
    var template, templateFunc;
    template = this.template;
    if (typeof template === 'string') {
      templateFunc = Handlebars.compile(template);
      this.constructor.prototype.template = templateFunc;
    } else {
      templateFunc = template;
    }
    return templateFunc;
  };

  return View;

})(Chaplin.View);
});

;require.register("views/sidebar-story-view", function(exports, require, module) {
var SidebarStoryView, T, Teacup, View,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

View = require('views/base/view');

Teacup = require('teacup').Teacup;

T = new Teacup;

module.exports = SidebarStoryView = (function(_super) {
  __extends(SidebarStoryView, _super);

  SidebarStoryView.prototype.autoRender = true;

  SidebarStoryView.prototype.autoAttach = true;

  function SidebarStoryView(collection) {
    this.collection = collection;
    this.getTemplateData = __bind(this.getTemplateData, this);
    SidebarStoryView.__super__.constructor.apply(this, arguments);
  }

  SidebarStoryView.prototype.el = "#sidebar";

  SidebarStoryView.prototype.getTemplateData = function() {
    return this.collection;
  };

  SidebarStoryView.prototype.getTemplateFunction = function(info) {
    var _this = this;
    console.log('sidebar-story-view#render');
    return T.renderable(function() {
      T.ul('#storyList', function() {
        debugger;
        return _this.collection.each(function(story) {
          return T.li(function() {
            return T.a({
              href: story.get('id')
            }, story.get('title'));
          });
        });
      });
      return T.text("wow from Teacup");
    });
  };

  return SidebarStoryView;

})(View);
});

;
//# sourceMappingURL=app.js.map