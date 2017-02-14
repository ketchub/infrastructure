#### Todo

- IPTables rules on all systems
- Ensure communication via TLS
- Ensure using NTP for time sync'ing

- https://github.com/hashicorp/consul/tree/953286b2137ed55bdcf236d2d20d379d61da5b44/terraform/digitalocean
- https://github.com/hashicorp/nomad/blob/master/demo/digitalocean/terraform/statsite/main.tf
bind= all

```
TF_VAR_digital_ocean_token=12345abcde make [command]
```
