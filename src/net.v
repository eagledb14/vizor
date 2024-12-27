module main

import veb

pub struct Context {
	veb.Context
}

pub struct App {
	pages &Pages
}

pub fn (app &App) index(mut ctx Context) veb.Result {
	content := app.pages.read_home()
	title := "Home"
	return ctx.html($tmpl("./templates/index.html"))
}

pub fn (app &App) links(mut ctx Context) veb.Result {
	content := app.pages.read_links()
	title := "Links"
	return ctx.html($tmpl("./templates/index.html"))
}

pub fn (app &App) posts(mut ctx Context) veb.Result {
	content := app.pages.posts()
	return ctx.html($tmpl("./templates/posts.html"))
}

@["/post/:name"]
pub fn (app &App) post(mut ctx Context, name string) veb.Result {
	content := app.pages.read_post(name)
	title := name
	return ctx.html($tmpl("./templates/index.html"))
}

@["/rss"]
pub fn (app &App) rss(mut ctx Context) veb.Result {
	return ctx.text(get_rss_feed(app.pages))
}

pub fn run() {
	mut app := &App{
		pages: new_pages()
	}

	veb.run[App, Context](mut app, 8080)
}


