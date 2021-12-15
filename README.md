# UniMRCP with Asterisk for MCRP environment
Dockerizing MCRP environment for estimating MCRP process with UniMRCP, Asterisk

Based on UniMRCP from Unispeech

## Versions
| Library               | Version | Remarks                                     |
|-----------------------|---------|---------------------------------------------|
| UniMRCP Dependencies  | 1.6.0   | APR 1.5.2, APRUtil 1.5.4, Sofia_SIP 1.12.11 |
| UniMRCP               | 1.8.0   |                                             |
| Asterisk-UniMRCP      | 1.7.0   |                                             |
| Asterisk              | 18.6.0  |                                             |

## Build docker image
```
git clone https://github.com/goodatlas/unimrcp-asterisk-env
cd unimrcp-asterisk-env
./build_docker.sh
```
