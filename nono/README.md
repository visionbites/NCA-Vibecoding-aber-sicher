# nono: Profil `nca-demo`

`nca-demo.json` baut auf dem offiziellen Claude-Profil `nolabs-ai/claude` auf und ergänzt zwei Dinge, die das Profil ab Werk nicht tut:

| Ergänzung | Warum |
|---|---|
| Netzwerk-Allowlist (`network_profile: claude-code`) | Ohne sie darf der Agent jede Adresse erreichen. Mit ihr nur Ziele wie die Claude-API, Paket-Registries und GitHub. Bei uns war `railway.com` danach geblockt, vorher erreichbar |
| Gesperrte Docker-Sockets (OrbStack, Colima, Rancher Desktop, `/var/run/docker.sock`) | Ein erreichbarer Docker-Socket heißt praktisch Root auf deinem Rechner. nono sperrt ab Werk nur den von Docker Desktop. Bei uns lief `docker ps` über OrbStack in der Sandbox, mit `nca-demo` nicht mehr |

`~/.ssh` sperrt nono schon von sich aus, das muss niemand konfigurieren.

## Starten

```bash
nono run --profile nca-demo --allow . -- claude
```

Mit `--dangerously-skip-permissions` am Ende fragt Claude Code gar nicht mehr nach. Das ist der Sinn einer echten Grenze, aber erst, wenn du ihr vertraust.

Blockiert nono eine Adresse, die du brauchst, nennt es im Terminal den passenden Aufruf, etwa `--allow-domain example.com`. Die Entscheidung liegt bei dir, nicht beim Agenten.

## Was das Profil nicht löst

- **Keychain (macOS):** Das Claude-Profil gibt die Keychain frei, damit das Abo-Login funktioniert. Das lässt sich mit `extends` nicht zurücknehmen. Bei uns war ein per `security`-Befehl angelegter Testeintrag aus der Sandbox ohne Rückfrage lesbar. Ob ein Eintrag betroffen ist, siehst du in der Schlüsselbundverwaltung im Reiter „Zugriff“: Steht dort `security`, ist er lesbar.
- **Claudes eigene Konfiguration:** Das Profil darf `~/.claude` beschreiben. Ein Eintrag, den der Agent dort hinterlässt, wirkt auch beim nächsten Start ohne nono. Deshalb immer in der Sandbox starten.
- **Linux und WSL2:** dort verhält sich nono anders (Details in der nono-Doku). Wir haben nur macOS getestet.

## Mehr

- nono mit Claude Code: https://github.com/nolabs-ai/nono/blob/main/docs/cli/clients/claude.mdx
- Eigene Profile schreiben: https://github.com/nolabs-ai/nono/blob/main/crates/nono-cli/data/profile-authoring-guide.md
