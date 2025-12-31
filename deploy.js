// Deploy /latest Edge Function to Supabase
const https = require('https');
const fs = require('fs');

const PROJECT_ID = 'brobuwegghwjhxlptffk';
const API_TOKEN = 'sbp_0820b563c3686474d593f403e6631e290e073331';

console.log('==================================================');
console.log('  DEPLOYING /latest EDGE FUNCTION');
console.log('==================================================\n');

// Read function code
console.log('[1/3] Reading function code...');
const functionCode = fs.readFileSync('supabase/functions/latest/index.ts', 'utf8');
console.log(`     Code size: ${functionCode.length} bytes\n`);

// Prepare payload
const payload = JSON.stringify({
  body: functionCode
});

// Deploy
console.log('[2/3] Deploying to Supabase...');

const options = {
  hostname: 'api.supabase.com',
  port: 443,
  path: `/v1/projects/${PROJECT_ID}/functions/latest`,
  method: 'PATCH',
  headers: {
    'Authorization': `Bearer ${API_TOKEN}`,
    'Content-Type': 'application/json',
    'Content-Length': Buffer.byteLength(payload)
  }
};

const req = https.request(options, (res) => {
  let data = '';

  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      console.log('     ✅ Deployment SUCCESS!\n');

      // Test endpoint
      console.log('[3/3] Testing endpoint...');
      setTimeout(() => {
        testEndpoint();
      }, 3000);
    } else {
      console.log(`     ❌ Deployment FAILED: ${res.statusCode}`);
      console.log(`     Response: ${data}`);
      process.exit(1);
    }
  });
});

req.on('error', (error) => {
  console.error(`     ❌ Error: ${error.message}`);
  process.exit(1);
});

req.write(payload);
req.end();

function testEndpoint() {
  const testOptions = {
    hostname: `${PROJECT_ID}.supabase.co`,
    port: 443,
    path: '/functions/v1/latest',
    method: 'GET'
  };

  https.get(testOptions, (res) => {
    let data = '';

    res.on('data', (chunk) => {
      data += chunk;
    });

    res.on('end', () => {
      if (res.statusCode === 200) {
        const response = JSON.parse(data);
        console.log('     ✅ Endpoint TEST SUCCESS!');
        console.log(`     Version: ${response.version}`);
        console.log(`     Download: ${response.download_url}\n`);

        if (response.version === '1.0.24') {
          console.log('==================================================');
          console.log('  ✅ DEPLOYMENT COMPLETE - v1.0.24 LIVE!');
          console.log('==================================================');
          process.exit(0);
        } else {
          console.log(`     ⚠️  Warning: Expected v1.0.24, got ${response.version}`);
          process.exit(1);
        }
      } else {
        console.log(`     ❌ Endpoint test failed: ${res.statusCode}`);
        console.log(`     Response: ${data}`);
        process.exit(1);
      }
    });
  }).on('error', (error) => {
    console.error(`     ❌ Test error: ${error.message}`);
    process.exit(1);
  });
}
