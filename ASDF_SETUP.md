# asdf setup for Embold projects

## Prerequisites
- Install [asdf](https://asdf-vm.com/guide/getting-started.html) (supports macOS, Linux, WSL, Windows via WSL)
   ```sh
   brew install asdf
   ```

## Ruby setup
1. Install the Ruby plugin:
   ```sh
   asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
   ```
2. Install the required Ruby version (from `.tool-versions` or specify):
   ```sh
   asdf install ruby 3.4.4
   asdf global ruby 3.4.4
   ```

<!-- ## Node.js, PHP, etc.
- Add plugins as needed:
  ```sh
  asdf plugin add nodejs
  asdf plugin add php
  ``` -->

## Project setup
- Create a `.tool-versions` file in your repo root:
  ```
  ruby 3.4.4
  ```
  <!-- ```
  ruby 3.2.2
  nodejs 20.11.1
  php 8.2.12
  ``` -->
- asdf will auto-switch versions per project.


## Make sure Ruby and gem are available
- If `ruby` or `gem` are not recognized, add asdf to your shell profile:
  ```sh
  # Add to ~/.bashrc, ~/.zshrc, or ~/.profile (for WSL/Linux/macOS)
  . "$HOME/.asdf/asdf.sh"
  . "$HOME/.asdf/completions/asdf.bash"
  ```
- Restart your terminal or run the above lines in your current session.
- Then verify with:
  ```sh
  which ruby
  which gem
  ```

## Bundler
- After installing Ruby, run:
  ```sh
  gem install bundler
  bundle install
  ```

---

For more, see https://asdf-vm.com/guide/getting-started.html
