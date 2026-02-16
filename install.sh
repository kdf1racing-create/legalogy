#!/usr/bin/env bash
set -e

echo "🚀 Installing Legalogy..."

# --- 1. Setup PNPM (User Mode) ---
# We use the standalone installer to avoid npm permission issues (EACCES)
if ! command -v pnpm >/dev/null 2>&1; then
    echo "📦 Installing pnpm (standalone)..."
    # Force install to user local directory
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
    
    # Run the official installer, piping to sh
    curl -fsSL https://get.pnpm.io/install.sh | sh - > /dev/null 2>&1 || true
    
    # Ensure it's in the path for this session
    if [ -d "$PNPM_HOME" ]; then
        export PATH="$PNPM_HOME:$PATH"
    fi
else
    echo "✅ pnpm is already installed."
fi

# Double check pnpm is usable
if ! command -v pnpm >/dev/null 2>&1; then
    echo "❌ Failed to install pnpm. Please install it manually: npm install -g pnpm"
    exit 1
fi

# --- 2. Enforce Node.js v22+ ---
# If system node is old/missing, use pnpm to install a local copy
CURRENT_NODE_VER="0"
if command -v node >/dev/null 2>&1; then
    CURRENT_NODE_VER=$(node -v | cut -d. -f1 | tr -d 'v')
fi

if [ "$CURRENT_NODE_VER" -lt 22 ]; then
    echo "⚠️  System Node.js is v$CURRENT_NODE_VER (requires v22+)."
    echo "⬇️  Installing Node.js v22 via pnpm..."
    
    # Install Node 22 managed by pnpm
    pnpm env use --global 22
    
    # Re-evaluate path/node availability
    if command -v node >/dev/null 2>&1; then
       NEW_VER=$(node -v | cut -d. -f1 | tr -d 'v')
       echo "✅ Now using Node.js v$NEW_VER"
    fi
else
    echo "✅ Node.js $(node -v) detected."
fi

# --- 3. Clone/Update Repository ---
INSTALL_DIR="${HOME}/legalogy"

if [ -d "$INSTALL_DIR" ]; then
    echo "📂 Updating existing installation at $INSTALL_DIR..."
    cd "$INSTALL_DIR"
    git pull
else
    echo "📥 Cloning Legalogy..."
    if ! command -v git >/dev/null 2>&1; then
        echo "❌ Error: git is not installed. Please install git."
        exit 1
    fi
    git clone https://github.com/kdf1racing-create/legalogy.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# --- 4. Install & Build ---
echo "🧶 Installing dependencies..."
pnpm install

echo "🛠️  Building Legalogy..."
pnpm build
pnpm ui:build

# --- 5. Finish ---
echo ""
echo "✅ Installation Complete!"
echo ""
echo "To start Legalogy:"
echo "  cd $INSTALL_DIR"
echo "  ./legalogy.mjs gateway"
echo ""
