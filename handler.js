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
    const headers = glob.sync('./resources/headers/*/*')

    const rendered = nunjucks.render('index.html', {
      tableRows: headers.map(row => {
        const file = JSON.parse(fs.readFileSync(row, 'utf8'))
        const status = file.body ? `<a href="https://digital-land.github.io/resource/${file.body}" class="govuk__link">View</a>` : 'No file collected'
        const organisation = `<a href="https://digital-land.github.io/organisation/${file.organisation.replace(':', '/')}">${file.organisation}</a>`

        return [{
          html: organisation
        }, {
          html: status
        }]
      })
    })

    return fs.writeFileSync('./index.html', rendered)
  },
  generateSingular () {
    const headers = glob.sync('./resources/headers/*/*')

    for (const header in headers) {
      const info = JSON.parse(fs.readFileSync(headers[header], 'utf8'))

      if (info.body) {
        const rendered = nunjucks.render('resource.html', {
          info,
          infoString: JSON.stringify(info),
          infoRows: Object.keys(info).map(row => [{
            text: row
          }, {
            text: info[row]
          }])
        })
        fs.mkdirSync(`./${info.body}`, { recursive: true })
        fs.writeFileSync(`./${info.body}/index.html`, rendered)
      }
    }
  }
}

actions.generateListing()
actions.generateSingular()
