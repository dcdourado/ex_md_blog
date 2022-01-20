[![Actions Status](https://github.com/dcdourado/auth_blog/workflows/Elixir%20CI/badge.svg)](https://github.com/dcdourado/auth_blog/actions/workflows/elixir-ci.yml)

# AuthBlog

> The blog goal is to learn, write and practice about solid authorization and authentication methods and frameworks.

Firstly we will build the blog engine.
## The project

Using `:cowboy` we will expose a web server that renders posts (our main resource) written in markdown.

Roadmap to v1.0.0

- [x] Set up web server
- [x] Create Posts domain
- [x] Build a Markdown-to-HTML parser
- [x] Render blog HTML dynamically
- [ ] User management (linking to Posts)
- [ ] Sign up and sign in
- [ ] First real blog post about what we've done so far
- [ ] Deploy app
