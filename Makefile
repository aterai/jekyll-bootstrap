server:
	@@jekyll server

render:
	@@echo "Building the site..."
	@@jekyll build

minify:
	@@echo "Minifying the CSS..."
	@@java -jar _build/yuicompressor-2.4.7.jar --verbose --type css "_site/assets/themes/twitter/css/*.css"
	@@echo "Minifying the HTML..."
	@@java -jar _build/htmlcompressor-1.5.3.jar --recursive --type html -o _site/ _site/

build: render minify

deploy: build
	@@echo 'Deploying site.'
	@@rsync -avq --delete-after _site/ sshAlias:/path/to/site/html

.PHONY: server render build minify deploy
