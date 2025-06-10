const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('uni_db.json');
const middlewares = jsonServer.defaults();
const customRoutes = require('./routes.json');

server.use(middlewares);
server.use(jsonServer.bodyParser);
server.use(jsonServer.rewriter(customRoutes));

let authRequests = [];

server.post('/:organizationSlug/auth/send-link', (req, res) => {
  console.log('Raw body:', req.body, 'Type:', typeof req.body);
  const { email } = req.body;
  const organizationSlug = req.params.organizationSlug;
  if (!email) {
    return res.status(400).json({ error: 'Email required' });
  }
  authRequests.push({ email, organizationSlug, timestamp: Date.now() });
  console.log(`Mock: Sent link for ${email} at ${organizationSlug}`);
  res.json({ token: '', message: 'Link sent successfully' });
});

server.post('/:organizationSlug/auth/verify-link', (req, res) => {
  console.log('Raw body:', req.body, 'Type:', typeof req.body);
  const { email } = req.body;
  const organizationSlug = req.params.organizationSlug;
  if (!email) {
    return res.status(400).json({ error: 'Email required' });
  }
  const authRequest = authRequests.find(
    r => r.email === email && r.organizationSlug === organizationSlug
  );
  if (authRequest) {
    const token = `mock_token_${email}_${organizationSlug}`;
    console.log(`Mock: Verified link for ${email} at ${organizationSlug}`);
    res.json({ token, message: 'Verification successful' });
    authRequests = authRequests.filter(r => r !== authRequest);
  } else {
    res.status(400).json({ error: 'Invalid or expired link' });
  }
});

server.use(router);
server.listen(3000, () => {
  console.log('JSON Server is running on port 3000');
});