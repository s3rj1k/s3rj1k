#!/bin/bash

# This script injects a PDF download button into the generated resume HTML
# Works with both minified and formatted HTML

HTML_FILE="${1:-resume.html}"

# Check if file exists
if [ ! -f "$HTML_FILE" ]; then
    echo "Error: $HTML_FILE not found"
    exit 1
fi

# Check if button is already injected
if grep -q "pdf-download-btn" "$HTML_FILE"; then
    echo "PDF button already exists in $HTML_FILE, skipping injection"
    exit 0
fi

# Create temporary file
TEMP_FILE=$(mktemp)

# Define the CSS to inject (minified on one line)
CSS_INJECTION=".pdf-download-btn{position:fixed;top:20px;right:20px;background:#2077b2;color:#fff;padding:12px;border-radius:6px;text-decoration:none;font-family:Arial,sans-serif;font-size:14px;font-weight:bold;box-shadow:0 2px 8px rgba(0,0,0,0.2);transition:all 0.3s ease;z-index:1000;cursor:pointer;display:flex;align-items:center;justify-content:center}.pdf-download-btn:hover{background:#1a5f8f;box-shadow:0 4px 12px rgba(0,0,0,0.3);text-decoration:none;transform:translateY(-2px)}@media print{.pdf-download-btn{display:none}}"

# Define the button HTML to inject (minified on one line)
BUTTON_HTML='<a href="cv.pdf" class="pdf-download-btn" download="Serhii_Ivanov_Resume.pdf" title="Download PDF"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 640 640" fill="currentColor"><path d="M240 112L128 112C119.2 112 112 119.2 112 128L112 512C112 520.8 119.2 528 128 528L208 528L208 576L128 576C92.7 576 64 547.3 64 512L64 128C64 92.7 92.7 64 128 64L261.5 64C278.5 64 294.8 70.7 306.8 82.7L429.3 205.3C441.3 217.3 448 233.6 448 250.6L448 400.1L400 400.1L400 272.1L312 272.1C272.2 272.1 240 239.9 240 200.1L240 112.1zM380.1 224L288 131.9L288 200C288 213.3 298.7 224 312 224L380.1 224zM272 444L304 444C337.1 444 364 470.9 364 504C364 537.1 337.1 564 304 564L292 564L292 592C292 603 283 612 272 612C261 612 252 603 252 592L252 464C252 453 261 444 272 444zM304 524C315 524 324 515 324 504C324 493 315 484 304 484L292 484L292 524L304 524zM400 444L432 444C460.7 444 484 467.3 484 496L484 560C484 588.7 460.7 612 432 612L400 612C389 612 380 603 380 592L380 464C380 453 389 444 400 444zM432 572C438.6 572 444 566.6 444 560L444 496C444 489.4 438.6 484 432 484L420 484L420 572L432 572zM508 464C508 453 517 444 528 444L576 444C587 444 596 453 596 464C596 475 587 484 576 484L548 484L548 508L576 508C587 508 596 517 596 528C596 539 587 548 576 548L548 548L548 592C548 603 539 612 528 612C517 612 508 603 508 592L508 464z"/></svg></a>'

# Use sed to inject CSS before </style> and button after <body>
sed -e "s|</style>|${CSS_INJECTION}</style>|" \
    -e "s|<body>|<body>${BUTTON_HTML}|" \
    "$HTML_FILE" > "$TEMP_FILE"

# Check if sed was successful
if [ $? -eq 0 ]; then
    # Replace original file with modified version
    mv "$TEMP_FILE" "$HTML_FILE"
    echo "PDF download button successfully injected into $HTML_FILE"
else
    # Clean up temp file on error
    rm -f "$TEMP_FILE"
    echo "Error: Failed to inject PDF button"
    exit 1
fi
