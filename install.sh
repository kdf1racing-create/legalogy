#!/usr/bin/env bash
set -e

# Legalogy Installer

echo "🚀 Installing Legalogy..."

# 1. Check Prerequisites
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Error: git is not installed."
    exit 1
fi

if ! command -v node >/dev/null 2>&1; then
    echo "❌ Error: node is not installed."
    exit 1
fi

# Check Node version (simple check, warns if < 22)
NODE_VER=$(node -v | cut -d. -f1 | tr -d 'v')
if [ "$NODE_VER" -lt 22 ]; then
    echo "⚠️  Warning: Legalogy requires Node.js v22+. You are running $(node -v)."
    echo "   Installation may fail or behave unexpectedly."
    sleep 3
fi

# 2. Install PNPM if missing
if ! command -v pnpm >/dev/null 2>&1; then
    echo "📦 Installing pnpm..."
    npm install -g pnpm
fi

# 3. Setup Directory
INSTALL_DIR="${HOME}/legalogy"
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  Directory $INSTALL_DIR already exists."
    read -p "Overwrite? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborting."
        exit 1
    fi
    rm -rf "$INSTALL_DIR"
fi

# 4. Clone Repository
echo "📥 Cloning Legalogy from GitHub..."
git clone https://github.com/kdf1racing-create/legalogy.git "$INSTALL_DIR"

cd "$INSTALL_DIR"

# 5. Install Dependencies & Build
echo "🧶 Installing dependencies..."
pnpm install

echo "🛠️  Building Legalogy..."
pnpm build
pnpm ui:build

# 6. Finalize
echo "✅ Installation Complete!"
echo ""
echo "To start Legalogy:"
echo "  cd ~/legalogy"
echo "  ./legalogy.mjs gateway"
echo ""
