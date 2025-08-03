const fs = require("fs");
const { PNG } = require("pngjs");

function convertPngToChunky(inputPath, outputPath) {
  // Read the PNG file
  const pngData = fs.readFileSync(inputPath);
  const png = PNG.sync.read(pngData);

  const width = png.width;
  const height = png.height;
  const pixelCount = width * height;

  // Create buffer for chunky binary data (2 bytes per pixel)
  const chunkyBuffer = Buffer.alloc(pixelCount * 2);

  console.log(`Processing ${width}x${height} image (${pixelCount} pixels)`);

  let bufferIndex = 0;

  // Process each pixel
  for (let y = 0; y < height; y++) {
    for (let x = 0; x < width; x++) {
      // Calculate pixel index in PNG data (4 bytes per pixel: RGBA)
      const pngIndex = (y * width + x) * 4;

      // Extract 8-bit RGBA values
      const r8 = png.data[pngIndex];
      const g8 = png.data[pngIndex + 1];
      const b8 = png.data[pngIndex + 2];
      const a8 = png.data[pngIndex + 3];

      // Convert 8-bit values to 4-bit values (0-15)
      const r4 = Math.round((r8 / 255) * 15);
      const g4 = Math.round((g8 / 255) * 15);
      const b4 = Math.round((b8 / 255) * 15);
      const a4 = Math.round((a8 / 255) * 15);

      // Pack into 16-bit value: 0x0RGB (4 bits each)
      const pixel16 = (r4 << 8) | (g4 << 4) | b4;

      // Write as big-endian 16-bit value
      chunkyBuffer.writeUInt16BE(pixel16, bufferIndex);
      bufferIndex += 2;
    }
  }

  // Write the chunky binary file
  fs.writeFileSync(outputPath, chunkyBuffer);
  console.log(`Chunky binary written to: ${outputPath}`);
  console.log(`File size: ${chunkyBuffer.length} bytes`);
}

// Command line usage
function main() {
  const args = process.argv.slice(2);

  if (args.length !== 2) {
    console.log("Usage: node png-to-chunky.js <input.png> <output.bin>");
    console.log("");
    console.log("Converts a PNG image to chunky binary format:");
    console.log("- 16-bit pixels in big-endian format");
    console.log("- 4 bits per channel (RGB, 4 bits unused)");
    console.log("- Format: 0x0RGB");
    process.exit(1);
  }

  const inputPath = args[0];
  const outputPath = args[1];

  // Check if input file exists
  if (!fs.existsSync(inputPath)) {
    console.error(`Error: Input file "${inputPath}" not found`);
    process.exit(1);
  }

  try {
    convertPngToChunky(inputPath, outputPath);
    console.log("Conversion completed successfully!");
  } catch (error) {
    console.error("Error during conversion:", error.message);
    process.exit(1);
  }
}

// Export function for use as a module
module.exports = {
  convertPngToChunky,
};

// Run main function if script is executed directly
if (require.main === module) {
  main();
}
