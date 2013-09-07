
var Handlebars = require('handlebars');
var fs = require('fs-extra');
var path = require('path');
var md = require("node-markdown").Markdown;
var moment = require('moment');

var siteRoot = 'site';
var bakedRoot = 'baked';

var paths = {
	articles: path.join(siteRoot, 'articles'),
	static: path.join(siteRoot, 'static'),
	templates: path.join(siteRoot, 'templates'),
	about: path.join(bakedRoot, 'about')
};

var templates = {};
var projects = [];

var buildHome = function(){

	//up to 14 on homepage
	var newProjects = projects.splice(0, 12);

	//home
	var compiled = templates['index.html']({"projects":newProjects});
	var index = path.join(bakedRoot, "index.html");
	fs.outputFileSync(index, compiled, 'utf8');

	//more
	compiled = templates['more.html']({"projects":projects});
	index = path.join(bakedRoot, "more", "index.html");
	fs.outputFileSync(index, compiled, 'utf8');

}

var buildArticle = function(name){
	var dirname = path.join(paths.articles, name);
	console.log(dirname);
	var metadata = fs.readFileSync(path.join(dirname, 'metadata.json'), 'utf8');
	var metadata = JSON.parse(metadata);
	
	metadata.url = '/' + name;
	if(metadata.actions && metadata.actions.length > 0){
		metadata.mainUrl = metadata.actions[0].url;
	}else{
		metadata.mainUrl = "#";
	}

	if(!metadata.titlePhoto)
		metadata.titlePhoto = metadata.photos[0];

	if(!metadata.noAbout){

		var about = fs.readFileSync(path.join(dirname, 'about.md'), 'utf8');
		about = md(about);
		
		metadata.about = about;
		metadata.url = '/about/' + name;

		var compiled = templates['article.html'](metadata);

		var outputPath = path.join(paths.about, name, 'index.html');
		
		fs.outputFileSync(outputPath, compiled, 'utf8');
	}

	projects.push(metadata);
};

var buldAllArticles = function(){
	var articles = fs.readdirSync(paths.articles);
	articles = filterHiddenFiles(articles);
	for(var i in articles){
		buildArticle(articles[i]);
	}

	projects.sort(function(o1, o2){
		if(moment(o1.created).isBefore(moment(o2.created))){
			return 1;
		}
		return -1;
	});

	//console.log(projects);
	buildHome();
};

var filterHiddenFiles = function(arr){
	return arr.filter(function(el){
		return el[0] != '.';
	})
}

var loadTemplate = function(name){
	var filename = path.join(paths.templates, name);
	var data = fs.readFileSync(filename, 'utf8');
  	templates[name] = Handlebars.compile(data);
  	console.log('loaded template: ' + filename);
};

var loadTemplates = function(){
	var files = fs.readdirSync(paths.templates);
	files = filterHiddenFiles(files);
	for(var i in files){
		loadTemplate(files[i]);
	}
};

var cpStaticFiles = function(){
	var files = fs.readdirSync(paths.static);
	files = filterHiddenFiles(files);
	for(var i in files){
		var from = path.join(paths.static, files[i]);
		var to = path.join(bakedRoot, files[i]);
		fs.copy(from, to);
	}
}

var cleanDirs = function(){
	fs.removeSync(path.join(bakedRoot, 'more'));
	fs.removeSync(paths.about);
	fs.removeSync(path.join(bakedRoot, 'index.html'));

	fs.mkdirsSync(paths.about);
	fs.mkdirsSync(path.join(bakedRoot, 'more'));
	//cpStaticFiles();
}

cleanDirs();
loadTemplates(); //sync
buldAllArticles();
