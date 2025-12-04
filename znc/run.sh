#!/bin/sh

set -e

CONFIG_DIR="/config/znc"
CONFIG_FILE="${CONFIG_DIR}/znc.conf"
DATA_DIR="${CONFIG_DIR}/modules"

echo "Starting ZNC Add-on..."

# Create directories
mkdir -p "${CONFIG_DIR}"
mkdir -p "${DATA_DIR}"

# Fix permissions
chown -R znc:nogroup "${CONFIG_DIR}"
chmod -R 755 "${CONFIG_DIR}"

# Create default config if not exists
if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Creating default configuration..."
    
    # Run initial setup as znc user
    if su-exec znc znc --datadir "${CONFIG_DIR}" --makeconf --foreground; then
        echo "Initial setup completed"
    else
        # If interactive setup fails, create minimal config
        echo "Creating minimal configuration..."
        cat > "${CONFIG_FILE}" << 'EOF'
Version = 1.8.2
LoadModule = webadmin

<Listener irc>
    Port = 6667
    IPv4 = true
    IPv6 = true
    SSL = false
</Listener>

<Listener web>
    Port = 8888
    IPv4 = true
    IPv6 = true
    SSL = false
    AllowWeb = true
</Listener>

<User admin>
    Admin = true
    Nick = admin
    AltNick = admin_
    Ident = admin
    RealName = ZNC Admin
    Buffer = 50
    
    <Pass password>
        Method = sha256
        Hash = f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2
        Salt = _/QsfSGR
    </Pass>
</User>
EOF
        echo "Minimal configuration created"
    fi
    
    # Wait for config to be written
    sleep 2
fi

# Verify and fix config if needed
if ! grep -q "Port = 8888" "${CONFIG_FILE}"; then
    echo "Adding web listener on port 8888..."
    echo "" >> "${CONFIG_FILE}"
    cat >> "${CONFIG_FILE}" << 'EOL'
<Listener web>
    Port = 8888
    IPv4 = true
    IPv6 = true
    SSL = false
    AllowWeb = true
</Listener>
EOL
fi

# Start ZNC as znc user
echo "Starting ZNC server..."
exec su-exec znc znc --datadir "${CONFIG_DIR}" --foreground
