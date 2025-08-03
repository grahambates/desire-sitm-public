const LOGO_H = 40;

function calculateLineSkips(originalHeight, targetHeight) {
  const results = [];
  const scale = originalHeight / targetHeight;

  for (let outputRow = 0; outputRow < targetHeight; outputRow++) {
    // Map output row to input row using nearest neighbor
    const inputRow = Math.floor(outputRow * scale);
    results.push(inputRow);
  }

  // Calculate skips between consecutive lines
  const skips = [];
  for (let i = 0; i < results.length; i++) {
    if (i === 0) {
      // skips.push(results[i]); // First line: skip to this line
    } else {
      skips.push(results[i] - results[i - 1]); // Skip difference
    }
  }
  skips.push(LOGO_H - results[results.length - 1]);

  return { mappedLines: results, lineSkips: skips };
}

// Generate results for all scaling steps from 1px to 42px
console.log("LogoScales:");
for (let targetHeight = 0; targetHeight <= LOGO_H; targetHeight++) {
  console.log(` dc.l LogoScale${targetHeight}`);
}

console.log(`LogoScale0:`);
for (let i = 0; i < 40; i++) {
  console.log(` dc.w LOGO_MOD_REPT ; rept`);
}

for (let targetHeight = 1; targetHeight <= LOGO_H; targetHeight++) {
  const result = calculateLineSkips(LOGO_H, targetHeight);

  console.log(`LogoScale${targetHeight}:`);
  const diff = LOGO_H - targetHeight;
  const top = Math.floor(diff / 2);
  for (let i = 0; i < top; i++) {
    console.log(` dc.w LOGO_MOD_REPT ; rept`);
  }
  for (let i = 0; i < result.lineSkips.length; i++) {
    const skip = result.lineSkips[i];
    console.log(` dc.w LOGO_BW*(LOGO_BPLS*${skip}-1) ; skip ${skip}`);
  }
  console.log(` dc.w LOGO_MOD ; end`);
  const bottom = LOGO_H - top - result.lineSkips.length - 2;
  for (let i = 0; i < bottom; i++) {
    console.log(` dc.w LOGO_MOD_REPT ; rept`);
  }
}
