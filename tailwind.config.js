// tailwind.config.js
module.exports = {
  content: [
    "./app/views/**/*.html.erb",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js",
  ],
  theme: {
    extend: {
      fontFamily: {
        dot: ["'PixelMplus10'", "'Press Start 2P'", "monospace"]
      }
    }
  }
}