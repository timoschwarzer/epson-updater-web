import express from 'express'
import multer from 'multer'
import {spawn} from 'child_process'
import {dirname} from 'path'
import {fileURLToPath} from 'url'

const __dirname = dirname(fileURLToPath(import.meta.url))

const app = express()
const port = 3000

const upload = multer({
  dest: '/tmp',
  fileSize: 500 * 1024 * 1024, // 500 MB
})

app.use(express.static(__dirname + '/' + 'public'))

app.post('/update', upload.single('file'), (req, res) => {
  try {
    res.set('Content-Type', 'text/plain')

    console.log(`Updating ${req.body.printer_ip}`)
    console.log('File:', req.file)

    const script = spawn('/app/scripts/epson-update.sh', [req.body.printer_ip, req.file.path])
    script.stdout.on('data', data => {
      res.write(data.toString())
      console.log(data.toString())
    })
    script.stderr.on('data', data => {
      res.write(data.toString())
      console.log(data.toString())
    })

    script.on('close', (code) => {
      res.write(`process exited with code ${code}`)
      console.log(`process exited with code ${code}`)
      res.end()
    })
  } catch (e) {
    res.write(e.message)
    console.error(e)
    res.end()
  }
})

app.listen(port, () => console.log(`Listening on port ${port}!`))
