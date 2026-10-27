#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# Send OTBR discovery information to Home Assistant
# ==============================================================================
declare config
declare device="^null"

if bashio::config.has_value 'device'; then
    device=$(bashio::config 'device')
fi

config=$(bashio::var.json \
    host "$(bashio::addon.hostname)" \
    port "^8081" \
    device "${device}" \
    firmware "$(ot-ctl rcp version | head -n 1)" \
)

# Send discovery info
if bashio::discovery "otbr" "${config}" > /dev/null; then
    bashio::log.info "Successfully sent discovery information to Home Assistant."
else
    bashio::log.error "Discovery message to Home Assistant failed!"
fi
