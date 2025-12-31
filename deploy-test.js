const https = require('https');
const fs = require('fs');

const PROJECT_ID = 'brobuwegghwjhxlptffk';
const API_TOKEN = 'sbp_0820b563c3686474d593f403e6631e290e073331';

console.log('[TEST] Deploying simple function...');

const functionCode = fs.readFileSync('test-function.ts', 'utf8');

const payload = JSON.stringify({ body: functionCode });

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
  res.on('data', (chunk) => { data += chunk; });
  res.on('end', () => {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      console.log('[OK] Deployed!');
      setTimeout(() => {
        https.get(`https://${PROJECT_ID}.supabase.co/functions/v1/latest`, (testRes) => {
          let testData = '';
          testRes.on('data', (chunk) => { testData += chunk; });
          testRes.on('end', () => {
            console.log('[TEST] Response:', testData);
            process.exit(testRes.statusCode === 200 ? 0 : 1);
          });
        });
      }, 3000);
    } else {
      console.log('[FAIL]', res.statusCode, data);
      process.exit(1);
    }
  });
});

req.on('error', (e) => {
  console.error('[ERROR]', e.message);
  process.exit(1);
});

req.write(payload);
req.end();
