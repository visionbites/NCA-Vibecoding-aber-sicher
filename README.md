# Vibecoding, aber sicher

Zum Talk „Vibecoding, aber sicher: Regeln, die dein Agent nicht vergessen kann“ (Never Code Alone, 24.11.2026).

> Regeln im Prompt sind Wünsche. Grenzen gehören in die Infrastruktur, dorthin, wo der Agent sie nicht vergessen und nicht umgehen kann.

Folien: [vibecoding-aber-sicher.pdf](vibecoding-aber-sicher.pdf) · Kontakt: Philip Kuban, [kuban@visionbites.de](mailto:kuban@visionbites.de)

## Welches Werkzeug?

| Du willst … | Nimm |
|---|---|
| Schnell und lokal arbeiten, Secrets und Netz sollen zu sein | **nono**: nimmt dem Agenten per Kernel Rechte weg |
| Dem Agenten einen eigenen Rechner geben, er braucht Docker (z. B. für DDEV) | **Docker Sandboxes (sbx)**: microVM mit eigenem Kernel |

Egal welches: Netzwerk und Credentials gehören zur Grenze dazu, nicht nur das Dateisystem.

## nono in fünf Zeilen

```bash
brew install nono
nono pull nolabs-ai/claude
mkdir -p ~/.config/nono/profiles && cp nono/nca-demo.json ~/.config/nono/profiles/
cd /pfad/zu/deinem/projekt
nono run --profile nca-demo --allow . -- claude
```

Kurz prüfen, ob es greift:

```bash
nono why --path ~/.ssh --op read --profile nca-demo     # erwartet: DENIED
nono why --host railway.com --profile nca-demo          # erwartet: nicht erlaubt
```

Warum das Profil `nca-demo` und was es nicht löst: [`nono/README.md`](nono/README.md)

## sbx in sechs Zeilen

```bash
brew trust docker/tap
brew install docker/tap/sbx
sbx login
sbx policy init balanced
cd /pfad/zu/deinem/projekt      # Git-Repo mit mindestens einem Commit
sbx run --clone claude .        # danach in Claude: /login
```

Kurz prüfen: `sbx policy check network railway.com` sollte das Ziel ablehnen. Mehr zu Login, Clone-Modus und DDEV: [`sbx/README.md`](sbx/README.md)

## Drei Dinge, die du wissen solltest

1. **nono und die Keychain (macOS):** Das Claude-Profil öffnet die Keychain, weil Claude Code dort sein Abo-Login ablegt. Bei uns war ein Testeintrag aus der Sandbox ohne Rückfrage lesbar. In sbx bleibt das Login dagegen außerhalb der VM.
2. **Immer in der Sandbox starten.** Wer aus Gewohnheit nur `claude` tippt, ist draußen. Ein Alias hilft: `alias claude='nono run --profile nca-demo --allow . -- claude'`
3. **Review bleibt Pflicht.** Eine Sandbox schützt Rechner und Secrets, nicht vor falschem Code.

## Selbst ausprobieren

`demo/` ist ein Mini-Projekt, dessen `deploy.sh` den Key `~/.ssh/deploy_key` braucht. Kopiere es in einen eigenen Ordner, mach daraus ein Git-Repo und starte Claude darin in nono oder sbx:

> deploy.sh bricht ab. Führ es aus und finde die Ursache.

In nono verweigert der Kernel den Zugriff auf `~/.ssh`. In sbx gibt es `~/.ssh` gar nicht.

## Stand

Getestet am 21.11.2026 auf macOS mit Apple Silicon (nono 0.82.0, sbx 0.54.0, Claude Code 2.1.311). Linux und Windows haben wir nicht getestet. Beide Werkzeuge entwickeln sich schnell, im Zweifel gilt ihre aktuelle Doku:

- nono: https://nono.sh, https://github.com/nolabs-ai/nono
- Docker Sandboxes: https://docs.docker.com/ai/sandboxes/agents/claude-code

Lizenz: MIT, siehe [LICENSE](LICENSE).
