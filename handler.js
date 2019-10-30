const nunjucks = require('nunjucks')
const fs = require('fs')
const glob = require('glob')

nunjucks.configure([
  'node_modules/govuk-frontend/',
  'templates/'
], {
  autoescape: true
})

const actions = {
  generateListing () {
    const bodies = glob.sync('./resources/bodies/*')
    return fs.writeFileSync('./index.html', nunjucks.render('index.html', {
      bodies: bodies.map(function (row) {
        return row.replace('./resources/bodies/', '')
      })
    }))
  },
  generateSingular () {
    const bodies = glob.sync('./resources/bodies/*').map(function (row) {
      return row.replace('./resources/bodies/', '')
    })

    for (const body in bodies) {
      const resource = nunjucks.render('resource.html', {
        resource: bodies[body]
      })

      fs.mkdirSync('./' + bodies[body], { recursive: true })
      fs.writeFileSync('./' + bodies[body] + '/index.html', resource)
    }
  }
}

actions.generateListing()
actions.generateSingular()
