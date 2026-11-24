# nca-demo-site

Kleine statische Seite.

## Deploy

```bash
./deploy.sh
```

Der Deploy überträgt `site/` per rsync über SSH auf Staging. Er braucht den Deploy-Key unter `~/.ssh/deploy_key`. Host, Benutzer, Pfad und Key lassen sich per `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_PATH` und `DEPLOY_KEY` überschreiben.
