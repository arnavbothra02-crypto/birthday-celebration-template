#!/bin/bash

# 🔍 Placeholder Content Verification Script

echo "=============================================="
echo "🔍 VERIFYING NO PLACEHOLDER CONTENT REMAINS"
echo "=============================================="
echo ""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ISSUES=0

# Check for [Name] placeholders
echo "1️⃣  Checking for [Name] placeholders..."
if grep -r "\[Name\]" /app/src --include="*.jsx" --include="*.js" > /dev/null 2>&1; then
    echo -e "${RED}❌ Found [Name] placeholders:${NC}"
    grep -rn "\[Name\]" /app/src --include="*.jsx" --include="*.js"
    ((ISSUES++))
else
    echo -e "${GREEN}✅ No [Name] placeholders found${NC}"
fi
echo ""

# Check for [Your Name] placeholders
echo "2️⃣  Checking for [Your Name] placeholders..."
if grep -r "\[Your Name\]" /app/src --include="*.jsx" --include="*.js" > /dev/null 2>&1; then
    echo -e "${RED}❌ Found [Your Name] placeholders:${NC}"
    grep -rn "\[Your Name\]" /app/src --include="*.jsx" --include="*.js"
    ((ISSUES++))
else
    echo -e "${GREEN}✅ No [Your Name] placeholders found${NC}"
fi
echo ""

# Check for "Swastika" presence
echo "3️⃣  Verifying 'Swastika' is used..."
SWASTIKA_COUNT=$(grep -r "Swastika" /app/src --include="*.jsx" --include="*.js" | wc -l)
if [ "$SWASTIKA_COUNT" -ge 2 ]; then
    echo -e "${GREEN}✅ Found 'Swastika' in $SWASTIKA_COUNT locations${NC}"
else
    echo -e "${YELLOW}⚠️  'Swastika' found in only $SWASTIKA_COUNT locations (expected at least 2)${NC}"
    ((ISSUES++))
fi
echo ""

# Check for external image URLs
echo "4️⃣  Checking for external image URLs..."
if grep -r "https\?://.*\.\(jpg\|jpeg\|png\|gif\|webp\)" /app/src --include="*.jsx" --include="*.js" --include="*.css" > /dev/null 2>&1; then
    echo -e "${RED}❌ Found external image URLs:${NC}"
    grep -rn "https\?://.*\.\(jpg\|jpeg\|png\|gif\|webp\)" /app/src --include="*.jsx" --include="*.js" --include="*.css"
    ((ISSUES++))
else
    echo -e "${GREEN}✅ No external image URLs found${NC}"
fi
echo ""

# Check local images exist
echo "5️⃣  Verifying local images exist..."
MISSING=0
for i in {1..6}; do
    if [ ! -f "/app/public/images/pic$i.jpeg" ]; then
        echo -e "${RED}❌ Missing: pic$i.jpeg${NC}"
        ((MISSING++))
        ((ISSUES++))
    fi
done
if [ "$MISSING" -eq 0 ]; then
    echo -e "${GREEN}✅ All 6 images present (pic1.jpeg - pic6.jpeg)${NC}"
fi
echo ""

# Check Gallery uses local images
echo "6️⃣  Verifying Gallery component uses local images..."
if grep -q '"/images/pic[1-6]\.jpeg"' /app/src/components/Gallery.jsx; then
    echo -e "${GREEN}✅ Gallery uses local image paths${NC}"
else
    echo -e "${RED}❌ Gallery not using correct local image paths${NC}"
    ((ISSUES++))
fi
echo ""

# Check build works
echo "7️⃣  Testing build..."
cd /app && npm run build > /tmp/build-test.log 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build succeeds${NC}"
else
    echo -e "${RED}❌ Build failed - check /tmp/build-test.log${NC}"
    ((ISSUES++))
fi
echo ""

# Check MessageCard has correct content
echo "8️⃣  Verifying MessageCard personalization..."
if grep -q "Happy Birthday, Swastika" /app/src/components/MessageCard.jsx; then
    echo -e "${GREEN}✅ MessageCard heading is personalized${NC}"
else
    echo -e "${YELLOW}⚠️  MessageCard heading may need verification${NC}"
fi

if grep -q "Mother of Dragons, MD" /app/src/components/MessageCard.jsx; then
    echo -e "${GREEN}✅ MessageCard signature is correct${NC}"
else
    echo -e "${YELLOW}⚠️  MessageCard signature may need verification${NC}"
fi
echo ""

# Summary
echo "=============================================="
echo "📊 VERIFICATION SUMMARY"
echo "=============================================="

if [ "$ISSUES" -eq 0 ]; then
    echo -e "${GREEN}✅ ALL CHECKS PASSED!${NC}"
    echo ""
    echo "🎉 No placeholder content found!"
    echo "🖼️  All images are local"
    echo "✨ Personalized for Swastika"
    echo "🚀 Ready for deployment!"
    echo ""
    echo "Next: Push to GitHub and Vercel will redeploy automatically."
    exit 0
else
    echo -e "${RED}❌ FOUND $ISSUES ISSUE(S)${NC}"
    echo ""
    echo "Please review the issues above and fix before deploying."
    exit 1
fi
