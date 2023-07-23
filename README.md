<!-- A GitHub description of this script -->
# bws-env
A wrapper script for [bws](https://github.com/bitwarden/sdk), the Bitwarden Secrets Manager command-line utility, that injects secrets into a command.

## Uses
### Retrieve a secret from Bitwarden Secrets Manager
```bash
./bws-env.sh 'echo $SOME_VAR_FROM_BITWARDEN'
```

### Inject secrets into a container
`docker-compose.yml`:
```yaml
version: '3.3'
services:
  echo:
    image: alpine
    command: echo $SOME_VAR_FROM_BITWARDEN
```

```bash
./bws-env.sh 'docker-compose up -d'
```

## Thanks
This script was made with [Bashly](https://github.com/DannyBen/bashly).

## Disclaimer
This script is not affiliated with Bitwarden or 8bit Solutions LLC. It is not an official Bitwarden product. Use at your own risk.
