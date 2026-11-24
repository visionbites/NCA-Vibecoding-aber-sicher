# Docker Sandboxes (sbx)

sbx startet Claude Code in einer microVM mit eigenem Kernel und eigenem Docker. Bei nono nimmt man dem Agenten Rechte weg, bei sbx gibt man ihm einen anderen Rechner. Läuft laut Docker auf macOS mit Apple Silicon und Windows 11, braucht einen Docker-Account.

## Netzwerk-Policy

Beim ersten Start fragt sbx nach einer Policy für alle Sandboxes. Wurde schon eine gesetzt, ändert man sie so:

```bash
sbx policy reset                         # stoppt laufende Sandboxes
sbx policy init balanced                 # oder deny-all
sbx policy check network railway.com     # vorher prüfen statt raten
sbx policy log                           # was wurde geblockt?
```

## Login

- **Claude-Abo:** in Claude Code `/login`. Bei uns lag danach in der VM nur ein Platzhalter, das echte Token setzt sbx erst beim Senden ein. Der Agent kann es also nicht mitnehmen.
- **API-Key:** vorher `sbx secret set anthropic`, gleiches Prinzip.

## Clone-Modus

Mit `--clone` arbeitet der Agent auf einer eigenen Kopie deines Repos in der VM. Bei uns blieb das Repo auf dem Rechner unverändert, selbst als der Agent in der VM alles gelöscht hat. Dateien holst du mit `sbx cp` heraus:

```bash
sbx cp <name>:<voller-pfad-in-der-vm> ./
```

Der Projektpfad ist in der VM derselbe wie auf deinem Rechner. Den Namen der Sandbox zeigt `sbx ls`.

## DDEV

DDEV läuft in der VM, inklusive Datenbank. Es ist nicht vorinstalliert, lässt sich aber mit dem offiziellen Installationsskript nachinstallieren und bleibt danach in dieser Sandbox erhalten: https://docs.ddev.com/en/stable/users/install/ddev-installation/

## Mehr

- Claude Code in sbx: https://docs.docker.com/ai/sandboxes/agents/claude-code
- Netzwerk-Policy: https://docs.docker.com/ai/sandboxes/governance/access-controls/local/
