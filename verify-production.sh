#!/bin/bash

# 🔍 FINAL PRODUCTION VERIFICATION SCRIPT

echo "================================================"
echo "🚀 PRODUCTION READINESS CHECK"
echo "================================================"
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ISSUES=0
WARNINGS=0

# Check 1: Config constants
echo "1️⃣  Checking configuration constants..."
if [ -f "src/config.js" ]; then
    CONFIG_CONTENT=$(cat src/config.js)
    
    if echo "$CONFIG_CONTENT" | grep -q 'PERSON_NAME = "Swastika"'; then
        echo -e "${GREEN}✅ PERSON_NAME = Swastika${NC}"
    else
        echo -e "${RED}❌ PERSON_NAME not set to Swastika${NC}"
        ((ISSUES++))
    fi
    
    if echo "$CONFIG_CONTENT" | grep -q 'BIRTHDAY_MESSAGE'; then
        MSG=$(echo "$CONFIG_CONTENT" | grep "BIRTHDAY_MESSAGE" | cut -d'"' -f2)
        echo -e "${GREEN}✅ BIRTHDAY_MESSAGE defined${NC}"
        echo -e "${BLUE}   → \"$MSG\"${NC}"
    else
        echo -e "${RED}❌ BIRTHDAY_MESSAGE not defined${NC}"
        ((ISSUES++))
    fi
    
    if echo "$CONFIG_CONTENT" | grep -q 'CLOSING_SIGNATURE.*Arnav'; then
        echo -e "${GREEN}✅ CLOSING_SIGNATURE contains 'Arnav'${NC}"
    else
        echo -e "${RED}❌ CLOSING_SIGNATURE missing 'Arnav'${NC}"
        ((ISSUES++))
    fi
    
    if echo "$CONFIG_CONTENT" | grep -q '2026-02-01'; then
        echo -e "${GREEN}✅ UNLOCK_DATE = Feb 1, 2026${NC}"
    else
        echo -e "${RED}❌ UNLOCK_DATE not Feb 1, 2026${NC}"
        ((ISSUES++))
    fi
else
    echo -e "${RED}❌ config.js not found${NC}"
    ((ISSUES++))
fi
echo ""

# Check 2: No placeholders
echo "2️⃣  Checking for placeholders..."
PLACEHOLDER_COUNT=$(grep -r "\[Name\]\|\[Your Name\]\|Your personalized\|placeholder.*message" src/ --include="*.jsx" --include="*.js" 2>/dev/null | wc -l)
if [ "$PLACEHOLDER_COUNT" -eq 0 ]; then
    echo -e "${GREEN}✅ No placeholders found${NC}"
else
    echo -e "${RED}❌ Found $PLACEHOLDER_COUNT placeholder(s)${NC}"
    grep -rn "\[Name\]\|\[Your Name\]\|Your personalized" src/ --include="*.jsx" --include="*.js" 2>/dev/null
    ((ISSUES++))
fi
echo ""

# Check 3: Gallery images
echo "3️⃣  Checking gallery images..."
if grep -q '"/images/pic[1-6].jpeg"' src/components/Gallery.jsx; then
    echo -e "${GREEN}✅ Gallery uses local image paths${NC}"
    
    for i in {1..6}; do
        if [ -f "public/images/pic$i.jpeg" ]; then
            SIZE=$(du -h "public/images/pic$i.jpeg" | cut -f1)
            echo -e "${GREEN}   ✅ pic$i.jpeg ($SIZE)${NC}"
        else
            echo -e "${RED}   ❌ pic$i.jpeg missing${NC}"
            ((ISSUES++))
        fi
    done
else
    echo -e "${RED}❌ Gallery not using correct image paths${NC}"
    ((ISSUES++))
fi
echo ""

# Check 4: No external images
echo "4️⃣  Checking for external image URLs..."
EXTERNAL_IMG=$(grep -r "https\?://.*\.\(jpg\|jpeg\|png\|gif\)" src/ --include="*.jsx" --include="*.js" 2>/dev/null | grep -v "vite.dev" | wc -l)
if [ "$EXTERNAL_IMG" -eq 0 ]; then
    echo -e "${GREEN}✅ No external image URLs${NC}"
else
    echo -e "${RED}❌ Found $EXTERNAL_IMG external image URL(s)${NC}"
    ((ISSUES++))
fi
echo ""

# Check 5: Date lock logic
echo "5️⃣  Checking date lock implementation..."
if grep -q "isBirthdayUnlocked()" src/App.jsx; then
    echo -e "${GREEN}✅ Date lock function used${NC}"
    
    if grep -q "{!birthdayReached &&" src/App.jsx && grep -q "{birthdayReached &&" src/App.jsx; then
        echo -e "${GREEN}✅ Conditional rendering implemented${NC}"
    else
        echo -e "${RED}❌ Conditional rendering not found${NC}"
        ((ISSUES++))
    fi
    
    if grep -q "setInterval.*isBirthdayUnlocked" src/App.jsx; then
        echo -e "${GREEN}✅ Auto-check mechanism present${NC}"
    else
        echo -e "${YELLOW}⚠️  Auto-check mechanism not found${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "${RED}❌ Date lock not implemented${NC}"
    ((ISSUES++))
fi
echo ""

# Check 6: Build test
echo "6️⃣  Testing production build..."
if npm run build > /tmp/build-check.log 2>&1; then
    BUILD_TIME=$(grep "built in" /tmp/build-check.log | grep -o "[0-9.]*s")
    echo -e "${GREEN}✅ Build succeeds (${BUILD_TIME})${NC}"
    
    # Check dist files
    if [ -f "dist/index.html" ]; then
        echo -e "${GREEN}✅ dist/index.html created${NC}"
    else
        echo -e "${RED}❌ dist/index.html not found${NC}"
        ((ISSUES++))
    fi
    
    # Check dist images
    DIST_IMG_COUNT=$(ls dist/images/pic*.jpeg 2>/dev/null | wc -l)
    if [ "$DIST_IMG_COUNT" -eq 6 ]; then
        echo -e "${GREEN}✅ All 6 images in dist/images/${NC}"
    else
        echo -e "${RED}❌ Only $DIST_IMG_COUNT images in dist/images/${NC}"
        ((ISSUES++))
    fi
    
    # Check bundle includes correct text
    if grep -q "Swastika" dist/assets/*.js 2>/dev/null; then
        echo -e "${GREEN}✅ 'Swastika' in bundle${NC}"
    else
        echo -e "${RED}❌ 'Swastika' not in bundle${NC}"
        ((ISSUES++))
    fi
    
    if grep -q "Arnav" dist/assets/*.js 2>/dev/null; then
        echo -e "${GREEN}✅ 'Arnav' in bundle${NC}"
    else
        echo -e "${RED}❌ 'Arnav' not in bundle${NC}"
        ((ISSUES++))
    fi
else
    echo -e "${RED}❌ Build failed${NC}"
    tail -20 /tmp/build-check.log
    ((ISSUES++))
fi
echo ""

# Check 7: Git status
echo "7️⃣  Checking Git repository..."
if [ -d ".git" ]; then
    echo -e "${GREEN}✅ Git repository present${NC}"
    
    BRANCH=$(git branch --show-current 2>/dev/null)
    echo -e "${BLUE}   Current branch: $BRANCH${NC}"
    
    UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l)
    if [ "$UNCOMMITTED" -eq 0 ]; then
        echo -e "${GREEN}✅ No uncommitted changes${NC}"
    else
        echo -e "${YELLOW}⚠️  $UNCOMMITTED uncommitted changes${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "${RED}❌ Not a git repository${NC}"
    ((ISSUES++))
fi
echo ""

# Check 8: Vercel configuration
echo "8️⃣  Checking Vercel configuration..."
if [ -f "vercel.json" ]; then
    echo -e "${GREEN}✅ vercel.json exists${NC}"
    
    if grep -q '"dist"' vercel.json; then
        echo -e "${GREEN}✅ Output directory: dist${NC}"
    else
        echo -e "${YELLOW}⚠️  Output directory may not be 'dist'${NC}"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}⚠️  vercel.json not found (may use defaults)${NC}"
    ((WARNINGS++))
fi
echo ""

# Check 9: Package.json
echo "9️⃣  Checking package.json..."
if [ -f "package.json" ]; then
    REACT_VERSION=$(grep '"react":' package.json | grep -o "18\.[0-9.]*" || echo "NOT 18")
    if [[ "$REACT_VERSION" == "18."* ]]; then
        echo -e "${GREEN}✅ React version: ^$REACT_VERSION${NC}"
    else
        echo -e "${RED}❌ React version not 18.x${NC}"
        ((ISSUES++))
    fi
    
    if grep -q '"build": "vite build"' package.json; then
        echo -e "${GREEN}✅ Build script configured${NC}"
    else
        echo -e "${RED}❌ Build script not found${NC}"
        ((ISSUES++))
    fi
else
    echo -e "${RED}❌ package.json not found${NC}"
    ((ISSUES++))
fi
echo ""

# Summary
echo "================================================"
echo "📊 VERIFICATION SUMMARY"
echo "================================================"
echo -e "${GREEN}Passed: $((9 - $ISSUES - $WARNINGS))${NC}"
if [ "$WARNINGS" -gt 0 ]; then
    echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
fi
if [ "$ISSUES" -gt 0 ]; then
    echo -e "${RED}Issues: $ISSUES${NC}"
fi
echo ""

if [ "$ISSUES" -eq 0 ]; then
    echo -e "${GREEN}✅ PRODUCTION READY!${NC}"
    echo ""
    echo "✨ All checks passed!"
    echo "🎯 Name: Swastika"
    echo "💌 Message: Custom birthday message"
    echo "✍️  Closing: Forever Yours — Arnav"
    echo "📅 Unlock: February 1, 2026"
    echo "🖼️  Images: 6 local files"
    echo "🔒 Lock: Active"
    echo ""
    echo "🚀 Ready to deploy to Vercel!"
    echo ""
    echo "Next steps:"
    echo "1. Push to GitHub: Use 'Save to GitHub' button"
    echo "2. Vercel will auto-deploy"
    echo "3. Site goes live with countdown"
    echo ""
    exit 0
else
    echo -e "${RED}❌ NOT READY FOR PRODUCTION${NC}"
    echo ""
    echo "Please fix the issues above before deploying."
    exit 1
fi
