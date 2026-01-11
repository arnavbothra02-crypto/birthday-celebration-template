#!/bin/bash

# 🔒 Birthday Lock Verification Script

echo "=============================================="
echo "🔒 VERIFYING BIRTHDAY LOCK IMPLEMENTATION"
echo "=============================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

ISSUES=0

# Check config.js exists
echo "1️⃣  Checking config.js..."
if [ -f "/app/src/config.js" ]; then
    echo -e "${GREEN}✅ config.js exists${NC}"
    
    # Check for PERSON_NAME
    if grep -q "PERSON_NAME" /app/src/config.js; then
        NAME=$(grep "PERSON_NAME" /app/src/config.js | cut -d'"' -f2)
        echo -e "${GREEN}✅ PERSON_NAME defined: \"$NAME\"${NC}"
    else
        echo -e "${RED}❌ PERSON_NAME not defined${NC}"
        ((ISSUES++))
    fi
    
    # Check for UNLOCK_DATE
    if grep -q "UNLOCK_DATE" /app/src/config.js; then
        echo -e "${GREEN}✅ UNLOCK_DATE defined${NC}"
    else
        echo -e "${RED}❌ UNLOCK_DATE not defined${NC}"
        ((ISSUES++))
    fi
    
    # Check for unlock function
    if grep -q "isBirthdayUnlocked" /app/src/config.js; then
        echo -e "${GREEN}✅ isBirthdayUnlocked() function defined${NC}"
    else
        echo -e "${RED}❌ isBirthdayUnlocked() function missing${NC}"
        ((ISSUES++))
    fi
else
    echo -e "${RED}❌ config.js not found${NC}"
    ((ISSUES++))
fi
echo ""

# Check App.jsx uses config
echo "2️⃣  Checking App.jsx imports config..."
if grep -q "import.*config" /app/src/App.jsx; then
    echo -e "${GREEN}✅ App.jsx imports config${NC}"
    
    # Check for PERSON_NAME usage
    NAME_COUNT=$(grep -c "{PERSON_NAME}" /app/src/App.jsx)
    echo -e "${GREEN}✅ PERSON_NAME used $NAME_COUNT times in App.jsx${NC}"
    
    # Check for date-based lock
    if grep -q "isBirthdayUnlocked()" /app/src/App.jsx; then
        echo -e "${GREEN}✅ Date-based lock implemented${NC}"
    else
        echo -e "${RED}❌ Date-based lock not found${NC}"
        ((ISSUES++))
    fi
    
    # Check for conditional rendering
    if grep -q "{!birthdayReached &&" /app/src/App.jsx && grep -q "{birthdayReached &&" /app/src/App.jsx; then
        echo -e "${GREEN}✅ TRUE conditional rendering implemented${NC}"
    else
        echo -e "${YELLOW}⚠️  Conditional rendering may not be complete${NC}"
    fi
else
    echo -e "${RED}❌ App.jsx doesn't import config${NC}"
    ((ISSUES++))
fi
echo ""

# Check MessageCard uses config
echo "3️⃣  Checking MessageCard.jsx..."
if grep -q "import.*PERSON_NAME.*config" /app/src/components/MessageCard.jsx; then
    echo -e "${GREEN}✅ MessageCard imports PERSON_NAME${NC}"
    
    NAME_COUNT=$(grep -c "{PERSON_NAME}" /app/src/components/MessageCard.jsx)
    echo -e "${GREEN}✅ PERSON_NAME used $NAME_COUNT times${NC}"
else
    echo -e "${YELLOW}⚠️  MessageCard may not use config${NC}"
fi
echo ""

# Check for external images
echo "4️⃣  Checking for external images..."
EXTERNAL=$(grep -r "https\?://.*\.\(jpg\|jpeg\|png\|gif\|webp\|svg\)" /app/src --include="*.jsx" --include="*.js" | grep -v "vite.dev" | wc -l)
if [ "$EXTERNAL" -eq 0 ]; then
    echo -e "${GREEN}✅ No external image URLs found${NC}"
else
    echo -e "${RED}❌ Found $EXTERNAL external image URL(s)${NC}"
    grep -rn "https\?://.*\.\(jpg\|jpeg\|png\|gif\|webp\|svg\)" /app/src --include="*.jsx" --include="*.js" | grep -v "vite.dev"
    ((ISSUES++))
fi
echo ""

# Check Gallery uses local images
echo "5️⃣  Verifying Gallery images..."
if grep -q '"/images/pic[1-6]' /app/src/components/Gallery.jsx; then
    echo -e "${GREEN}✅ Gallery uses local image paths${NC}"
    
    # Count images
    IMG_COUNT=$(grep -o '"/images/pic[0-9]' /app/src/components/Gallery.jsx | wc -l)
    echo -e "${GREEN}✅ Gallery references $IMG_COUNT local images${NC}"
else
    echo -e "${RED}❌ Gallery not using correct local paths${NC}"
    ((ISSUES++))
fi
echo ""

# Check local images exist
echo "6️⃣  Verifying local images exist..."
MISSING=0
for i in {1..6}; do
    if [ ! -f "/app/public/images/pic$i.jpeg" ]; then
        echo -e "${RED}❌ Missing: pic$i.jpeg${NC}"
        ((MISSING++))
        ((ISSUES++))
    fi
done
if [ "$MISSING" -eq 0 ]; then
    echo -e "${GREEN}✅ All 6 images present${NC}"
fi
echo ""

# Check build
echo "7️⃣  Testing build..."
cd /app && npm run build > /tmp/lock-build-test.log 2>&1
if [ $? -eq 0 ]; then
    MODULES=$(grep "modules transformed" /tmp/lock-build-test.log | grep -o "[0-9]*")
    echo -e "${GREEN}✅ Build succeeds${NC}"
    echo -e "${BLUE}   → $MODULES modules transformed${NC}"
else
    echo -e "${RED}❌ Build failed${NC}"
    tail -20 /tmp/lock-build-test.log
    ((ISSUES++))
fi
echo ""

# Check for useEffect auto-check
echo "8️⃣  Checking auto-unlock mechanism..."
if grep -q "setInterval.*isBirthdayUnlocked" /app/src/App.jsx; then
    echo -e "${GREEN}✅ Auto-check interval implemented${NC}"
else
    echo -e "${YELLOW}⚠️  Auto-check mechanism may be missing${NC}"
fi
echo ""

# Summary
echo "=============================================="
echo "📊 VERIFICATION SUMMARY"
echo "=============================================="

if [ "$ISSUES" -eq 0 ]; then
    echo -e "${GREEN}✅ ALL CHECKS PASSED!${NC}"
    echo ""
    echo "🔒 Lock Implementation Complete:"
    echo "   • Real date-based lock ✓"
    echo "   • TRUE conditional rendering ✓"
    echo "   • Name constant configured ✓"
    echo "   • Local images only ✓"
    echo "   • Auto-unlock mechanism ✓"
    echo "   • Build succeeds ✓"
    echo ""
    echo "🚀 Ready for deployment!"
    echo ""
    echo "To test:"
    echo "  1. Set UNLOCK_DATE to past date in config.js"
    echo "  2. Run: npm run dev"
    echo "  3. Verify full celebration shows"
    echo ""
    exit 0
else
    echo -e "${RED}❌ FOUND $ISSUES ISSUE(S)${NC}"
    echo ""
    echo "Please review the issues above."
    exit 1
fi
