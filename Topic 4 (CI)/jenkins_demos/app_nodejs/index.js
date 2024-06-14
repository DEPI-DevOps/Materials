const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.sendFile('public/index.html', {root: __dirname})
})

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
  })
}

module.exports = app;
