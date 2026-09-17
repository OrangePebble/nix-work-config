If a shell command is unavailable, run it with Nix comma (`, <command>`); do not install it.

Put temporary files in `/tmp`.

## Web fetching

- For GitHub repository pages, extract the README with `selector: "article.markdown-body"`.
- Prefer a raw GitHub README URL when known: `https://raw.githubusercontent.com/<owner>/<repo>/<branch>/README.md`.
- Do not apply GitHub selectors to non-GitHub pages.
