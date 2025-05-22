#!/usr/bin/env just --justfile

download-coreos-iso:
    @tools/download-coreos-iso.sh

build-coreos $service: download-coreos-iso
    @tools/customize-coreos-iso.sh $service

encrypt $data $pin_config="multiple":
    @tools/clevis-encrypt.sh $data $pin_config

decrypt $file:
    @tools/clevis-decrypt.sh $file

build-tang-backup:
    @(cd tang-backup && go build .)

### Adguard ###

adguard-encrypt: 
    @tools/clevis-decrypt.sh "$(cat adguard/AdGuardHome.yaml)" > adguard/AdGuardHome.yaml.jwe

adguard-decrypt: 
    @tools/clevis-decrypt.sh adguard/AdGuardHome.yaml.jwe > adguard/AdGuardHome.yaml
