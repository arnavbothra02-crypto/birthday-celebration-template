#!/bin/bash

# 🔍 Vercel Deployment Pre-flight Check Script

echo "================================================"
echo "🚀 VERCEL DEPLOYMENT PRE-FLIGHT CHECK"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check 1: Node version
echo "📦 Checking Node.js version..."
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -ge 18 ]; then
    check_pass "Node.js version: v$NODE_VERSION (Compatible)"
else
    check_fail "Node.js version: v$NODE_VERSION (Need 18 or 20)"
fi
echo ""

# Check 2: Package.json exists
echo "📄 Checking package.json..."
if [ -f "package.json" ]; then
    check_pass "package.json exists"
    
    # Check React version
    REACT_VERSION=$(grep '"react"' package.json | grep -o '18\.[0-9.]*' || echo "NOT FOUND")
    if [[ "$REACT_VERSION" == "18."* ]]; then
        check_pass "React version: ^$REACT_VERSION (Correct)"
    else
        check_fail "React version incorrect (should be 18.x)"
    fi
    
    # Check react-dom version
    REACT_DOM_VERSION=$(grep '"react-dom"' package.json | grep -o '18\.[0-9.]*' || echo "NOT FOUND")
    if [[ "$REACT_DOM_VERSION" == "18."* ]]; then
        check_pass "React-DOM version: ^$REACT_DOM_VERSION (Correct)"
    else
        check_fail "React-DOM version incorrect (should be 18.x)"
    fi
else
    check_fail "package.json not found"
fi
echo ""

# Check 3: Vercel config
echo "⚙️  Checking vercel.json..."
if [ -f "vercel.json" ]; then
    check_pass "vercel.json exists"
    
    if grep -q '"dist"' vercel.json; then
        check_pass "Output directory set to 'dist'"
    else
        check_fail "Output directory not set correctly"
    fi
else
    check_fail "vercel.json not found"
fi
echo ""

# Check 4: Source files
echo "📂 Checking source files..."
if [ -d "src" ]; then
    check_pass "src/ directory exists"
    
    if [ -f "src/components/Countdown.jsx" ]; then
        check_pass "Countdown component exists"
    else
        check_fail "Countdown component missing"
    fi
    
    if [ -f "src/components/MessageCard.jsx" ]; then
        check_pass "MessageCard component exists"
    else
        check_fail "MessageCard component missing"
    fi
else
    check_fail "src/ directory not found"
fi
echo ""

# Check 5: Public assets
echo "🎨 Checking public assets..."
if [ -d "public" ]; then
    check_pass "public/ directory exists"
    
    if [ -d "public/images" ]; then
        IMAGE_COUNT=$(ls -1 public/images/*.jp* 2>/dev/null | wc -l)
        if [ "$IMAGE_COUNT" -gt 0 ]; then
            check_pass "Images found: $IMAGE_COUNT files"
        else
            check_warn "No images found in public/images/"
        fi
    fi
    
    if [ -f "public/music.mp3" ]; then
        check_pass "Music file exists"
    else
        check_warn "Music file not found (optional)"
    fi
else
    check_fail "public/ directory not found"
fi
echo ""

# Check 6: Build test
echo "🔨 Testing build process..."
if npm run build > /tmp/build.log 2>&1; then
    check_pass "Build succeeds"
    
    if [ -d "dist" ]; then
        check_pass "dist/ directory created"
        
        if [ -f "dist/index.html" ]; then
            check_pass "dist/index.html exists"
        else
            check_fail "dist/index.html not generated"
        fi
    else
        check_fail "dist/ directory not created"
    fi
else
    check_fail "Build failed - check /tmp/build.log"
    cat /tmp/build.log
fi
echo ""

# Check 7: Git status
echo "🔧 Checking Git status..."
if git rev-parse --git-dir > /dev/null 2>&1; then
    check_pass "Git repository initialized"
    
    UNTRACKED=$(git status --porcelain 2>/dev/null | grep '^??' | wc -l)
    MODIFIED=$(git status --porcelain 2>/dev/null | grep '^ M' | wc -l)
    
    if [ "$MODIFIED" -gt 0 ]; then
        check_warn "$MODIFIED modified files not committed"
    fi
    
    if [ "$UNTRACKED" -gt 0 ]; then
        check_warn "$UNTRACKED untracked files"
    fi
else
    check_fail "Not a Git repository"
fi
echo ""

# Summary
echo "================================================"
echo "📊 SUMMARY"
echo "================================================"
echo -e "${GREEN}Passed: $PASSED${NC}"
if [ "$FAILED" -gt 0 ]; then
    echo -e "${RED}Failed: $FAILED${NC}"
fi
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}✅ ALL CHECKS PASSED!${NC}"
    echo "Your project is ready for Vercel deployment! 🚀"
    echo ""
    echo "Next steps:"
    echo "1. Commit any remaining changes: git add . && git commit -m 'Ready for deployment'"
    echo "2. Push to GitHub: git push origin main"
    echo "3. Deploy on Vercel: https://vercel.com/new"
    exit 0
else
    echo -e "${RED}❌ SOME CHECKS FAILED${NC}"
    echo "Please fix the issues above before deploying."
    exit 1
fi
