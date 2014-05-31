var _             = require("lodash");
var path          = require("path");
var fs            = require("fs-extra");
var handlebars    = require("handlebars");
var Promise       = require("promise");
var markdown      = require("markdown").markdown;

var rootDir       = path.join(__dirname, "..");
var publicRootDir = path.join(rootDir, "public");
var templatesDir  = path.join(rootDir, "site", "templates");
var articlesDir   = path.join(rootDir, "site", "articles");


/*

	Helpers

*/

var getArticles = function(){
	return new Promise(function(resolve, reject){
		fs.readdir(articlesDir, function(err, articles){
			var all     = _.map(articles, getArticleData);
			var allDone = Promise.all(all);
			allDone.catch(reject);

			allDone.then(function(articles){
				// Sort by date.
				articles = _.sortBy(articles, function(articleData){
					return -1 * new Date(articleData.created).getTime();
				});
				return resolve(articles);
			});

		});
	});
};


var getArticleData = function(articleName){
	return new Promise(function(resolve, reject){

		var articleDir          = path.join(articlesDir, articleName);
		var articleMetadataFile = path.join(articleDir, "metadata.json");
		var articleAboutFile    = path.join(articleDir, "about.md");

		fs.readFile(articleMetadataFile, "utf8", function(err, metadata){
			if(err){
				return reject(err);
			}

			var metadata = JSON.parse(metadata);

			if(!metadata.titlePhoto){
				metadata.titlePhoto = metadata.photos[0];
			}

			metadata.mainPhoto = metadata.photos[0];
			metadata.url = articleName.toLowerCase();

			fs.readFile(articleAboutFile, "utf8", function(err, about){
				// About file does not exist.
				if(err){
					return resolve(metadata);
				}

				metadata.about = markdown.toHTML(about);
				return resolve(metadata);
			});

		});

	});
};


var compile = function(templateFile, templateData, outFile){
	return new Promise(function(resolve, reject){
		fs.readFile(templateFile, "utf8", function(err, template){
			if(err){
				return reject(err);
			}

			var template = handlebars.compile(template);
			var compiled = template(templateData);

			fs.ensureFile(outFile, function(err){
				fs.writeFile(outFile, compiled, "utf8", function(err){
					if(err){
						return reject(err);
					}

					console.log("compiled: ", outFile);
					resolve();
				});
			});
		});
	});
};


/*

	Main

*/

var compileIndex = function(){
	return new Promise(function(resolve, reject){
		getArticles().then(function(articles){
			var templateData = {
				articles: articles
			};

			var outFile = path.join(publicRootDir, "index.html");
			var templateFile = path.join(templatesDir, "index.html");

			var compiled = compile(templateFile, templateData, outFile);
			compiled.then(resolve);
			compiled.catch(reject);
		});
	});
};


compileArticle = function(articleName){
	return new Promise(function(resolve, reject){
		getArticleData(articleName).then(function(articleData){
			var templateFile = path.join(templatesDir, "article.html");
			var outFile      = path.join(publicRootDir, "about", articleName, "index.html");
			var compiled     = compile(templateFile, articleData, outFile);

			compiled.then(resolve);
			compiled.catch(reject);
		});
	});
};


var compileArticles = function(){
	return new Promise(function(resolve, reject){
		getArticles().then(function(articles){

			var compiledAll = _.map(articles, function(article){
				return compileArticle(article.url);
			});
			var allDone = Promise.all(compiledAll);

			allDone.then(resolve);
			allDone.catch(reject);
		});
	});
};


compileIndex().done();
compileArticles().done();
