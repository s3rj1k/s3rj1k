#!/bin/bash

# This script injects a PDF download button into the generated resume HTML

HTML_FILE="${1:-resume.html}"

# Create temporary file
TEMP_FILE=$(mktemp)

# Read the HTML file and inject the button and styles
awk '
/<\/style>/ {
    print "/* PDF Download Button */"
    print ".pdf-download-btn {"
    print "  position: fixed;"
    print "  top: 20px;"
    print "  right: 20px;"
    print "  background: #2077b2;"
    print "  color: #fff;"
    print "  padding: 12px;"
    print "  border-radius: 6px;"
    print "  text-decoration: none;"
    print "  font-family: Arial, sans-serif;"
    print "  font-size: 14px;"
    print "  font-weight: bold;"
    print "  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);"
    print "  transition: all 0.3s ease;"
    print "  z-index: 1000;"
    print "  cursor: pointer;"
    print "  display: flex;"
    print "  align-items: center;"
    print "  justify-content: center;"
    print "}"
    print ""
    print ".pdf-download-btn:hover {"
    print "  background: #1a5f8f;"
    print "  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);"
    print "  text-decoration: none;"
    print "  transform: translateY(-2px);"
    print "}"
    print ""
    print "@media print {"
    print "  /* Hide PDF button when printing */"
    print "  .pdf-download-btn {"
    print "    display: none;"
    print "  }"
    print "}"
}
/<body>/ {
    print $0
    print ""
    print "  <a href=\"cv.pdf\" class=\"pdf-download-btn\" download=\"Serhii_Ivanov_Resume.pdf\" title=\"Download PDF\">"
    print "    <svg xmlns=\"http://www.w3.org/2000/svg\" width=\"24\" height=\"24\" viewBox=\"0 0 640 640\" fill=\"currentColor\"><!--!Font Awesome Free 7.1.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2025 Fonticons, Inc.--><path d=\"M240 112L128 112C119.2 112 112 119.2 112 128L112 512C112 520.8 119.2 528 128 528L208 528L208 576L128 576C92.7 576 64 547.3 64 512L64 128C64 92.7 92.7 64 128 64L261.5 64C278.5 64 294.8 70.7 306.8 82.7L429.3 205.3C441.3 217.3 448 233.6 448 250.6L448 400.1L400 400.1L400 272.1L312 272.1C272.2 272.1 240 239.9 240 200.1L240 112.1zM380.1 224L288 131.9L288 200C288 213.3 298.7 224 312 224L380.1 224zM272 444L304 444C337.1 444 364 470.9 364 504C364 537.1 337.1 564 304 564L292 564L292 592C292 603 283 612 272 612C261 612 252 603 252 592L252 464C252 453 261 444 272 444zM304 524C315 524 324 515 324 504C324 493 315 484 304 484L292 484L292 524L304 524zM400 444L432 444C460.7 444 484 467.3 484 496L484 560C484 588.7 460.7 612 432 612L400 612C389 612 380 603 380 592L380 464C380 453 389 444 400 444zM432 572C438.6 572 444 566.6 444 560L444 496C444 489.4 438.6 484 432 484L420 484L420 572L432 572zM508 464C508 453 517 444 528 444L576 444C587 444 596 453 596 464C596 475 587 484 576 484L548 484L548 508L576 508C587 508 596 517 596 528C596 539 587 548 576 548L548 548L548 592C548 603 539 612 528 612C517 612 508 603 508 592L508 464z\"/></svg>"
    print "  </a>"
    next
}
{ print }
' "$HTML_FILE" > "$TEMP_FILE"

# Replace original file with modified version
mv "$TEMP_FILE" "$HTML_FILE"

echo "PDF download button injected into $HTML_FILE"
