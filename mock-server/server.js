// server.js
const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('uni_db.json');
const middlewares = jsonServer.defaults();

server.use(middlewares);
server.use(jsonServer.bodyParser);

let authRequests = [];

// Verify user exists in organization before sending link
server.post('/:organizationSlug/auth/send-link', (req, res) => {
  const { email } = req.body;
  const organizationSlug = req.params.organizationSlug;

  if (!email) {
    return res.status(400).json({ error: 'Email required' });
  }

  // Check if user exists in organization
  const db = router.db.getState();
  const organization = db[organizationSlug];

  if (!organization || !organization.users) {
    return res.status(404).json({ error: 'Organization not found' });
  }

  const userExists = organization.users.some(user => user.email === email);
  if (!userExists) {
    return res.status(404).json({ error: 'User not found in this organization' });
  }

  // If user exists, proceed with sending link
  authRequests.push({ email, organizationSlug, timestamp: Date.now() });
  res.json({ token: '', message: 'Link sent successfully' });
});

server.post('/:organizationSlug/auth/verify-link', (req, res) => {
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
    authRequests = authRequests.filter(r => r !== authRequest);
    res.json({ token, message: 'Verification successful' });
  } else {
    res.status(400).json({ error: 'Invalid or expired link' });
  }
});

// Get users in organization
server.get('/:organizationSlug/users', (req, res) => {
  const organizationSlug = req.params.organizationSlug;
  const email = req.query.email;
  const db = router.db.getState();
  const organization = db[organizationSlug];

  if (!organization || !organization.users) {
    return res.status(404).json([]);
  }

  if (email) {
    const user = organization.users.find(u => u.email === email);
    return res.json(user ? [user] : []);
  }

  res.json(organization.users);
});

server.use(router);
server.listen(3000, () => {
  console.log('JSON Server is running on port 3000');
});